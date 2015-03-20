# need to change view caching so that we dont always enter with the same pin on inspect

class prowl.views.Inspect extends Backbone.View
	events:
		"click #inspected-pin-submit": "submit"

	# TODO: always include templates in this form
	template: _.template($('#inspect-template').html())

	initialize: ({collection, pin}) ->
		@collection = collection
		@pin = pin
		@pin.on('add', @render, @)
		# TODO: change this an other from just all?

	render: () ->
		@$el.html(@template(pin: @pin))
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

	_parseTags: (tagStr) ->
		if tagStr?
			_.map(tagStr.split(','), (tag) -> tag.trim())
		else
			[]
