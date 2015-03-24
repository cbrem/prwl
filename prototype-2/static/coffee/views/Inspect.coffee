# need to change view caching so that we dont always enter with the same pin on inspect

class prowl.views.Inspect extends Backbone.View
	events:
		"click #inspected-pin-submit": "submit"

	# TODO: always include templates in this form
	template: _.template($('#inspect-template').html())

	initialize: ({collection, pin}) ->
		@collection = collection
		@pin = pin
		@pin.on('all', @render, @)

	render: () ->
		@$el.html(@template(pin: @pin))

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

	_parseTags: (tagStr) ->
		if tagStr?
			_.map(tagStr.split(','), (tag) -> tag.trim())
		else
			[]
