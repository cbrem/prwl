"""
TODO:
* should these return an object of the class? like Model.get returns a Model, not a JSON blob?
"""

from prwl import mongo
from bson.objectid import ObjectId
from flask import jsonify

class Model(object):
	db_name = ''
	private_props = [] # Left out in dict()

	def __init__(self, props):
		self.props = props.keys()
		for prop in props: setattr(self, prop, props[prop])

	def dict(self):
		return {prop: getattr(self, prop) for prop in self.props if prop not in self.private_props}

	@classmethod
	def get(cls, filter):
		if '_id' in filter: filter['_id'] = ObjectId(filter['_id'])
		props = getattr(mongo.db, cls.db_name).find_one(filter)
		# TODO: convert _id?
		return cls(props) if props else None

	@classmethod
	def update(cls, filter, props):
		if '_id' in filter: filter['_id'] = ObjectId(filter['_id'])
		getattr(mongo.db, cls.db_name).update(filter, props)

	@classmethod
	def create(cls, props):
		oid = getattr(mongo.db, cls.db_name).insert(props)
		props = cls.get({'_id': oid})
		# TODO: convert _id?
		return cls(props)

	@classmethod
	def delete(cls, filter):
		if '_id' in filter: filter['_id'] = ObjectId(filter['_id'])
		getattr(mongo.db, cls.db_name).delete_one(filter)

	@classmethod
	def get_many(cls, filter):
		if '_id' in filter: filter['_id'] = ObjectId(filter['_id'])
		cur = getattr(mongo.db, cls.db_name).find(filter)
		return [cls(item) for item in list(cur)]

class User(object):
	"""
	-- username
	-- hash
	-- pins
	"""
	db_name = 'users'
	private_props = ['hash', '_id']

	def is_authenticated(self): return True

	def is_active(self): return True

	def is_anonymous(self): return False

	def get_id(self): return self.username

class Pin(Model):
	"""
	-- lat
	-- lng
	-- user
	-- desc
	-- _id
	-- time
	-- tags
	"""
	db_name = 'pins'

class Comment(Model):
	"""
	-- time
	-- user
	-- text
	"""
	db_name = 'comments'