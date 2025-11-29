from flask import Flask, send_from_directory, jsonify, request
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

    


############################################################################################################
# 1. Informations statiques
# Une collection de routes permettant l'accès (lecture) de certaines informations

@app.route('/sorties')
def get_sorties():
    # offset = request.get_json()['offset']
    return jsonify(db.get_sorties())


@app.route('/vivant')
def get_vivants():
    offset = request.get_json()['offset']
    query = request.get_json()['query']
    return jsonify(db.get_vivants(query, offset))

@app.route('/animal_full', methods=['POST'])
def animal_full():
    id = request.get_json()['id']
    return jsonify({'animal' : db.animal_full(id)})


@app.route('/nichoirs', methods=['POST'])
def get_nichoirs():
    offset = request.get_json()['offset']
    query = request.get_json()['query']
    return jsonify(db.get_nichoirs(query, offset))


@app.route('/biomes', methods=['POST'])
def get_biomes():
    offset = request.get_json()['offset']
    query = request.get_json()['query']
    return jsonify(db.get_biomes(query, offset))


@app.route('/count_bioco', methods=['POST'])
def count_bioco():
    query = request.get_json()['query']
    return jsonify({'count':db.count_bioco(query)})

@app.route('/species', methods=['POST'])
def retrieve_species():
    query = request.get_json()['query']
    offset = request.get_json()['offset']
    return jsonify(db.retrieve_species(query, offset))





@app.route('/get_themes')
def get_themes():
    return jsonify({'themes':db.get_themes()})



if __name__ == '__main__':
    app.run(debug=True)