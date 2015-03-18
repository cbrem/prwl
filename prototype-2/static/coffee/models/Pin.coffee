class prowl.models.Pin extends Backbone.Model
    urlRoot: "http://localhost:8888/pins"
    defaults:
        lat: 0.0
        lng: 0.0
        time: 0
        desc: ''

    initialize: () -> @
