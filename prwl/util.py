from flask.json import JSONEncoder, JSONDecoder
from bson.objectid import ObjectId
from flask import jsonify

# Override default JSON encoder/decoder to work with BSON
class BSONEncoder(JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        return JSONEncoder.default(self, o)

class BSONDecoder(JSONDecoder):
	def _renameIds(self, o):
		if isinstance(o, list):
			for item in o:
				self._renameIds(item)
		elif isinstance(o, dict):
			for key in o:
				self._renameIds(o[key])
			if '_id' in o:
				o['_id'] = ObjectId(o['_id'])

	def decode(self, s):
		o = super(JSONDecoder, self).decode(s)
		self._renameIds(o)
		return o

# Turns a dictionary into a json response.
def json(d): return jsonify(**d)
