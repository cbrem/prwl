# Make namespace. Also use it as a hub for events
window.prwl =
	views: {}
	collections: {}
	models: {}
	events: _.extend({}, Backbone.Events)
	user: null

# TODO: issue with how we're using _.template?
class prwl.Router extends Backbone.Router
	# TODO: richer routes, so we can keep things in history (like which pins youre looking at)
	routes:
		"": "home"
		"about": "about"
		"store": "store"

	initialize: () ->
		@_viewCache = {}
		@view = null

	_renderIfLoggedIn: (name, $el, cache) ->
		if prwl.user?
			@_cachedRender(name, $el, cache)
		else
			@_cachedRender('Login', $('#main-anchor'))


	# TODO: not actually using view cache because cache is always undefined?
	# TODO: reuse this other places!
	_cachedRender: (name, $el, cache) ->
		if @view? then @view.$el.detach()
		if _.has(@_viewCache, name) and cache
			@view = @_viewCache[name]
		else
			@view = new (prwl.views[name])(args)
			@view.render()
			@_viewCache[name] = @view
		$el.append(@view.$el)

	home: () -> @_renderIfLoggedIn('Home', $('#main-anchor'))
	about: () -> @_renderIfLoggedIn('About', $('#main-anchor'))
	store: () -> @_renderIfLoggedIn('Store', $('#main-anchor'))

jQuery ->
	prwl.router = new prwl.Router()
	Backbone.history.start()
