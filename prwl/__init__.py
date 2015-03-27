'''
TODO:
* currently, the server is giving out ids. Can flask do ids on the client? Should it?

IDs are freaking confusing! But what worked was:
* our js specifically sets 'id' before sending a POST. the response is exactly what we got
* GETs also respond with the id as a normal field
* PUTs do *not* have the ID as a field when ember auto-sends them, but we get it from the route, and set it as a field for the response
'''

from flask import Flask
from flask.ext.pymongo import PyMongo
from util import BSONEncoder, BSONDecoder

app = Flask(
	__name__,
	static_url_path='')
app.json_encoder=BSONEncoder
app.json_decoder=BSONDecoder
mongo = PyMongo(app)
from prwl import views
