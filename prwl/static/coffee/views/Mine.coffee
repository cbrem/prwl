# TODO: highlight on hover on map...2-way
# TODO: change so that it updates pins when they're edited not just added

class prwl.views.Mine extends Backbone.View
	events:
    	"click #pin-button": "dropPin"

	template: _.template($('#mine-template').html())

	initialize: () ->
		# TODO: should this really be a collection?
		@collection = new prwl.collection.pins(prwl.user.get('pins'))

		# TODO: make sure this compiles down correctly
		@collection.fetch(data: $.param(username: prwl.user.username))
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
				# TODO: depending on how we structure the db, we maybe don't need to push the pin id
				# directly to the user here...it might be enougth to just re-fetch the user's pins!
				# maybe in a success callback?
				pin.save()
				prwl.user.get('pins').push(pin.get('_id'))
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


