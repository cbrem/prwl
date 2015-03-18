class prowl.views.Mine extends Backbone.View
	events: {}
	initialize: () -> @
	render: () ->
		template = $('#mine-template').html()
		@$el.html(_.template(template))