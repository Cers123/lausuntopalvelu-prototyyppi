petitionFormTemplate = null

datePickerOptions =
  firstDay: 1
  dateFormat: 'dd.mm.yy'
  showOn: 'both'
  defaultDate: null
  #maxDate: new Date()
  buttonImageOnly: true
  buttonImage: '/img/calendar-icon.png'
  monthNames: ['Tammikuu', 'Helmikuu', 'Maaliskuu', 'Huhtikuu', 'Toukokuu', 'Kesäkuu', 'Heinäkuu', 'Elokuu', 'Syyskuu', 'Lokakuu', 'Marraskuu', 'Joulukuu']
  dayNamesMin: ['Su', 'Ma', 'Ti', 'Ke', 'To', 'Pe', 'La']
  onClose: () ->
    this.focus()

TARGETS = [
  {
    title: 'SAK'
    emails: ['erkki.esimerkki@sak.fi', 'lissu.littana@sak.fi']
  }
  {
    title: 'Työ- ja elinkeinoministeriö'
    emails: ['eino.elinkeino@tem.fi']
  }
  {
    title: 'Oikeusministeriö'
    emails: ['erkki.halonen@om.fi','kirsi.koskinen@om.fi']
  }
  {
    title: 'Sisäasiainministeriö'
    emails: ['mikko.mäkinen@intermin.fi','reetta.turpeinen@intermin.fi']
  }
  {
    title: 'Puolustusministeriö'
    emails: ['risto.kuutti@defmin.fi']
  }
  {
    title: 'Valtiovarainministeriö'
    emails: ['tero.laine@vm.fi','paivi.lappalainen@vm.fi']
  }
  {
    title: 'Opetus- ja kulttuuriministeriö'
    emails: ['pertti.järvinen@minedu.fi']
  }
  {
    title: 'Maa- ja metsätalousministeriö'
    emails: ['veikko.huhtinen@mmm.fi']
  }
  {
    title: 'Liikenne- ja viestintäministeriö'
    emails: ['harri.torikka@lvm.fi','saila.hietanen@lvm.fi']
  }
  {
    title: 'Sosiaali- ja terveysministeriö'
    emails: ['keijo.virtanen@stm.fi']
  }
  {
    title: 'Ympäristöministeriö'
    emails: ['timo.lahtinen@ymparisto.fi', 'katja.mikkonen@ymparisto.fi']
  }
]

# Section IDs in the same order as the comments are in SAMPLE_COMMENTS
# relative to section ID of section with title "YLEISPERUSTELUT"
DEMO_FLOW_COMMENT_MAP = [2, 3, 6, 12, 15]
SAMPLE_COMMENTS = [
# Yleistä
  "Näemme Suomen elektroniikka- ja ohjelmistoteollisuuden osaamispohjan matkaviestintä- ja paikannuratkaisuissa hyvänä lähtökohtana kansainväliselle menestykselle tietullien ja vastaavien tiemaksujen keräämiseen tarkoitetuissa tuotteissa. Suomen ICT-ala on suurten strategisten muutosten takia käymistilassa, joten uusien tulevaisuuteen katsovien mahdollisuuksien avaamiselle on hyvät edellytykset.",
# 1.2 Muut maat
  "Pidämme yhteensopivuutta ja avoimia standardeja eri maiden ja järjestelmien välillä Euroopassa toivottavana sekä kuluttaja- että liiketoimintanäkökulmasta. Kuluttajanäkökulmasta yhteensopivuus takaa vaivattoman käyttökokemuksen siten että pysähtymistarvetta tietullipisteisiin ei synny. Toisaalta tämän yhteensopivuuden takaamiseksi mielestämme avoimet standardit ovat välttämättömiä. Avoimet standardit mahdollistavat toisaalta helpomman markkinoilletulon myös Suomalaisille toimittajille.",
# 3. Esityksen vaikutukset
  "Pidämme yhden laskun ja yhden palvelun periaatetta toivottavana.",
# 4. Suhde perustuslakiin ja säätämisjärjestys
  "Mielestämme on tuotava selvästi esille, että ehdotettava laki ei aseta tienkäyttömaksuja ja että tällainen mahdollinen laki tulevaisuudessa on erillinen. Lisäksi ehdotuksen yhteys yksityisyydensuojaan on selvitettävä tarkemmin. Perustuslaki takaa että jokaisen yksityiselämä on turvattu sekä antaa lainsäädäntötoimeksiannon asiaa koskien. Lisäksi perustuslakivaliokunta on selventänyt henkilötietojen suojaa. Esimerkiksi yksityisyyden suojasta työelämässä säädetään erikseen lailla, ja tähän liittyvät kysymykset lienevät relevantteja varsinkin raskasta- ja taksiliikennettä koskien. ",

# Laki - 2§ Lain soveltamisala
 "Tämä laki ei koske tienkäyttömaksujärjestelmiä, joissa tienkäyttömaksujen kerääminen ei tapahdu sähköisesti, eikä järjestelmiä, joissa ajoneuvoon ei asenneta erillistä järjestelmään kuuluvaa sähköteknistä laitetta.” On vielä syytä harkita, halutaanko osa tai kaikki säädökset, joita lain perusteella esimerkiksi valtioneuvosto tulee säätämään, ulottaa myös esimerkiksi matkapuhelimilla toteutettaviin tietullien keräysjärjestelmiin. Tätä on syytä harkita erityisesti siksi että soveltamalla matkapuhelimiin tehtyjä ohjelmistoratkaisuita yhtenä maksujärjestelmän vaihtoehtona adoptio olisi nopeampaa ja siirtymäaikaa voitaisiin mahdollisesti lyhentää."
]

DIRECTIVES = {


  targets:
    email: (elem) ->
      if this.has_replied
        elem.removeClass('pending')
        elem.addClass('confirmed')
      this.email

    "dropdown_filter@value": () -> this.email

  "navi-view-request@href": (elem) ->
    if this._id
      elem.attr("href", "/#/pyynto/tarkastele/#{this._id}")
      return

  "navi-choose-statements@href": (elem) ->
    if this._id
      elem.attr("href", "/#/valitse-lausunnot/valitse/#{this._id}")
      return

  "navi-create-summary@href": (elem) ->
    if this._id
      elem.attr("href", "/#/luo-yhteenveto/luo/#{this._id}")
      return

  most_commented:
    title: (elem) ->
      t = decodeHtml(this.title)
      if t.length > 24
          t.substr(0, 21) + '...'

    agrees: (elem) ->
      setOpinionDistribution elem, this.agrees
      return

    disagrees: (elem) ->
      setOpinionDistribution elem, this.disagrees
      return

  sections:
    summarytitle: (elem) ->
      this.title

    'summarytitle@id': (elem) ->
      if this.id?
        "summary-chapter-id-#{this.id}"

    plaintitle: (elem) ->
      elem.addClass("text-and-statement")
      elem.click () ->
        $(this).next('.visible').slideToggle('fast')
        $(this).toggleClass('open')
        return false
      this.title

    'plaintitle@id': (elem) ->
      if this.id?
        "new-statement-chapter-id-#{this.id}"

    title: (elem) ->
      if this.section_comments.length > 0
        elem.addClass("text-and-statement")
        elem.click () ->
          $(this).next().next('.visible').slideToggle('fast')
          $(this).toggleClass('open')
          return false
        return

    'title@id': (elem) ->
      if this.id?
        "ss-chapter-id-#{this.id}"

    section_comment_count: (elem) -> this.section_comment_count.toString()

    section_comments:
      date: (elem) ->
        d = new Date(this.date.replace(/\-/ig, '/').split('.')[0].replace('T', ' '))
        d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear()
      agrees: (elem) ->
        if this.agrees
          'Samaa mieltä'
        else
          elem.removeClass('agree')
          elem.addClass('disagree')
          'Eri mieltä'

  'title@id': (elem) ->
    if this._id?
      "fp-article-id-#{this._id}"
  author:
    'name@href': (elem) ->
      if this.email?
        "mailto:" + this.email
  created_at: (elem) ->
    d = new Date(this.created_at.replace(/\-/ig, '/').split('.')[0].replace('T', ' '))
    d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear()

  nicedeadline: (elem) ->
    d = new Date(this.raw_deadline.replace(/\-/ig, '/').split('.')[0].replace('T', ' '))
    d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear()

  summarydeadline: (elem) ->
    d = new Date(this.raw_deadline.replace(/\-/ig, '/').split('.')[0].replace('T', ' '))
    d.setDate(d.getDate() + 6*7) # Add six weeks to deadline of statements
    d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear()

  respondentname: (elem) ->
    elem.val(this.respondentname)
    this.respondentname

  sharedperson: (elem) ->
    if this.replied
      elem.removeClass("pending")
      elem.addClass("confirmed")
    elem.removeClass('dummy')
    elem.click () ->
      showMyComments $(this).text()
    this.email

  sharedpersonagrees: (elem) ->
    if this.agrees
      'Samaa mieltä'
    else
      elem.removeClass('agree')
      elem.addClass('disagree')
      'Eri mieltä'

  sharedpersondate: (elem) ->
    d = new Date(this.sharedpersondate.replace(/\-/ig, '/').split('.')[0].replace('T', ' '))
    d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear()
}

decodeHtml = (s) ->
  d = $("<div/>").html(s).text()
  $.trim d

validateEmail = (email) ->
  re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  return re.test email

setOpinionDistribution = (elem, votes, width = 5) ->
  if parseInt(votes) == 0
    elem.hide()
  else
    elem.show()
    w = parseInt(votes) * width
    w = 35 if w > 35
    elem.css("width": "#{w}px")
  return

# All opinions on create summary page
updateOpinionDistribution = (id) ->
  $.get '/api/statement_req/' + id + '/statistics', (data, status) ->
    if status == 'success'
      total     = parseInt(data[0]['comments'])
      agrees    = parseInt(data[0]['agrees'])
      disagrees = parseInt(data[0]['disagrees'])

      agrees    = if total > 0 then Math.floor(agrees / total * 75)  else 0
      disagrees = if total > 0 then Math.floor(disagrees / total * 75)  else 0

      red_bar = $($('#page-luo-yhteenveto .opinion-distribution')[0]).find('.red-bar')
      green_bar = $($('#page-luo-yhteenveto .opinion-distribution')[0]).find('.green-bar')
      setOpinionDistribution $(red_bar), disagrees, 1
      setOpinionDistribution $(green_bar), agrees, 1

createSideExtras = (id) ->
  template = $('.aside-extra-template').find('.aside-extra')

  $('.text-and-statement').each () ->
    comments   = $(this).next().text()
    container  = $(this)
    section_id = container.attr("id").match(/[a-f0-9]+$/)

    $("h1,h2,h3,h4,h5,h6", container).each () ->
      heading = $(this)
      tpl     = $(template).clone()

      # # Update number of comments
      $(tpl).find('.section_comment_count').text(comments)

      # # Get opinion distribution and update it
      green_bar = $(tpl).find('.green-bar')
      red_bar   = $(tpl).find('.red-bar')

      $.get '/api/statement_req/' + id + '/opinions/' + section_id, (data, status) ->
        if status == 'success'
          setOpinionDistribution green_bar, data.agrees
          setOpinionDistribution red_bar, data.disagrees

          heading.append(tpl)

addSummaryPageComments = ->
  template = $('.statement-template').find('.statement')

  commentators = []

  $('.summarytitle', $('#page-luo-yhteenveto')).each () ->
    id = $(this).attr("id").match("[0-9]+$")
    prev_page_item  = $("#ss-chapter-id-#{id}")[0]

    if prev_page_item?
      # Construct comment section
      comment_section   = $(prev_page_item).next().next()
      comment_container = $(this).next()

      comments_added = false
      $('input:checked', $(comment_section)).each () ->
        tpl = template.clone()

        # Read info from the previous page
        comment = $(this).parent().parent().parent().next().html()
        agrees  = $(this).parent().parent().prev().text()
        date    = $(this).parent().parent().prev().prev().text()
        target  = $(this).parent().parent().prev().prev().prev().text()

        $(tpl).find(".opinion").attr("class", $(this).parent().parent().prev().attr("class"))

        $(tpl).find(".name").text(target)
        $(tpl).find(".date").text(date)
        $(tpl).find(".opinion").text(agrees)
        $(tpl).find(".text").html(comment)

        comment_container.append(tpl)
        commentators.push(target)
        comments_added = true

      comment_container.removeClass("hide-all") if comments_added

  commentators = _.uniq(commentators)
  if commentators.length > 0
    commentators.unshift('Piilota kaikki')
    commentators = $.map commentators, (i) -> { respondentname: i }
    $('.respondents', $('#page-luo-yhteenveto')).render commentators, DIRECTIVES

    # Set selection handler
    $('.respondents', $('#page-luo-yhteenveto')).change () ->
      target = $(this).val()
      $('.article .statement', $('#page-luo-yhteenveto')).each () ->
        if $(this).find('.name').text() == target
          $(this).find('p.text').slideDown('fast')
          $(this).removeClass('hide-more')
        else
          $(this).find('p.text').slideUp('fast')
          $(this).addClass('hide-more')
      return false
  else
    commentators = { respondentname: 'Ei valittuja lausuntoja' }
    $('.respondents', $('#page-luo-yhteenveto')).render commentators, DIRECTIVES

showMyComments = (email) ->
  $('div.article div.sections div.plaintitle', $('#page-uusi-lausunto')).each () ->
    $(this).next().slideUp('fast')
    $(this).removeClass('open')

    if $("a.name:contains('#{email}')", $(this).next()).length > 0
      $(this).next().slideDown('fast')
      $(this).addClass('open')

  false

setHighlightSummaryContent = ->
  data = []

  found_some = false
  # Browse through the titles
  $('.summarytitle', $('#page-luo-yhteenveto')).each () ->
    titlehighlights = {}
    current_title = $.trim $(this).text()

    # And their statements
    $('.statement', $(this).next()).each () ->
      commentator = $.trim $(this).find('.name').text()

      $('.highlight', $(this)).each () ->
        highlight = $.trim $(this).text()

        if highlight != ""
          found = false
          for d in data
            if d.title == current_title
              if d.name == commentator
                found = true
                d.highlights.push({ highlighted_text: highlight })

          if not found
            d = {
              title: current_title,
              name: commentator,
              highlights: [
                {highlighted_text: highlight}
              ]
            }

            data.push(d)

  $('.statement_section', $('#modal-summary')).render data
  $('.statement_section', $('#modal-summary')).sortable()
  if data.length > 0
    $('.no-statements', $('#modal-summary')).hide()
  else
    $('.no-statements', $('#modal-summary')).show()


renderMostCommented = (id) ->
  $.get '/api/statement_req/' + id + '/statistics', (data, status) ->
    if status == "success" and data[0].comments > 0
      mc_template = $('.most_commented_template', $('#page-pyynto')).clone()

      mc_template.removeClass("most_commented_template")
      mc_template.removeClass("hide-all")
      mc_template.addClass("most_commented")

      $(mc_template).render data, DIRECTIVES
      $('.most_commented', $('#page-pyynto')).replaceWith($(mc_template))

      # Then update the section with names of those who have commented
      $('.responded', $('#page-pyynto')).empty()
      for target in data[0].respondents
        c_template = $('.responded_template', $('#page-pyynto')).find('a').clone()
        title = target.email
        if title.length > 33
          title = title.substr(0, 30) + '...'
        title += " (" + target.count + ")"
        c_template.text(title)
        $('.responded', $('#page-pyynto')).append(c_template)

# This one generates UI candy only comments on the page where a new statement is given
launchFakeCommentGenerator = (emails) ->

  comment_shift = 2
  generateComments = ->
    comments_per_target = Math.floor(SAMPLE_COMMENTS.length / emails.length)
    comments_per_target = 1 if comments_per_target < 1

    comment_idx = 0
    d = new Date()
    for email in emails
      if not email.replied
        for i in [0..comments_per_target-1]
          # Add comments
          comment = {
            comment_text: SAMPLE_COMMENTS[comment_idx],
            name:         email.sharedperson,
            sharedpersonagrees:       [true, false][Math.floor(Math.random() * 2)]
            sharedpersondate:         new Date().toString()
          }

          section = DEMO_FLOW_COMMENT_MAP[comment_idx] + comment_shift
          comment_container = $('#new-statement-chapter-id-' + section, $('#page-uusi-lausunto')).next()

          template = $('.statement-template', $('#page-uusi-lausunto')).find('.statement-static').clone()

          template.render comment, DIRECTIVES

          template.find('.remove').click () ->
            $(this).parent().parent().hide()
            false

          template.insertBefore($('.commentbox', comment_container))

          email.replied = true
          comment_idx++
          if comment_idx >= SAMPLE_COMMENTS.length
            comment_idx = 0

    $('.users .user', $('#modal-share')).each () ->
      # Add to share dialog as well so resharing does not multiply comments
      $(this).addClass('confirmed')


    $('.shared_to', $('#page-uusi-lausunto')).render emails, DIRECTIVES

  setTimeout generateComments, 2000

# This one generates comments to a new statement request and these are stored to DB
launchGenerateComments = (id) ->

  targets_who_reply    = 0
  targets_replied      = 0
  section_count        = 0
  comments_per_target  = 0

  # Demo flow related
  demo_flow            = false
  total_comments       = 0
  marked_section       = 0

  commented_sections = {}

  addSimpleCommentToRandomSection = (id, commentator, comment_no, max_comments, cb) ->
    if commented_sections[commentator].length >= (0.9 * section_count)
      cb? null

    agrees = [true, false][Math.floor(Math.random() * 2)]
    comment = {
      comment_text: if agrees then "Kannatamme tätä kohtaa" else "Vastustamme tätä kohtaa"
      name:         commentator
      agrees:       agrees
    }


    target_chapter = null
    loop_count     = 0
    while true
      target_chapter       = Math.floor(Math.random() * section_count)

      found = false
      for num in commented_sections[commentator]
        if num == target_chapter
          found = true

      break if not found

      if loop_count == section_count
        break
      target_chapter = null
      loop_count++

    return cb? null if not target_chapter?

    $.post '/api/statement_req/' + id + '/add_comment_to_section/' + target_chapter, comment, (data, status) ->
      comment_no++
      commented_sections[commentator].push target_chapter
      if comment_no < max_comments
        addSimpleCommentToRandomSection id, commentator, comment_no, max_comments, cb
      else
        cb? null

  addComment = (id, commentator, comment_no, cb) ->
    target_chapter = 0
    comment        = {
      comment_text: ''
      name:         commentator
      agrees:       [true, false][Math.floor(Math.random() * 2)]
    }

    # In demo flow just go through the comments in order
    if demo_flow
      # Because of making sure all comments are added we can run out of comments
      if total_comments >= SAMPLE_COMMENTS.length
        random_comments_per_target = Math.floor(Math.random() * 6 + 6)
        return addSimpleCommentToRandomSection id, commentator, 0, random_comments_per_target, cb

      comment.comment_text = SAMPLE_COMMENTS[total_comments]
      target_chapter       = marked_section + DEMO_FLOW_COMMENT_MAP[total_comments]

    else
      target_chapter       = Math.floor(Math.random() * section_count)
      comment.comment_text = "ESIMERKKIKOMMENTTI: " + SAMPLE_COMMENTS[Math.floor(Math.random() * SAMPLE_COMMENTS.length)]

    $.post '/api/statement_req/' + id + '/add_comment_to_section/' + target_chapter, comment, (data, status) ->
      return cb? "Failed to post comment" if status != "success"

      comment_no++
      total_comments++

      # In demo flow we don't want to have more than one comment from a commentator for a certain section
      commented_sections[commentator] = [] unless commented_sections[commentator]?
      commented_sections[commentator].push target_chapter

      if comment_no < comments_per_target
        addComment id, commentator, comment_no, cb
      else
        # Add some random comments
        if demo_flow
          random_comments_per_target = Math.floor(Math.random() * 6 + 6)
          addSimpleCommentToRandomSection id, commentator, 0, random_comments_per_target, cb
        else
          cb? null

  generateComments = ->
    targets = $('.article ul.targets.recipients', $('#page-pyynto'))
    if targets_who_reply == 0
      max = $('.email', targets).length
      targets_who_reply = Math.floor(max * (Math.random() * 0.3 + 0.7))
      targets_who_reply = 1 if targets_who_reply < 1

      # Get section count so comments can be placed on random sections
      $.get '/api/statement_req/' + id + '/section_count', (data, status) ->
        if status == 'success'
          section_count = data.section_count
          demo_flow = (section_count > 18 and section_count < 22)

          comments_per_target = Math.floor(section_count / targets_who_reply * 0.6)
          comments_per_target = 1 if comments_per_target < 1

          if demo_flow
            res = $.get '/api/statement_req/' + id + '/demo_flow_section', (data, status) ->
              if status == 'success'
                marked_section      = data.id
                comments_per_target = Math.ceil(SAMPLE_COMMENTS.length / targets_who_reply)
                return generateComments()

            res.error () ->
              # Leave demoflow
              demo_flow = false
              generateComments()

          else
            generateComments()
    else
      # Choose who is going to comment now, to which chapter, and what
      recipients     = $('.email.pending', targets)
      commentator    = recipients[Math.floor(Math.random() * recipients.length)]
      addComment id, $(commentator).text(), 0, (err) ->
        if not err?
          $(commentator).removeClass('pending')
          $(commentator).addClass('confirmed')
          targets_replied++

          renderMostCommented id

          if demo_flow
            if total_comments < SAMPLE_COMMENTS.length
              setTimeout generateComments, Math.random() * 3000

          else
            if targets_replied < targets_who_reply
              # Next commentor max. 3 seconds from now
              setTimeout generateComments, Math.random() * 3000

  setTimeout generateComments, 5000

createTargetFilters = (page, data) ->
  targets = data[0].targets
  $page   = $(page)
  $select = $page.find('.dropdown select')
  $option = $page.find('.dropdown-filter').detach()
  $select.append $option.clone().val('Kaikki').text('Kaikki')
  for target in targets
    if target.has_replied
      $select.append $option.clone().val(target.email).text(target.email)

  # handle filter selection
  $select.unbind('change').change () ->
    $('.hide-all-link').trigger 'click'
    unbindTitleHandlers $page
    filterStatements $(this).val(), $page
    bindTitleHandlers $page
    updateSideExtras $page
    setSelectAllStatus()

QUOTE_STASH = {}
FILTER_STASH = []

selectAllComments = () ->
  $checkboxes = $('#page-valitse-lausunnot .statement-static input[name=include]')
  $checkboxes.attr 'checked', true

unselectAllComments = () ->
  $checkboxes = $('#page-valitse-lausunnot .statement-static input[name=include]')
  $checkboxes.attr 'checked', false

setSelectAllStatus = () ->
  checked = $('#page-valitse-lausunnot .statement-static input[name=include]:checked').length
  total   = $('#page-valitse-lausunnot .statement-static input[name=include]').length

  if checked == 0
    $('#select-all-statements', $('#page-valitse-lausunnot')).attr('checked', false)
    $('#select-all-statements', $('#page-valitse-lausunnot')).prop('indeterminate', false)
  else if checked == total
    $('#select-all-statements', $('#page-valitse-lausunnot')).attr('checked', true)
    $('#select-all-statements', $('#page-valitse-lausunnot')).prop('indeterminate', false)
  else
    $('#select-all-statements', $('#page-valitse-lausunnot')).attr('checked', true)
    $('#select-all-statements', $('#page-valitse-lausunnot')).prop('indeterminate', true)

titleOfComment  = (comment) -> $(comment).parent().parent().prevAll('.title:first')
commentsOfTitle = (title)   -> $(title).nextAll('.visible:first').find('.statement-static')

updateSideExtras = (context) ->
  $context = $(context)
  $context.find('.title .aside-extra').each () ->
    $this       = $(this)
    $title      = $this.parents('.title:first')
    $comments   = commentsOfTitle $title
    $highlights = $comments.find('.highlight')
    $this.find('.section_comment_count').text $comments.length
    $this.find('.markings').text $highlights.length
    setOpinionDistribution $this.find('.red-bar'), $comments.find('.disagree').length
    setOpinionDistribution $this.find('.green-bar'), $comments.find('.agree').length
    $highlights.trigger('showsidenote')

bindTitleHandlers = (context) ->
  $context = $(context)
  $context.find('.title.text-and-statement').each () ->
    $this = $(this)
    $this.click () ->
      $this.nextAll('.visible:first').slideToggle('fast')
      $this.toggleClass('open')
      return false

unbindTitleHandlers = (context) ->
  $context = $(context)
  $context.find('.title.text-and-statement').unbind 'click'

popStatementFilterStash = () ->
  for item in FILTER_STASH
    $item = $(item.location).append $(item.content)
    $title = $item.parent().prevAll('.title:first')
    $title.addClass('text-and-statement')
  FILTER_STASH = []

filterStatements = (target_filter, context) ->
  $context = $(context)
  popStatementFilterStash()
  $context.find('.aside-extra').show()
  return if target_filter == "Kaikki"
  $statement_infos = $context.find(".statement-static .info")
  $filter          = $statement_infos.not(":contains(\'#{target_filter}\')").parent()
  $filter.each () ->
    $this  = $(this)
    $title = titleOfComment $this
    FILTER_STASH.push
      content  : $this
      location : $this.parent()
    $this.detach()
    $this.find('.highlight').trigger('hidesidenote')
    # check if all comments have been detached and remove related classes
    if commentsOfTitle($title).length == 0
      $title.removeClass('open text-and-statement')
      $title.find('.aside-extra').hide()

getStatementReqs = (cb) ->
  $.get "/api/statement_reqs", (sreqs) ->
    cb null, sreqs
getStatementReqsByOwner = (owner, cb) ->
  $.get "/api/statement_reqs/owner/#{owner}", (sreqs) ->
    cb null, sreqs
getStatementReqById = (id, cb) ->
  $.get "/api/statement_req/#{id}", (sreqs) ->
    cb null, sreqs[0]

commentHighlights = (page) ->
  $('.toggle-note-mode').unbind('click').click () ->
    page.toggleClass('adding-notes')
    false

  rangy.init()
  cssApplier = rangy.createCssClassApplier("highlight", {normalize: true})

  $('.comment_text').unbind('mouseup').mouseup ->
    text = $(this)
    sel = rangy.getSelection()
    if text.parents('.page').hasClass('adding-notes')
      if sel.toString().length > 4 and text.text().indexOf sel.toString >= 0
        cssApplier.applyToSelection()
        text.prev('.info').find('input[name=include]').attr 'checked', true
        text.prev('.info').find('input[name=include]').change()

        hls = text.parents('.section_comments').find('.highlight')
        notes = text.parents('.section_comments').siblings('.aside-notes')
        extra = text.parents('.visible').prev().prev().find('.aside-extra')
        markCount = extra.find('.markings')
        markCount.text hls.filter(->
          $(this).text().length > 0
        ).length
        notes.children('.marking-short').remove()
        hls.each () ->
          hl = $(this)
          if hl.text().length > 4
            note = $('<div class="marking-short" />')
            hltext = hl.text()
            note.text if hltext.length < 35 then hltext else hltext.substr(0, 33) + '...'
            hl.bind 'showsidenote', () -> note.show() #custom binds to support filter functionality
            hl.bind 'hidesidenote', () -> note.hide() #
            closeHL = () ->
              hl.find('.close').remove()
              hl.contents().unwrap()
              note.remove()
              markCount.text text.find('.highlight').filter(->
                $(this).text().length > 0
              ).length
            $('<span class="close"/>').click(() ->
              closeHL()
            ).appendTo note
            hl.find('.close').remove()
            hl.append $('<span class="close"/>').click () ->
              closeHL()
            notes.append note
          else
            hl.remove()
      sel.removeAllRanges()

Controller =
  index: () ->
    Spine.Route.navigate '/etusivu', true

  showPage: (params) ->
    pageName = params.match[1]
    state = params.match[2]
    id = params.match[3]

    page = $('#page-' + pageName)
    Spine.Route.navigate '/' if(page.length == 0)


    suppressHeadings = () ->
      $('.article', page).find('h1, h2, h3, h4, h5, h6').each () ->
        if pageName == 'uusi-lausunto' or pageName == 'luo-yhteenveto'
          $(this).parent().next().addClass($(this).get(0).tagName)
        else
          $(this).parent().next().next().addClass($(this).get(0).tagName)
        # Some headings contain a span element
        $(this).find('*').each () ->
          if $(this).text().length > 60
            $(this).text $(this).text().substr(0, 57) + '...'
        # ...and some don't
        if $(this).text().length > 60
          $(this).text $(this).text().substr(0, 57) + '...'

    if id?
      $.get '/api/statement_req/' + id, (data, status) ->
        if status == 'success'
          if pageName == 'luo-yhteenveto'
            $('.article', page).render data, DIRECTIVES
            $('#navi', page).render data, DIRECTIVES
          else
            page.render data, DIRECTIVES

          if pageName == 'luo-yhteenveto' and state == 'luo'
            popStatementFilterStash()
            suppressHeadings()
            addSummaryPageComments()
            updateOpinionDistribution id

            $('.store_summary', $(page)).click () ->
              input = $(this)
              for instance in CKEDITOR.instances
                CKEDITOR.instances.instance.updateElement()
              $.post '/api/statement_req/' + id + '/add_summary/', $(this).parent().prev().serialize(), (data, status) ->
                Spine.Route.navigate '/'

              false

          else if pageName == 'pyynto' and state == 'tarkastele'
            # When just created a new request, there are no comments yet
            if data[0].comment_count == 0
              launchGenerateComments id
            else
              renderMostCommented id

          else if pageName == 'valitse-lausunnot' and state == 'valitse'
            createSideExtras id
            page.find('h3, h4, h5, h6').each () ->
              $(this).parent().next().next().addClass($(this).get(0).tagName)
            suppressHeadings()
            commentHighlights page
            #$('#select_all_button').unbind('click').click selectAllComments
            #$('#unselect_all_button').unbind('click').click unselectAllComments
            $('#select-all-statements', page).unbind('click').click () ->
              if $(this).is(":checked")
                selectAllComments()
              else
                unselectAllComments()

            $('#page-valitse-lausunnot .statement-static input[name=include]').unbind('change').change () ->
              setSelectAllStatus()

            createTargetFilters(page, data)

    if pageName == 'etusivu'
      $.get '/api/statement_reqs', (data, status) ->
        if status == 'success'
          $('.statement-requests', page).render data, DIRECTIVES

    # 2nd scenario pages
    else if pageName == 'etusivu2'
      $.get '/api/demo_listing', (data, status) ->
        $('.statement-requests', page).render data, DIRECTIVES
    else if pageName == 'tarkastele-ennen-lausuntoa'
      $.get '/api/demo_request', (data, status) ->
        page.render data, DIRECTIVES
    else if pageName == 'uusi-lausunto'
      $.get '/api/demo_request', (data, status) ->
        $('.article', page).render data, DIRECTIVES
        $('.aside', page).render data, DIRECTIVES
        suppressHeadings()
        # Datepicker lost in transparency, reset
        $('.field.date input', $('#page-uusi-lausunto')).datepicker(datePickerOptions)
        $('.users .user', $('#modal-share')).each () ->
          $(this).removeClass('confirmed')

        $('.shared_to', $('#page-uusi-lausunto')).bind 'shared', (event) ->
          emails = []
          $('.users .user', $('#modal-share')).each () ->
            if not $(this).hasClass('inactive') and not $(this).is(":hidden")
              emails.push({
                  sharedperson: $(this).find('.email').text(),
                  replied: $(this).hasClass('confirmed')
              })

          if emails.length > 0
            $('.shared_to', $('#page-uusi-lausunto')).render emails, DIRECTIVES
            launchFakeCommentGenerator(emails)

    if page.not ':hidden'
      $('.page').hide()
      page.show()

    if page[0].className?
      page[0].className = page[0].className.replace /\bstate\-.*\b/g, ''
    page.addClass 'state-' + state if state?

  showRequest: (params) ->
    alert 'foo'

$(document).ready ->
  Spine.Route.add
    #these should be left last in the list to catch routes that do not match
    ""                  : Controller.index
    "/"                 : Controller.index
    "/:page/:state/:id" : Controller.showPage
    "/:page/:state"     : Controller.showPage
    "/:page"            : Controller.showPage

  Spine.Route.setup()

  $('.field.date input', $('#page-uusi-lausuntopyynto')).datepicker(datePickerOptions)

  $('#page-etusivu .statement-requests .article').live 'click', () ->
    title = $('h3[id]', $(this))
    if title.length > 0
      id = $(title[0]).attr("id").match(/[a-f0-9]+$/)
      Spine.Route.navigate '/pyynto/tarkastele/' + id
    false

  $('.new-statement-request').click () ->
    $('body').addClass 'logged'

  $('a.dummy').live 'click', () ->
    false

  #$('a.share').click () ->
  #  false

  $('a.show-help').click () ->
    false

  $('#search').submit () ->
    false

  $('.field.submit a.submit').click () ->
    for instance in CKEDITOR.instances
      CKEDITOR.instances.instance.updateElement()

    input = $(this)
    send = $.post '/api/create_statement_req', $(this).parents('form').serialize(), (data, status) ->
      Spine.Route.navigate '/pyynto/tarkastele/' + data.id
    send.error () ->
      $('.ui-form .validation-error').slideDown(200)

    false

  $('.field.multiple').each () ->
    input = $(this).find('input').clone()
    add = $(this).find('.add')
    add.click () ->
      close = $('<a href="#" />').text('x').addClass 'remove'
      close.click () ->
        $(this).fadeOut 100, ->
          $(this).prev('input').slideUp 100, ->
            $(this).remove()
            close.remove()
        false
      close.insertBefore add


      cont = $(this).parent()
      dataIdx = cont.attr 'data-idx'
      if dataIdx? && !isNaN parseInt dataIdx
        cont.attr 'data-idx', parseInt(cont.attr 'data-idx') + 1
      else
        cont.attr 'data-idx', '1'
      idx = cont.attr 'data-idx'
      clone = input.clone()
      clone.attr 'name', input.attr('name').replace("[0]", "["+idx+"]")
      clone.hide()

      clone.insertBefore add
      clone.slideDown 100
      false


  $('.notifications .article a.close').live 'click', () ->
    a = $(this).parents('.article')
    a.wrap $('<div />').height a.outerHeight()
    a.fadeOut 200, () ->
      a.parent().slideUp 200
      $('.notifications h2').slideUp(200) if $('.notifications').children('.article').not(':hidden').length == 0
    false

  updateReceivers = (input) ->
    val = input.val()
    ul = if input.siblings('ul').length == 0 then $('<ul class="suggestions" />').appendTo input.parents('.inputs') else input.siblings('ul').empty()

    pos = input.position()
    ul.css 'top', pos.top + input.outerHeight()

    val = $.trim(val).toLowerCase().replace(/\s+/," ")
    if val.length > 0
      filter = val.split(" ").join(".*")
      regexp = new RegExp filter, "i"

      suggestions =
        orgs: []
        emails: []

      for rec in TARGETS
        suggestions.orgs.push rec if regexp.test(rec.title.toLowerCase())
        for email in rec.emails
          suggestions.emails.push email if regexp.test(email.toLowerCase())

      for org in suggestions.orgs
        adrWord = if org.emails.length == 1 then ' osoite' else ' osoitetta'
        ul.append $('<li class="org" />').append($('<span class="title"/>').text(org.title)).append $('<span class="meta" />').text(' (' + org.emails.length + adrWord + ')')
      for email in suggestions.emails
        ul.append $('<li class="email" />').text email
      ul.find('li:gt(4)').hide()
      ul.find('li.org').mousedown () ->
        input.val $(this).find('.title').text()
      ul.find('li.email').mousedown () ->
        input.val $(this).text()
      if suggestions.orgs.length + suggestions.emails.length > 0
        ul.show()
      else
        ul.hide()
    else
      ul.hide()

  $('#targets').on 'keyup', 'input', (e) ->
    updateReceivers $(this) if e.keyCode != 40 and e.keyCode != 38 and e.keyCode != 13

  $('#targets input').live 'blur', () ->
    $('.suggestions').hide()

  $('#targets').on 'keydown', 'input', (e) ->
    input = $(this)
    if e.keyCode == 40 or e.keyCode == 38
      current = $('#targets .suggestions li.active')
      if e.keyCode == 40
        if current.length == 0
          $('#targets .suggestions:visible li').first().addClass('active')
        else
          current.removeClass('active').next('li').addClass('active')
      else if e.keyCode == 38
        if current.length == 0
          $('#targets .suggestions:visible li').last().addClass('active')
        else
          current.removeClass('active').prev('li').addClass('active')
      return false
    if e.keyCode == 13
      $('#targets .suggestions li.active').trigger 'mousedown'
      input.blur().focus()
      e.stopPropagation()
      e.preventDefault()
      return false

  $('#targets').on 'hover', '.suggestions li', () ->
    $(this).addClass('active').siblings('li').removeClass 'active'

  $('.editor').each () ->
    id = $(this).attr("id")
    tb = if id == 'cover_text' or id == 'statementcover' then 'CoverTextEditor' else 'RequestEditor'
    tb = 'SummaryEditor' if id == 'summary'
    $(this).ckeditor () ->
      # Reduce the amount of extra whitespace in the output of the editor
      this.dataProcessor.writer.setRules('p',
      {
        indent : false,
        breakBeforeOpen : false,
        breakAfterOpen : false,
        breakBeforeClose : false,
        breakAfterClose : true
      })
    ,
    {toolbar: tb}

  $('.content a.share').live 'click', () ->
    $('#modal-share').show()
    return false
  $('.modal-box a.ready').live 'click', () ->
    $('.shared_to', $('#page-uusi-lausunto')).trigger 'shared'
    $('#modal-share').hide()
    return false
  $('.content a.show-help').live 'click', () ->
    $('#modal-help').show()
    $('html, body').css
      height:'100%'
      overflow:'hidden'
    return false
  $('#modal-help').click () ->
    $('#modal-help').hide()
    $('html, body').css
      height:'auto'
      overflow:'visible'
  $('.aside a.summary').live 'click', () ->
    setHighlightSummaryContent()
    $('#modal-summary').height $('body').height() if $('#modal-summary').height() < $('body').height()
    $('#modal-summary').show()
    return false
  $('.modal-box a.summary-close').click () ->
    $('#modal-summary').hide()
    return false

  $('.content a.scenario2').click () ->
    $('#modal-scenario2-finish').show()
    return false
  $('#modal-scenario2-finish a.ready').click () ->
    window.location = '/'
    return false

  $('.content a.navi-choose-statements').click () ->
    $('#modal-scenario1-finish').show()
    return false
  $('#modal-scenario1-finish a.ready').click () ->
    window.location = '/'
    return false

  $('.close', $('#modal-share')).live 'click', () ->
    $(this).parent().slideToggle('fast')

  $('#modal-share').on 'keydown', 'input', (e) ->
    if e.keyCode == 13
      if validateEmail $(this).val()
        template = $('.template', $('#modal-share')).clone()
        template.removeClass('hide-all')
        template.removeClass('template')
        template.find('.email').text($(this).val())

        $(this).val("")
        $('.users', $('#modal-share')).append(template)

      e.stopPropagation()
      e.preventDefault()
      return false

  $('a.logout').live 'click', () ->
    window.location = '/'
    false

  $('#page-luo-yhteenveto .article .statement .info').live 'click', () ->
    $(this).parent().find('p.text').slideToggle('fast')
    $(this).parent().toggleClass('hide-more')
    return false

  $('.show-all-link').live 'click', () ->
    $page = $(this).parents('.page')

    # Summary page
    $statements = $('.article .statement', $page)
    $statements.find('p.text').slideDown('fast')
    $statements.removeClass('hide-more')
    # real data format
    $page.find('.text-and-statement').not('.open').trigger('click')
    return false

  $('.hide-all-link').live 'click', () ->
    $page = $(this).parents('.page')

    # Summary page
    $statements = $page.find('.article .statement')
    $statements.find('p.text').slideUp('fast')
    $statements.addClass('hide-more')
    $('select.respondents', $page).val('')
    # real data format
    $page.find('.text-and-statement.open').trigger('click')
    return false

  $('a.button', $('#modal-disclaimer')).click () ->
    # Choose the scenario
    uri = "/etusivu"
    # Olli
    if $(this).hasClass('scenario1')
      uri = "/etusivu"
    # Maija-Leena
    else if $(this).hasClass('scenario2')
      uri = "/etusivu2"
    else
      return false

    $('#header div.wrap h1 a').attr('href', '/#' + uri)
    $('#modal-disclaimer').hide()
    Spine.Route.navigate uri
    false

  $('#top-disclaimer a').click () ->
    $('#modal-disclaimer').show()
    false

  getSelected = ->
    if window.getSelection
      return window.getSelection().toString()
    else if document.getSelection
      return document.getSelection()
    else
      selection = document.selection and document.selection.createRange()
      return selection.text if selection.text
      return false
    false

  $('#page-luo-yhteenveto .article .statement p.text').live 'copy', () ->
    $this = $(this)
    $statement = $this.parents('.statement:first')
    name  = $statement.find('.info .name').text()
    #date  = $statement.find('.info .date').text()
    title = $statement.parent().prev('.summarytitle').text() || ""
    title = title.replace(/^\s+|\s+$/g,"")
    title = title.substr(0,12) + "..." if title.length > 15
    title = "Kohdasta #{title}" unless title == ""
    QUOTE_STASH =
      source: "#{title} #{name} kirjoitti: "
      quote : rangy.getSelection().toString()

  editor = CKEDITOR.instances.summary
  editor.on 'paste', (evt) ->
    if not _.isEmpty(QUOTE_STASH)
      evt.editor.insertHtml QUOTE_STASH.source
      QUOTE_STASH = {}
