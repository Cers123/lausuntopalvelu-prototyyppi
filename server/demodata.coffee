# db seed
STATEMENT_REQUESTS = require('statement_reqs_seed').STATEMENT_REQUESTS

exports.init_demo = (db, init_cb) ->

  initialize_collection = (col_name, seed, cb) ->
    col = db.collection col_name
    col.drop().run ->
      if err? then return cb err else return cb null
      #col.insertAll(seed).run (err) ->
      #  if err? then return cb err else return cb null

  # statement_requests seeding
  col = 'statement_reqs'
  initialize_collection col, STATEMENT_REQUESTS, (err) ->
    return init_cb err if err?
    console.log "SEED: #{col} seeded"
    init_cb null
