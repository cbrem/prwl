from flask import request
from util import jsonResponse
from prwl import app, mongo

"""
TODO:
* error handling?
* or write an abstraction layer around these methods?
* https://flask-pymongo.readthedocs.org/en/latest/
"""

# Create a new pin
@app.route('/pins', methods=['POST'])
def post_pin():
	pin = request.json
	print 'pin', pin
	oid = mongo.db.pins.insert(pin)
	print 'res', oid
	_id = str(oid)
	print '_id', _id
	return jsonResponse({'_id': _id})

# Get one pin
@app.route('/pins/<_id>', methods=['GET'])
def get_pin(_id):
	_id = int(_id) # TODO: do we actually want int?
	pin = mongo.db.pins.find_one({'_id': _id})
	return jsonResponse(pin)

# Get all pins
@app.route('/pins', methods=['GET'])
def get_pins():
	cur = mongo.db.pins.find({})
	pins = list(cur)
	print 'pins', pins
	return jsonResponse({'pins': pins})

# Update a pin
@app.route('/pins/<_id>', methods=['PUT'])
def put_pin(_id):
	pin = request.json
	print 'put', _id, pin
	mongo.db.pins.update({'_id': _id}, pin)
	return jsonResponse({})

# Delete one pin
@app.route('/pins/<_id>', methods=['DELETE'])
def delete_pin(_id):
	mongo.db.pins.delete_one({'_id': _id})
	return jsonResponse({})
