class prwl.models.Pin extends Backbone.Model
    urlRoot: "/pins"
    idAttribute: "_id"
    defaults: () ->
        lat: 0.0
        lng: 0.0
        time: 0
        desc: ''
        tags: []
        comments: []

    initialize: () -> @
