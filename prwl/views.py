from flask import request, abort, redirect
from util import json
from models import Pin, User
from prwl import app, lm
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import login_user, current_user, login_required, logout_user

# Create a new pin
@app.route('/pins', methods=['POST'])
@login_required
def create_pin():
	pin = Pin.create(request.json)
	return json({'_id': pin._id})

# Update a pin
@app.route('/pins/<_id>', methods=['PUT'])
@login_required
def update_pin(_id):
	Pin.update({'_id': _id}, request.json)
	return json({})

# Delete one pin
@app.route('/pins/<_id>', methods=['DELETE'])
@login_required
def delete_pin(_id):
	Pin.delete({'_id': _id})
	return json({})

# Get one pin
@app.route('/pins/<_id>', methods=['GET'])
def get_pin(_id):
	pin = Pin.get(_id)
	return json(pin)

# Get all pins
@app.route('/pins', methods=['GET'])
def get_pins():
	filter = request.params
	pins = Pin.get_many(filter)
	return json({'pins': [pin.dict() for pin in pins]})

# Create a new user if none exists.
@app.route('/users', methods=['POST'])
def create_user():
	username, password = request.json.username, request.json.password
	if not User.get({'username': username}):
		user = User.create({
			'username': username,
			'hash': generate_password_hash(password)
		})
		login_user(user)
		return json({'username': username})
	else:
		abort(403)

# Get one user
@app.route('/users/<username>', methods=['GET'])
def get_user(username):
	user = User.get({'username': username})
	return json(user.dict())

# Try to log a user in
@app.route('/users/login', methods=['POST'])
def login():
	username = request.params.username
	password = request.params.password
	user = User.get({'username': username})
	if user and check_password_hash(user.hash, password):
		login_user(user)
		return json({})
	else:
		abort(403)

# Try to log a user in
@app.route('/users/logout', methods=['POST'])
def logout():
	logout_user()
	return json({})

# Redirect base URL to index
@app.route('/')
def base():
	return redirect('/index.html')
