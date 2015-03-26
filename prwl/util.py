from flask import jsonify
from flask.json import JSONEncoder
from bson.objectid import ObjectId
from prwl import app

"""
from bson.json_util import dumps
from json import loads
"""

# Override default JSON encoder to work with BSON
class BSONEncoder(JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        return json.JSONEncoder.default(self, o)
app.json_encoder = BSONEncoder

# Turns a dictionary into a json response.
def jsonResponse(d):
	return jsonify(**d)
