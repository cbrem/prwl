class prowl.views.Search extends Backbone.View
	events:
		'keyup #search-input': 'checkCodes'

	checkCodes: (e) ->
		NEWLINE = 13
		BACKSPACE = 8

		# TODO: switch
		if e.which == NEWLINE
			@search()
		else if e.which == BACKSPACE
			@clear()

	search: () ->
		tag = $('#search-input').val().trim()
		pinsWithTag = @collection.filter((pin) ->
  			_.contains(pin.get('tags'), tag)
  		)

		anchor = $('#search-pins-anchor')
		_.each(pinsWithTag, (pin) ->
			pinView = new prowl.views.Pin(pin)
			anchor.append(pinView.render().$el);
		)

	clear: () ->
		anchor = $('#search-pins-anchor')
		anchor.empty()

	initialize: ({collection}) ->
		@collection = collection

	render: () ->
		template = $('#search-template').html()
		@$el.html(_.template(template))
		@
