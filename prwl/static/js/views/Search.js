// Generated by CoffeeScript 1.9.1
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  prwl.views.Search = (function(superClass) {
    extend(Search, superClass);

    function Search() {
      return Search.__super__.constructor.apply(this, arguments);
    }

    Search.prototype.events = {
      'keyup #search-input': 'checkCodes'
    };

    Search.prototype.checkCodes = function(e) {
      var BACKSPACE, NEWLINE;
      NEWLINE = 13;
      BACKSPACE = 8;
      if (e.which === NEWLINE) {
        return this.search();
      } else if (e.which === BACKSPACE) {
        return this.clear();
      }
    };

    Search.prototype.search = function() {
      var anchor, pinsWithTag, tag;
      tag = $('#search-input').val().trim();
      pinsWithTag = this.collection.filter(function(pin) {
        return _.contains(pin.get('tags'), tag);
      });
      anchor = $('#search-pins-anchor');
      return _.each(pinsWithTag, function(pin) {
        var pinView;
        pinView = new prwl.views.Pin(pin);
        return anchor.append(pinView.render().$el);
      });
    };

    Search.prototype.clear = function() {
      var anchor;
      anchor = $('#search-pins-anchor');
      return anchor.empty();
    };

    Search.prototype.initialize = function(arg) {
      var collection;
      collection = arg.collection;
      return this.collection = collection;
    };

    Search.prototype.render = function() {
      var template;
      template = $('#search-template').html();
      this.$el.html(_.template(template));
      return this;
    };

    return Search;

  })(Backbone.View);

}).call(this);
