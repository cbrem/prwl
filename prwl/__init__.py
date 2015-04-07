from flask import Flask
from flask.ext.pymongo import PyMongo
from flask.ext.login import LoginManager
from util import BSONEncoder, BSONDecoder
from os import environ
from flask_sslify import SSLify

app = Flask(
	__name__,
	static_url_path='')
app.json_encoder=BSONEncoder
app.json_decoder=BSONDecoder
app.config['MONGO_URI'] = environ['MONGOLAB_URI']
mongo = PyMongo(app)
lm = LoginManager(app)
if 'DYNO' in environ: sslify = SSLify(app) # Only on heroku
from prwl import views, models, login
