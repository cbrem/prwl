# TODO: highlight on hover on map...2-way
# TODO: change so that it updates pins when they're edited not just added

class prwl.views.Mine extends Backbone.View
	events:
    	"click #pin-button": "dropPin"

	template: _.template($('#mine-template').html())

	initialize: ({collection}) ->
		@collection = collection
		@collection.on('add remove change reset', @_updatePins, @)

	render: () ->
		@$el.html(@template())
		@

	_updatePins: (pin) ->
		pinsDiv = @$el.find('#mine-pins-anchor')
		pinsDiv.empty()
		@collection.each((pin) =>
			pinView = new prwl.views.Pin(pin)
			pinsDiv.append(pinView.render().$el);
		)

	dropPin: () ->
		# Drop loading animation on button
		pinButton = $('#pin-button')
		loader = $('<img>',
			src: 'img/loader.gif'
			class: 'right'
			width: '128')
		pinButton.after(loader)

		if navigator.geolocation?
			# Set location to user's location
			succ = (loc) =>
				pin = new prwl.models.Pin(
					lat: loc.coords.latitude
					lng: loc.coords.longitude
					time: loc.timestamp
				)

				# TODO: do some triggering magic here so that we can add a pin on the parent view
				pin.save()
				@collection.add(pin)
				loader.remove()
			fail = (e) ->
				console.log(e.message)
				loader.remove()

			# TODO: maybe may a helper class to reduce duplication with geolocation,
			# and also so we can use watchPostion instead
			navigator.geolocation.getCurrentPosition(succ, fail)
		else
			alert('Please enable navigation to allow prwl to work correctly!')
			window.location.reload()


