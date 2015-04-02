class prwl.views.Pin extends Backbone.View
	events:
    	"click .pin": "inspectPin"

	template: _.template($('#pin-template').html())

	# TODO: use model prop for this?
	initialize: (pin) ->
		@pin = pin

	render: () ->
		@$el.html(@template(pin: @pin))
		@

	inspectPin: () ->
		time = @pin.get('time')
		prwl.events.trigger('goto-inspect', @pin)
