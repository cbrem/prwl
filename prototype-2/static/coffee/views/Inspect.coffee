# TODO: need to bind to create comment
class prowl.views.Inspect extends Backbone.View
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

		# Zoom to pin
		pos = new google.maps.LatLng(@pin.get('lat'), @pin.get('lng'))
		prowl.map.setCenter(pos)
		prowl.map.setZoom(11)

		@

	submit: () ->
		# TODO: form validation?
		form = $('#inspect-pin-form')
		desc = form.find("[name=desc]").val()
		tagStr = form.find("[name=tags]").val()
		@pin.set(
			desc: desc
			tags: @_parseTags(tagStr)
		)
		@pin.save()
		prowl.events.trigger('goto-mine')

	addComment: () ->
		# Validation
		comment = $('#comment-text').val().trim()
		if not comment
			return

		@pin.get('comments').push(comment)
		@pin.trigger('change')

	_parseTags: (tagStr) ->
		if tagStr?
			_.map(tagStr.split(','), (tag) -> tag.trim())
		else
			[]
