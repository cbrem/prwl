fmtTime = (time) -> time

class prowl.views.Home extends Backbone.View
	# TODO: can we use a router to do this instead?
	events:
		'click #mine-button': '_gotoMine'
		'click #search-button': '_gotoSearch'

	initialize: () ->
		@collection = new prowl.collections.Pins()
		@collection.on('all', @_updateMap, @)
		@collection.fetch()

		@map = null
		@view = null

		@_viewCache = {}

		prowl.events.on('goto-inspect', @_gotoInspect, @)
		prowl.events.on('goto-mine', @_gotoMine, @)

		@

	_gotoMine: () -> @_renderSidebar('Mine', {}, true)
	_gotoSearch: () -> @_renderSidebar('Search', {}, true)
	_gotoInspect: (id) ->
		pin = @collection.get(id)
		@_renderSidebar('Inspect', pin: pin, false)

	# Render the sidebar with the given view name
	_renderSidebar: (name, args, cache) ->
		sidebarDiv = @$el.find('#sidebar-anchor')
		args = _.extend(collection: @collection, args)
		@_cachedRender(name, sidebarDiv, args, cache)

	# TODO: reuse this other places!
	_cachedRender: (name, $el, args, cache) ->
		if @view? then @view.$el.detach()
		if _.has(@_viewCache, name) and cache
			@view = @_viewCache[name]
		else
			@view = new (prowl.views[name])(args)
			@view.render()
			@_viewCache[name] = @view
		$el.append(@view.$el)

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
		prowl.map = @map = new google.maps.Map(mapDiv, opt)
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
