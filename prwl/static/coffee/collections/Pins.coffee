class prwl.collections.Pins extends Backbone.Collection
	url: '/pins'
	model: prwl.models.Pin


	parse: (res, xhr) -> return res.pins
