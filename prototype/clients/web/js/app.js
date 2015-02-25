/*
TODO:
* how to handle users/authentication? can probably worry about this later,
	doesn't need to work in the prototype
* add navbar to top
* hook up ember data
	* use this.store.find to get data
	* use this.store.createRecord to add something
	* use record.delete followed by record.save to remove it
	* use record.save to update it
*/

// Sends location and time info to a callback.
var getLoc = function(cb) {
	if (!navigator.geolocation) {
		alert('Geolocation not supported!');
		return;
	}

	navigator.geolocation.getCurrentPosition(pos => {
    	cb({
    		timestamp: pos.timestamp,
    		latitude: pos.coords.latitude,
    		longitude: pos.coords.longitude,
    	});
    });
};

// Gets formatted date from numerical date string.
var formatDate = function(dateStr) {
	return new Date(dateStr).toLocaleDateString();
};

// Create a marker and attach a listener.
var makeMarker = function(pin, map) {
	var latLng = new google.maps.LatLng(pin.latitude, pin.longitude);
	var title = formatDate(pin.timestamp) + ": " + pin.description.substring(0, 10) + "...";
	var marker = new google.maps.Marker({
	    position: latLng,
	    map: map,
	    title: title,
	});
	google.maps.event.addListener(marker, 'click', () => alert(title));
};

/*
TODO: set up fixture data
DS.Model.extend({
    title: DS.attr('string'),
    isCompleted: DS.attr('boolean')
}).reopenClass({
    FIXTURES: [
		{
			timestamp: 1424819107056,
			latitude: 40.44,
			longitude: -79.93,
		},
		{
			timestamp: 1424819117056,
			latitude: 40.44,
			longitude: -79.93,
		},
		{
			timestamp: 1424819471768,
			latitude: 40.44,
			longitude: -79.92,
			description: 'This really sucked'
		},
		{
			timestamp: 1424819481768,
			latitude: 40.44,
			longitude: -79.91,
			description: 'That really sucked'
		},
    ]
});
*/

var defaultMyPins = [
	{
		timestamp: 1424819107056,
		latitude: 40.44,
		longitude: -79.93,
	},
	{
		timestamp: 1424819117056,
		latitude: 40.44,
		longitude: -79.93,
	},
	{
		timestamp: 1424819471768,
		latitude: 40.44,
		longitude: -79.92,
		description: 'This really sucked'
	},
	{
		timestamp: 1424819481768,
		latitude: 40.44,
		longitude: -79.91,
		description: 'That really sucked'
	},
];

App = Ember.Application.create();

App.Router.map(function() {
	// TODO
	// Info and donation button.
	// this.route('about');

	// Drop a pin.
  	this.route('drop', {path: '/'});

  	// Look at all of your dropped pins.
  	this.route('myPins');


  	// Looks at a map of everybody's pins.
  	this.route('map');
});

App.MyPinsRoute = Ember.Route.extend({
  	model: function() {
  		// TODO: real data source
    	return defaultMyPins.filter(pin => !pin.description);
  	}
});

App.MapRoute = Ember.Route.extend({
	model: function() {
		// TODO: real data source
		return defaultMyPins.filter(pin => pin.description);
	}
});

App.DropController = Ember.ObjectController.extend({
	actions: {
		dropPin: function() {
			getLoc(loc => {
				if (loc) alert('Pin dropped!');
	        	// TODO: which model do we add pin into here?
	        	// NOTE: this should probably go *right* to the server
	        });
		},
	},
});

// TODO: when we get elements to show in the MyPins view, only show those
// that have no description
App.MyPinsController = Ember.ArrayController.extend({
	itemController: 'myPin',
});

App.MyPinController = Ember.ObjectController.extend({
	actions: {
		toggleDescription: function() {
			this.set('descriptionIsOpen', !this.get('descriptionIsOpen'));
		},
		saveDescription: function() {
			console.log("Saving", this.get('description'));
			this.set('descriptionIsOpen', false);
			this.get('model').save();
		},
	},

	descriptionIsOpen: false,
});

App.MapController = Ember.ObjectController.extend({
	init: function() {
		getLoc(({latitude, longitude}) => {
			// Create a new map centered on the user.
			var opt = {
	          center: new google.maps.LatLng(latitude, longitude),
	          zoom: 8
	        };
	        var map = new google.maps.Map(document.getElementById('map-canvas'), opt);

	        // Fill with all pins.
	        for (var pin of this.get('model')) {
	        	makeMarker(pin, map);
	        }
		});
	},
});

Ember.Handlebars.helper('format-date', function(date) {
  return date.toLocaleString();
});
