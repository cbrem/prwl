/*
TODO:
* how to handle users/authentication? can probably worry about this later,
	doesn't need to work in the prototype
* hook up ember data
	* need to get ember-data library
	* use this.store.find to get data
	* use this.store.createRecord to add something
	* use record.delete followed by record.save to remove it
	* use record.save to update it
* replace big debug builds with min ones

CURRENT:
* When we flip back and forth between two seperate windows, something breaks.
	* pins in mypins *do* persist
	* but it seems like descriptions are not persisting. because things don't stay in the map view
*/


/* HELPERS */

// Sends location and time info to a callback.
var getLoc = function(cb) {
	if (!navigator.geolocation) {
		alert('Geolocation not supported!');
		return;
	}

	navigator.geolocation.getCurrentPosition(function(pos) {
    	cb({
    		timestamp: pos.timestamp,
    		latitude: pos.coords.latitude,
    		longitude: pos.coords.longitude,
    	});
    });
};

// Gets a timestamp.
var getTimestamp = function() {
	return new Date().getTime();
};

// Gets formatted date from numerical date string.
var formatDate = function(dateStr) {
	return new Date(dateStr).toLocaleDateString();
};

// Create a marker and attach a listener.
var makeMarker = function(pin, map) {
	var latLng = new google.maps.LatLng(pin.get('latitude'), pin.get('longitude'));
	var title = formatDate(pin.get('timestamp')) + ": " + pin.get('description').substring(0, 10) + "...";
	var marker = new google.maps.Marker({
	    position: latLng,
	    map: map,
	    title: title,
	});
	google.maps.event.addListener(marker, 'click', function() {
		alert(title);
	});
};

// Is a pin complete?
var complete = function(pin) {
	return !!(pin.get('description') && pin.get('latitude') && pin.get('longitude') && pin.get('timestamp'));
};

// Is it incomplete?
var incomplete = function(pin) {
	return !complete(pin);
};



/* ROUTER */

var App = Ember.Application.create();
//App.ApplicationAdapter = DS.FixtureAdapter;
App.Router.map(function() {
	// Get info and donate.
	this.route('about');

	// Drop a pin.
  	this.route('drop', {path: '/'});

  	// Look at all of your dropped pins.
  	this.route('myPins');


  	// Looks at a map of everybody's pins.
  	this.route('harassmap');
});


/* MODELS */

App.Pin = DS.Model.extend({
	timestamp: DS.attr('number'),
	latitude: DS.attr('number'),
	longitude: DS.attr('number'),
	description: DS.attr('string'),
});


/*  ROUTES */
App.MyPinsRoute = Ember.Route.extend({
  	model: function() {
  		return this.store.find('pin');
  	}
});

App.HarassmapRoute = Ember.Route.extend({
	model: function() {
		return this.store.find('pin');
	},
	setupController: function(controller, model) {
		this._super(controller, model);
		var pins = model.get('content');
		getLoc(function(loc) {
			// Create a new map centered on the user.
			var opt = {
	          center: new google.maps.LatLng(loc.latitude, loc.longitude),
	          zoom: 8
	        };
	        var map = new google.maps.Map(document.getElementById('map-canvas'), opt);

	        // Fill with all pins.
	        for (var pin of pins) {
	        	if (complete(pin)) {
	        		makeMarker(pin, map);
	        	}
	        }
		});
	},
});


/* CONTROLLERS */

App.DropController = Ember.ObjectController.extend({
	actions: {
		dropPin: function() {
			getLoc(function(loc) {
				var pin;
				// TODO: make timestamps more unique...like timestamp + userid
				if (loc) {
					pin = this.store.createRecord('pin', {
						timestamp: loc.timestamp,
						id: loc.timestamp,
						latitude: loc.latitude,
						longitude: loc.longitude
					});
				} else {
					// If location data wasn't available, fall back to just
					// taking the timestamp.
					var timestamp = getTimestamp();
					pin = this.store.createRecord('pin', {
						timestamp: timestamp,
						id: timestamp
					});
				}
				pin.save();
	        }.bind(this));

	        // TODO: necessary?
	        return false;
		},
	},
});

App.MyPinController = Ember.ObjectController.extend({
	actions: {
		toggleDescription: function() {
			this.set('descriptionIsOpen', !this.get('descriptionIsOpen'));
			return false;
		},
		saveDescription: function() {
			// TODO: something wrong here? is this actually saving?
			this.set('descriptionIsOpen', false);

			var model = this.get('model');
			model.set('description', this.get('description'));
			model.save();
		},
	},

	descriptionIsOpen: false,
});
