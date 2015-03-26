class prowl.collections.Pins extends Backbone.Collection
	url: '/pins'
	model: prowl.models.Pin


	parse: (res, xhr) -> return res.pins
