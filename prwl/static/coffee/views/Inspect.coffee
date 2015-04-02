# TODO: need to bind to create comment
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
		prwl.events.trigger('goto-mine')

	addComment: () ->
		# Validation
		comment = $('#comment-text').val().trim()
		if not comment
			return

		# TODO: something weird's happening here that's duplicating comments sometimes
		# everything's pretty okay once they get persisted, but it's a front-end problem
		@pin.get('comments').push(comment)
		@pin.save()
		@pin.trigger('change')

	_parseTags: (tagStr) ->
		if tagStr?
			_.map(tagStr.split(','), (tag) -> tag.trim())
		else
			[]
