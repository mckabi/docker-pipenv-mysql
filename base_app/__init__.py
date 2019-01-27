import os
import dotenv
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

dotenv.load_dotenv(os.path.join(BASE_DIR, '.env'))

app = Flask(__name__)  # pylint: disable=C0103

app.secret_key = os.environ.get('FLASK_SECRET_KEY', 'sampleapp+docker+pipenv+mysql')
for config_key, config_type in [
        ('SQLALCHEMY_DATABASE_URI', str),
        ('SQLALCHEMY_TRACK_MODIFICATIONS', bool),
]:
    if config_key in os.environ:
        config_value = os.environ.get(config_key)
        if config_type != str and callable(config_type):
            config_value = config_type(config_value)
        app.config[config_key] = config_value

db = SQLAlchemy(app)  # pylint: disable=C0103
