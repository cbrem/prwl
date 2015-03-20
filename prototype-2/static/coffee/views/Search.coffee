class prowl.views.Search extends Backbone.View
	initialize: ({collection}) ->
		@collection = collection
	render: () ->
		template = $('#search-template').html()
		@$el.html(_.template(template))
		@
