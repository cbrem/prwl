fmtTime = (time) -> time

class prowl.views.Home extends Backbone.View
	# TODO: can we use a router to do this instead?
	events:
		'click #mine-button': '_gotoMine'
		'click #search-button': '_gotoSearch'
		'click #inspect-button': '_gotoInspect'

	initialize: () ->
		@collection = new prowl.collections.Pins()
		@collection.on('add', @_updateMap, @) # TODO: cheange to all?
		@collection.fetch()

		@map = null
		@sidebar = null

		@

	_gotoMine: () -> @_renderSidebar('Mine')
	_gotoSearch: () -> @_renderSidebar('Search')
	_gotoInspect: () -> @_renderSidebar('Inspect')

	# Render the sidebar with the given view name
	# TODO: cache here to avoid re-making views
	_renderSidebar: (name) ->
		sidebarDiv = @$el.find('#sidebar-anchor')
		@sidebarView = new prowl.views[name](@collection)
		@sidebarView.render()
		sidebarDiv.html(@sidebarView.$el)

	# Redraw all pins on the map
	_updateMap: () ->
		if @map?
			@collection.each((pin) =>
		    	position = new google.maps.LatLng(pin.get('lat'), pin.get('lng'))
		    	title = '#{ fmtTime(pin.get("time")) }: #{ pin.get("desc") }'
		    	marker = new google.maps.Marker(
		    		position: position
		    		map: @map
		    		title: title
		    	)
		    	google.maps.event.addListener(marker, 'click', () -> alert(title))
			)


	render: () ->
		# Render frame
		template = $('#home-template').html()
		@$el.html(_.template(template))

		# Render sidebar
		@_gotoMine()

		# Render map
		opt = zoom: 11
		mapDiv = @$el.find('#map-anchor')[0]
		@map = new google.maps.Map(mapDiv, opt)
		@_updateMap()

		# Set location to user's location
		if navigator.geolocation?
			succ = (loc) =>
				pos = new google.maps.LatLng(loc.coords.latitude, loc.coords.longitude)
				@map.setCenter(pos)
			fail = (e) -> console.log(e.message)
			navigator.geolocation.getCurrentPosition(succ, fail)
		else
			alert('Please enable navigation to allow Prowl to work correctly!')
			window.location.reload()

		@