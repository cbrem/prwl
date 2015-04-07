class prwl.models.User extends Backbone.Model
    urlRoot: "/users"
    idAttribute: "username"
    defaults: () ->
        username: ''
        password: ''
        pins: []
    initialize: () -> @

    login: ({success, failure}) ->
        $.post(
            url: '/users/login',
            data:
                username: @.get('username')
                password: @.get('password')
            success: success
            failure: failure
        )

    logout: ({success, failure}) ->
        $.post(
            url: '/users/logout'
            success: success
            failure: failure
        )

