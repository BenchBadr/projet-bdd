from flask import Flask, send_from_directory, jsonify
import os
from db import Db

app = Flask(__name__, static_folder='client/build', static_url_path='')
db = Db()


@app.route('/')
def serve_index():
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/<path:path>')
def serve_static(path):
    file_path = os.path.join(app.static_folder, path)
    if os.path.exists(file_path):
        return send_from_directory(app.static_folder, path)
    else:
        return send_from_directory(app.static_folder, 'index.html')
    

@app.route('/sorties')
def get_sorties():
    return jsonify(db.get_sorties())

if __name__ == '__main__':
    app.run(debug=True)