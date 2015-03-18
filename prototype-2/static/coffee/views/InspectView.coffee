class prowl.views.Inspect extends Backbone.View
	initialize: (collection) ->
		@collection = collection
	render: () ->
		template = $('#inspect-template').html()
		@$el.html(_.template(template))
		@
