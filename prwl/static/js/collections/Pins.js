// Generated by CoffeeScript 1.9.1
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  prwl.collections.Pins = (function(superClass) {
    extend(Pins, superClass);

    function Pins() {
      return Pins.__super__.constructor.apply(this, arguments);
    }

    Pins.prototype.url = '/pins';

    Pins.prototype.model = prwl.models.Pin;

    Pins.prototype.parse = function(res, xhr) {
      return res.pins;
    };

    return Pins;

  })(Backbone.Collection);

}).call(this);
