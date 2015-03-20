# Make namespace. Also use it as a hub for events
window.prowl =
	views: {}
	collections: {}
	models: {}
	events: _.extend({}, Backbone.Events)

# TODO: issue with how we're using _.template?
class prowl.Router extends Backbone.Router
	# TODO: richer routes, so we can keep things in history (like which pins youre looking at)
	routes:
		"": "home"
		"about": "about"
		"store": "store"

	initialize: () ->
		@_viewCache = {}

	# TODO: reuse this other places! anywhere that has sub-views
	_cachedRender: (name, $el, args) ->
		if _.has(@_viewCache, name)
			view = @_viewCache[name]
			$el.html(view.el)
		else
			view = new (prowl.views[name])(args)
			view.render()
			@_viewCache[name] = view
			$el.html(view.el)

	home: () -> @_cachedRender('Home', $('#main-anchor'), {})
	about: () -> @_cachedRender('About', $('#main-anchor'), {})
	store: () -> @_cachedRender('Store', $('#main-anchor'), {})

jQuery ->
	prowl.router = new prowl.Router()
	Backbone.history.start()
