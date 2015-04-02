from flask import Flask
from flask.ext.pymongo import PyMongo
from util import BSONEncoder, BSONDecoder
from os import environ

app = Flask(
	__name__,
	static_url_path='')
app.json_encoder=BSONEncoder
app.json_decoder=BSONDecoder
app.config['MONGO_URI'] = environ['MONGOLAB_URI']
mongo = PyMongo(app)
from prwl import views
