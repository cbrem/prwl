class prwl.views.Store extends Backbone.View
	events: {}
	initialize: () -> @
	render: () ->
		template = $('#store-template').html()
		@$el.html(_.template(template))
		@
