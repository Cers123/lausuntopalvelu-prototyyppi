_     = require('underscore')
async = require('async')

db  = "uninitialized"
col = "uninitialized"

FRONT_PAGE_SAMPLES = require('../server/statement_reqs_fake_data').FRONT_PAGE_SAMPLES
MAIJA_LEENA_REQ    = require('../server/statement_reqs_fake_data').MAIJA_LEENA_STATEMENT_REQUEST

AUTHOR_NAME  = "Olli Vetumainen"
AUTHOR_EMAIL = "olli.vetumainen@foo.bar"

MANDATORY_FIELDS = ["title", "cover_text", "deadline", "registration_number"
                    "coauthors", "targets", "text", "sent_at"]

OPTIONAL_FIELDS  = ["readers", "editors"]

COMMENT_FIELDS   = ["name", "comment_text", "agrees"]

SHORT_MONTHS     = ['tammi', 'helmi', 'maalis', 'huhti', 'touko', 'kesä', 'heinä', 'elo', 'syys', 'loka', 'marras', 'joulu']

find_statement_reqs = (h, cb) ->
  col.find(h).sort(raw_deadline: -1).run (err, arr) ->
    if err? cb err, null else cb null, arr

find_statement_req_by_id = (id, cb) ->
  find_statement_reqs {_id: id}, cb

find_statement_reqs_all = (cb) ->
  tl = new Date()
  tl.setDate(tl.getDate()-1)
  col.find({comment_count: {$gt: 0}, raw_deadline: {$gte: tl}}).fields(title: 1, cover_text: 1, 'author.name': 1, 'author.email': 1, deadline: 1,raw_deadline: 1, created_at: 1).sort({raw_deadline: 1}).limit(8).run (err, arr) ->
    return cb? err if err?

    arr = arr.concat(FRONT_PAGE_SAMPLES)
    arr = _.sortBy(arr, (item) -> item.raw_deadline)

    # Strip markup from cover texts and reduce the length
    for item in arr
      item.cover_text = item.cover_text.replace(/(<([^>]+)>)/ig, "")
      item.cover_text = item.cover_text.replace(/\s{2,}/g, " ")
      item.cover_text = item.cover_text.replace("&nbsp;", " ")
      if item.cover_text.length > 400
        item.cover_text = item.cover_text.substring(0, 400).trim()
        item.cover_text = item.cover_text.replace(/\S*$/, "&#8230;")

    cb? null, arr

find_statement_reqs_by_author_email = (email, cb) ->
  find_statement_reqs {"author.email": email}, cb

get_statistics = (id, cb) ->
  find_statement_req_by_id id, (err, json) ->
    return cb? err if err?

    stats = {}
    stats['comments']       = json[0].comment_count
    stats['most_commented'] = []
    stats['respondents']    = []
    stats['agrees']         = 0
    stats['disagrees']      = 0

    most_commented = []
    for section in json[0].sections
      pg = {}
      pg['section_comments' ] = section.section_comments.length
      pg['title']             = section.title.replace(/(<([^>]+)>)/ig, "").replace(/\s/g, " ")
      pg['id']                = section.id
      pg['agrees']            = 0
      pg['disagrees']         = 0

      for comment in section.section_comments
        if comment.agrees then pg['agrees']++ else pg['disagrees']++
        if comment.agrees then stats['agrees']++ else stats['disagrees']++

      most_commented.push(pg) if pg['agrees'] + pg['disagrees'] > 0

    most_commented          = _.sortBy(most_commented, (item) -> -item.section_comments)
    stats['most_commented'] = most_commented.splice(0, 4)

    col.find({_id: id}).fields('targets': 1).run (err, arr) ->
      for item in arr[0].targets
        console.log item
        if item.has_replied
          stats['respondents'].push(
            {
              email: item.email,
              count: item.no_of_comments
          })

      cb? null, [stats]

get_target_status = (id, cb) ->
  col.find({_id: id}).fields(targets: 1).run (err, arr) ->
    return cb? err if err?

    cb? null, arr[0]['targets']

get_statement_req_section_count = (id, cb) ->
  col.find({_id: id}).fields(sections: 1).run (err, arr) ->
    return cb? err if err?

    json = { section_count: arr[0]['sections'].length }

    cb? null, json

get_section_opinion_distribution = (id, section_id, cb) ->
  col.find({_id: id}).fields(sections: 1).run (err, arr) ->
    return cb? err if err?

    section = _.find arr[0].sections, (item) -> item.id.toString() == section_id
    json = {
      agrees: 0,
      disagrees: 0
      }

    for comment in section.section_comments
      if comment.agrees then json.agrees++ else json.disagrees++

    cb? null, json

locate_demo_flow_section = (id, cb) ->
  col.find({_id: id}).fields(sections: 1).run (err, arr) ->
    return cb? err if err?

    section = _.find arr[0].sections, (item) -> item.title.replace(/(<([^>]+)>)/ig, '').replace('&nbsp', '').trim() == "YLEISPERUSTELUT"
    return cb? null, [] if not section?

    json = {
      id: section.id
    }
    cb? null, json

is_author = (id, author, cb) ->
  col.find(_id: id).fields(author: 1).run (err, arr) ->
    return cb false if err?
    return cb false unless arr[0]?.author?.email == author
    return cb true

validate_statement_req = (json, cb) ->
  validate_data json, MANDATORY_FIELDS, OPTIONAL_FIELDS, (err) ->
    if err?
      console.log "Invalid statement request:"
      console.log err
      return cb? err

    cb? null

validate_comment = (json, cb) ->
  validate_data json, COMMENT_FIELDS, [], (err) ->
    if err?
      console.log "Invalid comment:"
      console.log err
      return cb? err

    cb? null

validate_data = (json, required_fields, optional_fields, cb) ->
  err      = []
  json_tmp = _.clone(json)

  for field in required_fields
    if not json_tmp[field]?
      err.push "Missing attribute #{field}"
    else
      if _.isArray json_tmp[field]
        all_empty = true
        for e_field in json_tmp[field]
          for key, val of e_field
            if val != ""
              all_empty = false
              break
        err.push "All values of #{field} empty" if all_empty

      else
        err.push "Missing value for attribute #{field}" if json_tmp[field] == ""
      delete json_tmp[field]

  for field in optional_fields
    delete json_tmp[field] if json_tmp[field]?

  # Unknown fields
  err.push "Unknown attribute #{field}" for field, value of json_tmp

  return cb? null if _.isEmpty(err)
  cb? err

create_statement_req = (json, cb) ->
  json['author']             = {}
  json['author']['name']     = AUTHOR_NAME
  json['author']['email']    = AUTHOR_EMAIL
  json['created_at']         = new Date()
  json['comment_count']      = 0
  json['comments']           = []
  json['sections'] = []

  json['raw_deadline'] = parse_finnish_date json.deadline
  json['sent_at']      = parse_finnish_date json.sent_at

  # Create a different representation of deadline for Transparency
  json['deadline']          = {}
  json['deadline']['day']   = json['raw_deadline'].getDate().toString()
  json['deadline']['month'] = SHORT_MONTHS[json['raw_deadline'].getMonth()]
  json['deadline']['year']  = json['raw_deadline'].getFullYear().toString()

  json['targets']   = _.compact(json['targets'])
  json['coauthors'] = _.compact(json['coauthors'])

  # Get rid of possible empty emails from targets and coauthors
  for list in [json['targets'], json['coauthors']]
    for i in [list.length-1..0] by -1
      break if i < 0

      if list[i].email.trim() == ""
        list.splice(i, 1)

  # No target has yet commented anything
  for target in json.targets
    target['has_replied']    = false
    target['no_of_comments'] = 0

  err = []

  # Add a marker before heading start and then split by that marker
  full_request       = json.text?.replace(/(<h\d.*?>)/g, "##MAGICMARKER##$1")
  # Remove style attributes
  full_request       = full_request.replace(/(<[^>]*)style\s*=\s*('|")[^\2]*?\2([^>]*>)/g, "$1$3")
  json['cover_text'] = json['cover_text'].replace(/(<[^>]*)style\s*=\s*('|")[^\2]*?\2([^>]*>)/g, "$1$3")

  section_id           = 0
  sections_with_titles = 0
  for bodypart in full_request?.split("##MAGICMARKER##")
    continue if bodypart == ""

    title = bodypart.match(/<h\d+.*?>[\s\S]+?<\/h\d+>/)?[0] || "<h3>N/A</h3>"

    # Some weird content may or may not come, including titles with nothing inside
    tmp_title = title.replace(/(<([^>]+)>)/ig, "").replace(/&nbsp;/gi, "")
    if tmp_title.trim() == ""
      title = "<h3>N/A</h3>"

    body  = bodypart.replace(/<h\d+.*?>[\s\S]+?<\/h\d+>/, "")

    # Now try to get rid of the possibly incoming extra b tags. They seem to contain
    # attribute id="internal-source-marker...."
    title = title.replace(/<b id="internal\b[^>]*>([\s\S]*?)<\/b>/gi, "$1")
    body  = body.replace(/<b id="internal\b[^>]*>([\s\S]*?)<\/b>/gi, "$1")

    sections_with_titles++ if title != "<h3>N/A</h3>"

    # Each section needs some kind of ID for attaching comments to
    # certain paragrah.
    item = {id: section_id, title: title, text: body, section_comment_count: 0, section_comments: []}
    json['sections'].push item
    section_id++

  # If there are sections that have titles remove all that have title "N/A". Usually
  # if there are titles there is an additional section coming from CKEditor markup
  # that causes a N/A title to appear, so we want to remove those. But we don't want
  # to skip those while processing because of demo users may not add titles and then
  # nothing would be inserted to db
  if sections_with_titles > 0
    for i in [json['sections'].length-1..0] by -1
      break if i < 0 # Again, just in case

      if json['sections'][i]['title'] == "<h3>N/A</h3>"
        json['sections'].splice(i, 1)

  # Don't insert the raw data to DB
  delete json['text'] if json['text']?
  console.log json

  col.insert(json).run (err, arr) ->
    return cb? err if err?
    id = arr[0]._id
    cb? null, id

add_comment_to_section = (id, section_id, json, cb) ->
  comment        = json
  comment.date   = new Date()
  comment.agrees = comment.agrees == 'true'

  # This returns an array, thus we later use json[0]
  find_statement_req_by_id id, (err, json) ->
    return cb? err if err?

    for section in json[0].sections
      if section.id == section_id
        section.section_comments.push(comment)
        section.section_comment_count = section.section_comments.length
        break

    for target in json[0].targets
      if target.email == comment.name
        target.has_replied = true
        target.no_of_comments++ if target.no_of_comments?

    # Update the whole item.
    col.find({_id: id}).update(json[0]).run (err) ->
      return cb? err if err?
      # Increase comment count after successful update
      col.find({_id: id}).update({$inc: {comment_count: 1}}).run cb


add_comment = (id, json, cb) ->
  # Note this does not increase counters etc like above now since this is not in use
  json.date = new Date()
  col.find({_id: id}).update({$push: {comments: json}}).run (err) ->
    return cb? err if err?
    col.find({_id: id}).update({$inc: {comment_count: 1}}).run cb

update_deadline = (id, json, cb) ->
  return cb? "No deadline set" if not json.deadline?

  json['deadline'] = new Date(json.deadline)

  dl          = {}
  dl['day']   = json['deadline'].getDate().toString()
  dl['month'] = SHORT_MONTHS[json['deadline'].getMonth()]
  dl['year']  = json['deadline'].getFullYear().toString()

  col.find({_id: id}).update({$set: {raw_deadline: json.deadline, deadline: dl}}).run cb

update_targets = (id, json, cb) ->
  col.find({_id: id}).update({$set: {targets: json.targets}}).run cb

add_targets = (id, json, cb) ->
  for target in json.targets
    target['has_replied'] = false
  col.find({_id: id}).update({$pushAll : {targets: json.targets}}).run cb

add_summary = (id, json, cb) ->
  return cb? "No summary given" if (not json.summary? or json.summary == "")
  col.find({_id: id}).update({$set : {summary: json.summary}}).run cb

# Helper, convert dd.mm.yyyy to Date object
parse_finnish_date = (date_str) ->
  parts = date_str.split '.'
  d     = new Date("#{parts[2]}-#{parts[1]}-#{parts[0]}")

exports.init_statement_reqs_api = (settings, app, database) ->
  console.log "Initializing: statement reqs api"
  db  = database
  col = db.collection 'statement_reqs'

  respond_to_get = (err, json, res) ->
    return (console.log err; res.send 500) if err?
    return res.send 404 if (not json? || _.isEmpty(json))
    return res.send json

  app.get "/api/demo_request", (req, res) ->
    res.send MAIJA_LEENA_REQ

  app.get "/api/demo_listing", (req, res) ->
    arr = _.sortBy(FRONT_PAGE_SAMPLES, (item) -> item.raw_deadline)
    res.send arr

  app.get "/api/statement_reqs", (req, res) ->
    find_statement_reqs_all (err, json) ->
      respond_to_get err, json, res

  app.get "/api/statement_reqs/author/:author", (req, res) ->
    find_statement_reqs_by_author_email req.params.author, (err, json) ->
      respond_to_get err, json, res

  app.get "/api/statement_req/:id", (req, res) ->
    find_statement_req_by_id req.params.id, (err, json) ->
      respond_to_get err, json, res

  app.get "/api/statement_req/:id/statistics", (req, res) ->
    get_statistics req.params.id, (err, json) ->
      respond_to_get err, json, res

  app.get "/api/statement_req/:id/target_status", (req, res) ->
    get_target_status req.params.id, (err, json) ->
      respond_to_get err, json, res

  app.get "/api/statement_req/:id/section_count", (req, res) ->
    get_statement_req_section_count req.params.id, (err, json) ->
      respond_to_get err, json, res

  app.get "/api/statement_req/:id/opinions/:section", (req, res) ->
    get_section_opinion_distribution req.params.id, req.params.section, (err, json) ->
      respond_to_get err, json, res

  # Locate section with title YLEISPERUSTELUT from the statement request. This
  # is used on client side to correctly position demo flow comments
  app.get "/api/statement_req/:id/demo_flow_section", (req, res) ->
    locate_demo_flow_section req.params.id, (err, json) ->
      respond_to_get err, json, res


  app.post "/api/create_statement_req", (req, res) ->
    console.log "Create statement request"

    validate_statement_req req.body, (err) ->
      return res.send {err: err}, 422 if err?

      create_statement_req req.body, (err, id) ->
        return res.send 500 if err?
        res.send {id: id}, 200

  # Add a comment to a single section.
  # Should this return some data?
  app.post "/api/statement_req/:id/add_comment_to_section/:section_id", (req, res) ->
    validate_comment req.body, (err) ->
      return res.send {err: err}, 422 if err?

      add_comment_to_section req.params.id, parseInt(req.params.section_id), req.body, (err) ->
        return res.send 500 if err?
        res.send 200

  # Add a comment to the whole statement request
  app.post "/api/statement_req/:id/add_comment", (req, res) ->
    validate_comment req.body, (err) ->
      return res.send {err: err}, 422 if err?

      add_comment req.params.id, req.body, (err) ->
        return res.send 500 if err?
        res.send 200

  app.post "/api/statement_req/:id/update_deadline", (req, res) ->
    update_deadline req.params.id, req.body, (err) ->
      return res.send 500 if err?
      res.send 200

  # Update all target groups (replaces the old ones)
  app.post "/api/statement_req/:id/update_targets", (req, res) ->
    update_targets req.params.id, req.body, (err) ->
      return res.send 500 if err?
      res.send 200

  # Add new target groups (appends the old ones)
  app.post "/api/statement_req/:id/add_targets", (req, res) ->
    add_targets req.params.id, req.body, (err) ->
      return res.send 500 if err?
      res.send 200

  app.post "/api/statement_req/:id/add_summary", (req, res) ->
    add_summary req.params.id, req.body, (err) ->
      return res.send 500 if err?
      res.send 200

# Export functions so we can test them
exports.init_testing             = (database) ->
  db  = database
  col = db.collection 'statement_reqs'

exports.create_statement_req     = create_statement_req
exports.add_comment_to_section   = add_comment_to_section
exports.add_comment              = add_comment
exports.update_deadline          = update_deadline
exports.update_targets           = update_targets
exports.add_targets              = add_targets
exports.add_summary              = add_summary
exports.get_statistics           = get_statistics
exports.get_target_status        = get_target_status
