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






@app.route('/sortie_full', methods=['POST'])
def sortie_affichage():
    pass

@app.route('/habitat_full', methods=['POST'])
def habitat_affichage():
    id = request.get_json()['id']
    return jsonify(db.get_habitat_full(id))



# ----------------------------------------------
# Pages du biocodex

@app.route('/count_bioco', methods=['POST'])
def count_bioco():
    '''
    Renvoie le nombre de chacune des pages qui suivent
    '''
    query = request.get_json()['query']
    grp_animal = request.get_json()['grp_anim']
    return jsonify({'count':db.count_bioco(query, grp_animal)})


@app.route('/species', methods=['POST'])
def retrieve_species():
    query = request.get_json()['query']
    offset = request.get_json()['offset']
    grp = request.get_json()['grp']
    return jsonify(db.retrieve_species(query, offset, grp))


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

# ----------------------------------------------
# Pour les dropdowns (deroulantes)



@app.route('/get_themes', methods=['POST'])
def get_themes():
    '''
    Thèmes des sorties
    '''
    return jsonify({'themes':db.get_themes()})


@app.route('/get_grps')
def get_grps():
    '''
    Groupes taxomoniques des especes
    '''
    return jsonify({'grps':db.get_group_tax()})


# ----------------------------------------------
# Le reste

if __name__ == '__main__':
    app.run(debug=True)