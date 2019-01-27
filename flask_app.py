import os
import pkg_resources

import dotenv
from sqlalchemy.exc import OperationalError
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

dotenv.load_dotenv(os.path.join(BASE_DIR, '.env'))

app = Flask(__name__)  # pylint: disable=C0103

app.secret_key = os.environ.get('FLASK_SECRET_KEY', os.urandom(16))

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('FLASK_DB', 'mysql://')

db = SQLAlchemy(app)  # pylint: disable=C0103


def test_db_connection():
    try:
        db.session.query('1').from_statement(db.text('SELECT 1')).all()
        return True
    except OperationalError as error:
        return error


def get_installed_python_packages():
    return [str(dist) for dist in list(pkg_resources.working_set)]


@app.route('/')
def hello():
    template = f"""
<html>
  <head><title>docker + pipenv + mysql</title></head>
  <body>
    <h1>Hello from docker + pipenv + mysql</h1>
    <ul>
      <li>Database connection: {test_db_connection()!s}</li>
      <li>Installed python packages:
        <ul>
          <li>{'</li><li>'.join(get_installed_python_packages())}</li>
        </ul>
      </li>
    </ul>
  </body>
</html>
    """

    return template
