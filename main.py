from flask import Flask, send_from_directory, jsonify
import os
from db import Db

app = Flask(__name__, static_folder='./client/build/')
db = Db()


@app.route('/')
def serve_index():
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve(path):
    if path != "" and os.path.exists(app.static_folder + '/' + path):
        return send_from_directory(app.static_folder, path)
    else:
        return send_from_directory(app.static_folder, 'index.html')

    

@app.route('/sorties')
def get_sorties():
    return jsonify(db.get_sorties())


@app.route('/vivant')
def get_vivants():
    return jsonify(db.get_vivants())


@app.route('/nichoirs')
def get_nichoirs():
    return jsonify(db.get_nichoirs())


@app.route('/biomes')
def get_biomes():
    return jsonify(db.get_biomes())




if __name__ == '__main__':
    app.run(debug=True)