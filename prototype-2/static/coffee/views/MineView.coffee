class prowl.views.Mine extends Backbone.View
	events:
    	"click #pin-button": "dropPin"
	initialize: (collection) ->
		@collection = collection
	render: () ->
		# TODO: render in pin data
		template = $('#mine-template').html()
		@$el.html(_.template(template))
		@
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


