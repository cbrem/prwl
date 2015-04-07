"""
TODO:
* wire this up to other things
* before login, try to check if a user exists
	* if user exists, just log in or fail based on password
	* otherwise, create
* set prwl.user
"""

NEWLINE = 13
BACKSPACE = 8

class prwl.views.Login extends Backbone.View
	events:
		'keyup #login-password': 'checkCodes'

	checkCodes: (e) ->
		# TODO: switch
		if e.which == NEWLINE and @validate() then @submit()

	validate: () -> $('#login-username').val().trim() and $('#login-password').val().trim()

	submit: () ->
		username = $('#login-username').val().trim()
		password = $('#login-password').val().trim()

		# Try to get a user with this username.
		# If it fails, prompt creating a user.
		# If it succeeds but the password is wrong, show an error.
		# If there is a user with this password, log them in.
		user = new prwl.models.User(
			username: username
			password: password
		)
		user.fetch(
			success: () ->
				user.login(
					success: ()->
						prwl.user = user
						prwl.router.navigate('home', true)
					failure: () ->
						alert('Wrong password!')
				)
			failure: () ->
				if confirm('No user with this name. Create one?')
					user.save()
					prwl.user = user
					prwl.router.navigate('home', true)
			)

		# Clear the inputs
		$('#login-username').val('')
		$('#login-password').val('')

		initialize: () -> @

		render: () ->
		template = $('#login-template').html()
		@$el.html(_.template(template))
		@
