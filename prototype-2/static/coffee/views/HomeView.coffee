fmtTime = (time) -> time

class prowl.views.Home extends Backbone.View
	events: {}
	initialize: () ->
		@collection = new prowl.collections.Pins()
		@

	render: () ->
		template = $('#home-template').html()
		@$el.html(_.template(template))

		# Render sidebar

		# Render map
		if navigator.geolocation?
			opt = zoom: 11
			console.log($('#map'))
			mapDiv = @$el.find('#map')[0]
			map = new google.maps.Map(mapDiv, opt)
			@collection.each((pin) =>
		    	position = new google.maps.LatLng(pin.get('lat'), pin.get('lng'))
		    	title = '#{ fmtTime(pin.get("time")) }: #{ pin.get("desc") }'
		    	marker = new google.maps.Marker(
		    		position: position
		    		map: map
		    		title: title
		    	)
		    	google.maps.event.addListener(marker, 'click', () -> alert(title))
			)

			# Set location to user's location
			succ = (loc) =>
				pos = new google.maps.LatLng(loc.coords.latitude, loc.coords.longitude)
				map.setCenter(pos)
			fail = (e) -> console.log(e.message)
			navigator.geolocation.getCurrentPosition(succ, fail)
		else
			alert('Please enable navigation to allow Prowl to work correctly!')
			window.location.reload()

		@