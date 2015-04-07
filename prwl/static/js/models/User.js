// Generated by CoffeeScript 1.9.1
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  prwl.models.User = (function(superClass) {
    extend(User, superClass);

    function User() {
      return User.__super__.constructor.apply(this, arguments);
    }

    User.prototype.urlRoot = "/users";

    User.prototype.idAttribute = "username";

    User.prototype.defaults = function() {
      return {
        username: '',
        password: '',
        pins: []
      };
    };

    User.prototype.initialize = function() {
      return this;
    };

    User.prototype.login = function(arg) {
      var failure, success;
      success = arg.success, failure = arg.failure;
      return $.post({
        url: '/users/login',
        data: {
          username: this.get('username'),
          password: this.get('password')
        }
      });
    };

    return User;

  })(Backbone.Model);

}).call(this);