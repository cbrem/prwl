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
		@delegateEvents() # TODO: is this right?  see http://stackoverflow.com/questions/18552478/backbone-view-event-firing-only-once-after-view-is-rendered
