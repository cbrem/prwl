# TODO: highlight on hover on map...2-way

class prowl.views.Mine extends Backbone.View
	events:
    	"click #pin-button": "dropPin"

	template: _.template($('#mine-template').html())

	initialize: ({collection}) ->
		@collection = collection
		@collection.on('add', @renderMyPins, @)
		# TODO: should ^ use 'all'?

	render: () ->
		@$el.html(@template())
		@renderMyPins()
		@

	renderMyPins: () ->
		pinsDiv = @$el.find('#pins-anchor')
		pinsDiv.empty()
		@collection.each((pin) =>
			# TODO: is was real tired...make sure this is right
			pinView = new prowl.views.Pin(pin)
			pinsDiv.append(pinView.render().$el);
		)

	dropPin: () ->
		# Drop loading animation on button
		pinButton = $('#pin-button')
		spinner = $('<img>', src: 'img/spinner.gif')
		pinButton.append(spinner)

		if navigator.geolocation?
			# Set location to user's location
			succ = (loc) =>
				pin = new prowl.models.Pin(
					lat: loc.coords.latitude
					lng: loc.coords.longitude
					time: loc.timestamp
				)

				# TODO: do some triggering magic here so that we can add a pin on the parent view
				pin.save()
				@collection.add(pin)
				spinner.remove()
			fail = (e) -> console.log(e.message)

			# TODO: maybe may a helper class to reduce duplication with geolocation,
			# and also so we can use watchPostion instead
			navigator.geolocation.getCurrentPosition(succ, fail)
		else
			alert('Please enable navigation to allow Prowl to work correctly!')
			window.location.reload()


