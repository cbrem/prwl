// Generated by CoffeeScript 1.9.1
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  prowl.views.About = (function(superClass) {
    extend(About, superClass);

    function About() {
      return About.__super__.constructor.apply(this, arguments);
    }

    About.prototype.events = {};

    About.prototype.initialize = function() {
      return this;
    };

    About.prototype.render = function() {
      var template;
      template = $('#about-template').html();
      this.$el.html(_.template(template));
      return this;
    };

    return About;

  })(Backbone.View);

}).call(this);