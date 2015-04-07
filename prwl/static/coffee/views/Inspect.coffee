"""
TODO:
* need to bind to create comment
* case on whether this pin belongs to the user.
	* if it does, show edit
"""

class prwl.views.Inspect extends Backbone.View
	events:
		"click #inspected-pin-submit": "submit"
		"keydown #comment-text": "checkCodes"

	# TODO: always include templates in this form
	template: _.template($('#inspect-template').html())

	checkCodes: (e) ->
		NEWLINE = 13

		# TODO: switch
		if e.which == NEWLINE
			@addComment()

	initialize: ({collection, pin}) ->
		@collection = collection
		@pin = pin
		@pin.on('add remove change reset', @render, @)

	render: () ->
		@$el.html(@template(pin: @pin))

		# Hide form if this is not for the right user.
		# TODO: make sure this works!
		if not prwl.user or @pin.get('_id') not in prwl.user.get('pins')
			$('#inspect-pin-form').hide()

		# Zoom to pin
		pos = new google.maps.LatLng(@pin.get('lat'), @pin.get('lng'))
		prwl.map.setCenter(pos)
		prwl.map.setZoom(11)

		@

	# TODO: this doesn't appear to be persisting correctly in chrome
	submit: () ->
		# TODO: form validation?
		form = $('#inspect-pin-form')
		desc = form.find("[name=desc]").val()
		tagStr = form.find("[name=tags]").val()
		if desc then @pin.set(desc: desc)
		if tagStr then @pin.set(tags: @_parseTags(tagStr))
		@pin.save()

		# TODO: we should decide globally whether we want to user events
		# like this or router.navigate for navigation
		prwl.events.trigger('goto-mine')

	addComment: () ->
		# Validation
		comment = $('#comment-text').val().trim()
		if not comment
			return

		# TODO: be careful about how we're pushing comments here.
		# should each comment be its own object with a pin id?
		# or a pin contain a list of comments?
		@pin.get('comments').push(comment)
		@pin.save()
		@pin.trigger('change')

	_parseTags: (tagStr) ->
		if tagStr?
			_.map(tagStr.split(','), (tag) -> tag.trim())
		else
			[]
