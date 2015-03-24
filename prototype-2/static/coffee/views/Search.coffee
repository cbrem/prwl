class prowl.views.Search extends Backbone.View
	events:
		'keyup #search-input': 'checkForNewline'

	checkForNewline: (e) ->
		NEWLINE = 13
		if e.which == NEWLINE
			@search()

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

	initialize: ({collection}) ->
		@collection = collection

	render: () ->
		template = $('#search-template').html()
		@$el.html(_.template(template))
		@
