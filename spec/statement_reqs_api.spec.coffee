require.paths.push '../server'

create_request           = require('../server/statement_reqs_api').create_statement_req
add_comment_to_paragraph = require('../server/statement_reqs_api').add_comment_to_section
add_comment              = require('../server/statement_reqs_api').add_comment
update_deadline          = require('../server/statement_reqs_api').update_deadline
update_targets           = require('../server/statement_reqs_api').update_targets
add_targets              = require('../server/statement_reqs_api').add_targets
add_summary              = require('../server/statement_reqs_api').add_summary
get_statistics           = require('../server/statement_reqs_api').get_statistics
get_target_status        = require('../server/statement_reqs_api').get_target_status

init_testing             = require('../server/statement_reqs_api').init_testing

monmon                   = require('../server/monmon').monmon
closeAll                 = require('../server/monmon').closeAll

describe "Statement request API", ->

	# Enable only one test at a time as for some (asynchronous) reason
	# they fail if more than one are executed. Also had some problems
	# with initializing and closing connections in beforeEach and afterEach

	xit "should accept a statment request", ->
		db  = monmon.use('lausuntopalvelu')
		col = db.collection('statement_reqs')
		col.drop().run ->
			init_testing db
			create_request statement_request_form, (err, id) ->
				closeAll ->
					expect(err).toBeNull()
					asyncSpecDone()

		asyncSpecWait()

	xit "should add a comment to a paragraph", ->
		db  = monmon.use('lausuntopalvelu')
		col = db.collection('statement_reqs')
		col.drop().run ->
			init_testing db
			create_request statement_request_form, (err, id) ->
				add_comment_to_paragraph id, 1, single_comment, (err, json) ->
					closeAll ->
						expect(err).toBeUndefined()
						asyncSpecDone()

		asyncSpecWait()

	xit "should add a comment to the whole request", ->
		db  = monmon.use('lausuntopalvelu')
		col = db.collection('statement_reqs')
		col.drop().run ->
			init_testing db
			create_request statement_request_form, (err, id) ->
				add_comment id, single_comment, (err, json) ->
					closeAll ->
						expect(err).toBeUndefined()
						asyncSpecDone()

		asyncSpecWait()

	it "should update the deadline", ->
		body = {deadline: '2009-11-24'}

		db  = monmon.use('lausuntopalvelu')
		col = db.collection('statement_reqs')
		col.drop().run ->
			init_testing db
			create_request statement_request_form, (err, id) ->
				update_deadline id, body, (err, json) ->
					closeAll ->
						expect(err).toBeUndefined()
						asyncSpecDone()

		asyncSpecWait()

	xit "should update the requirement target audience", ->
		body = {targets: [ "uusi.ukkeli@foo.bar", "toinenkin.mokoma@foo.bar "]}

		db  = monmon.use('lausuntopalvelu')
		col = db.collection('statement_reqs')
		col.drop().run ->
			init_testing db
			create_request statement_request_form, (err, id) ->
				update_targets id, body, (err, json) ->
					closeAll ->
						expect(err).toBeUndefined()
						asyncSpecDone()

		asyncSpecWait()

	xit "should add new emails to requirement target audience", ->
		body = {targets: [
				email: "uusi.ukkeli@foo.bar"
			,
				email:"toinenkin.mokoma@foo.bar "
		]}

		db  = monmon.use('lausuntopalvelu')
		col = db.collection('statement_reqs')
		col.drop().run ->
			init_testing db
			create_request statement_request_form, (err, id) ->
				add_targets id, body, (err, json) ->
					closeAll ->
						expect(err).toBeUndefined()
						asyncSpecDone()

		asyncSpecWait()

	xit "should add a summary to a requirement", ->
		db  = monmon.use('lausuntopalvelu')
		col = db.collection('statement_reqs')
		col.drop().run ->
			init_testing db
			create_request statement_request_form, (err, id) ->
				add_summary id, request_summary, (err, json) ->
					closeAll ->
						expect(err).toBeUndefined()
						asyncSpecDone()

		asyncSpecWait()

	xit "should calculate statistics", ->
		db  = monmon.use('lausuntopalvelu')
		col = db.collection('statement_reqs')
		col.drop().run ->
			init_testing db
			create_request statement_request_form, (err, id) ->
				get_statistics id, (err, json) ->
					closeAll ->
						expect(err).toBeNull()
						asyncSpecDone()

		asyncSpecWait()

	xit "should tell target response status", ->
		db  = monmon.use('lausuntopalvelu')
		col = db.collection('statement_reqs')
		col.drop().run ->
			init_testing db
			create_request statement_request_form, (err, id) ->
				get_target_status id, (err, json) ->
					closeAll ->
						expect(err).toBeNull()
						asyncSpecDone()

		asyncSpecWait()

