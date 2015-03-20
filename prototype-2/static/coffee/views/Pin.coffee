class prowl.views.Pin extends Backbone.View
	events:
    	"click .pin": "inspectPin"

	template: _.template($('#pin-template').html())

	# TODO: use model prop for this?
	initialize: (pin) ->
		@pin = pin
		console.log('made pin', pin.get('id'))

	render: () ->
		@$el.html(@template(pin: @pin))
		@

	inspectPin: () ->
		time = @pin.get('time')
		prowl.events.trigger('inspect-pin', @pin)
