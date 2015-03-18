# Make namespace
window.prowl =
	views: {}
	collections: {}
	models: {}

# TODO: issue with how we're using _.template?

class prowl.Router extends Backbone.Router
	# TODO: richer routes, so we can keep things in history (like which pins youre looking at)
	routes:
		"": "home"
		"about": "about"
		"store": "store"

	initialize: () ->
		@mainAnchor = $('#main-anchor')
		@_viewCache = {}

	# Helper for filling '#main-anchor' with a given template
	_showView: (name) ->
		if _.has(@_viewCache, name)
			view = @_viewCache[name]
			@mainAnchor.html(view.el)
		else
			view = new (prowl.views[name])()
			view.render()
			@_viewCache[name] = view
			@mainAnchor.html(view.el)

	home: () -> @_showView('Home')
	about: () -> @_showView('About')
	store: () -> @_showView('Store')

jQuery ->
	prowl.router = new prowl.Router()
	Backbone.history.start()
