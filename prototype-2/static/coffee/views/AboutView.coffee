class prowl.views.About extends Backbone.View
	events: {}
	initialize: () -> @
	render: () ->
		template = $('#about-template').html()
		@$el.html(_.template(template))
		@
