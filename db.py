import psycopg2
import bcrypt


class Db:
    def __init__(self):
        self.conn = psycopg2.connect(
            dbname='arl',
        )
        self.conn.autocommit = True

    def run_action(self, action='create_tables'):
        '''
        Lance une action massive (reset de la DB ou load du dernier dump)
        
        :param self: action : create_tables / dump (charge le dernier dump)
        '''
        with self.conn.cursor() as cur:
            with open('db/'+action+'.sql', 'r') as f:
                sql_script = f.read()
            cur.execute(sql_script)
        print(f"Performed action `{action}`")

    def get_habitat(self):
        with self.conn.cursor() as cur:
            cur.execute("SELECT * FROM Habitat;")
            return cur.fetchall()

    def get_sorties(self):
        with self.conn.cursor() as cur:
            cur.execute(
                """                    
                SELECT s.*, COUNT(num) AS inscrits, h.nomHabitat AS lieu FROM Sortie s
                NATURAL JOIN Inscription
                JOIN Habitat h ON h.idHabitat = s.lieu
                GROUP BY s.*, s.idSortie, h.nomHabitat;
            """)
            columns = [desc[0] for desc in cur.description]
            return [dict(zip(columns, row)) for row in cur.fetchall()]
    
    def get_nichoirs(self, query = '', offset = 0):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT h.IdHabitat, h.nomHabitat, h.coords, COUNT(observe.idEspece) AS nb_espece, COUNT(observe.num) AS nb_pers, COUNT(observe.img) AS nb_images
                FROM Habitat h
                JOIN Info_Habitat ih ON h.IdHabitat = ih.habitat
                LEFT JOIN Observe ON observe.lieu = h.idHabitat
                WHERE ih.type_info = 'statut_nichoir' AND h.nomHabitat ILIKE %s
                GROUP BY h.idHabitat
                LIMIT 9
                OFFSET %s;
                """, (f"%{query}%", offset))
            columns = [desc[0] for desc in cur.description]

            return [dict(zip(columns, row)) for row in cur.fetchall()]
    
    def get_biomes(self, query = '', offset = 0):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT h.IdHabitat, h.coords, h.nomHabitat, COUNT(observe.idEspece) AS nb_espece, COUNT(observe.num) AS nb_pers, COUNT(observe.img) AS nb_images
                FROM Habitat h
                LEFT JOIN Info_Habitat ih ON h.IdHabitat = ih.habitat
                LEFT JOIN Observe ON observe.lieu = h.idHabitat
                WHERE NOT EXISTS (
                    SELECT ih2.type_info FROM Info_Habitat ih2 
                    WHERE ih2.habitat = h.idHabitat AND ih2.type_info = 'statut_nichoir'
                ) AND h.nomHabitat ILIKE %s
                GROUP BY h.idHabitat
                LIMIT 9
                OFFSET %s;
                """, (f"%{query}%", offset))
            columns = [desc[0] for desc in cur.description]

            return [dict(zip(columns, row)) for row in cur.fetchall()]
        
    def get_themes(self):
        with self.conn.cursor() as cur: 
            cur.execute(
                """
                SELECT DISTINCT theme FROM 
                Sortie;
                """
            )
            column = [theme[0] for theme in cur.fetchall()]
        return column

        

    def get_animals(self):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT * FROM 
                Etre_vivant;
                """
            )
            themes = cur.fetchall()
        return themes
    
    def get_adherents(self):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT num FROM 
                Adherent;
                """
            )
            numList = [adherent[0] for adherent in cur.fetchall()]
        return numList
    
    def get_nichoirs_id(self):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT idHabitat FROM Habitat
                WHERE idHabitat IN (SELECT habitat FROM Info_Habitat WHERE type_info = 'statut_nichoir')
                """
            )
            nichoir_list = [nichoir[0] for nichoir in cur.fetchall()]
        return nichoir_list
    
    def get_biomes_id(self):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT idHabitat FROM Habitat
                WHERE idHabitat NOT IN (SELECT habitat FROM Info_Habitat WHERE type_info = 'statut_nichoir')
                """
            )
            biome_list = [biome[0] for biome in cur.fetchall()]
        return biome_list
    

    def insert_animal(self, idEspece, nom, taille, groupe):
        with self.conn.cursor() as cur:
            cur.execute(
                """
            INSERT INTO Etre_vivant (idEspece, nomEspece, taille, groupe)
            VALUES (%s, %s, %s, %s)
            """, (idEspece, nom, taille, groupe)
            )

    def add_animal_info(self, info_type, idEspece, auteur, contenu):
        with self.conn.cursor() as cur:
                cur.execute(
                    """
                    INSERT INTO Attribut (type_att, idEspece, auteur, contenu)
                    VALUES (%s, %s, %s, %s)
                    """, (info_type, idEspece, auteur, contenu)
                )


    def add_observation(self, num, idEspece, lieu, img, date):
        with self.conn.cursor() as cur:
                cur.execute(
                    """
                    INSERT INTO Observe (num, idEspece, lieu, img, date)
                    VALUES (%s, %s, %s, %s, %s)
                    """, (num, idEspece, lieu, img, date)
                )


    def insert_nichoir(self, nomHabitat, coords):
            with self.conn.cursor() as cur:

                cur.execute(
                    """
                    INSERT INTO Habitat (nomHabitat, coords)
                    VALUES (%s, %s)
                    RETURNING idHabitat
                    """, (nomHabitat,coords)
                )
                idHabitat = cur.fetchone()[0]
                print(idHabitat)

                cur.execute(
                    """
                    INSERT INTO Info_Habitat (habitat, type_info)
                    VALUES (%s, %s)
                    """, (idHabitat, 'statut_nichoir')
                )



    def insert_habitat(self, nomHabitat, coords):
        try:
            with self.conn.cursor() as cur:

                cur.execute(
                    """
                    INSERT INTO Habitat (nomHabitat, coords)
                    VALUES (%s, %s)
                    RETURNING idHabitat
                    """, (nomHabitat, coords)
                )

        except Exception as e:
            print('ERROR', e)


    def create_user(self, idProfil, prenom, nom, password, coords = []):
        hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())

        with self.conn.cursor() as cur:
            cur.execute("""
                        INSERT INTO Profil (idProfil, prenom, nom, pw_hash) VALUES (%s, %s, %s, %s)
                        """,
                (idProfil, prenom, nom, hashed.decode())
            )


            for ctype, coord in coords:
                cur.execute(
                    "INSERT INTO Coordonnees (profil, type_coord, coordonnee) VALUES (%s, %s, %s)",
                    (idProfil, ctype, coord)
                )


            

    def authenticate_user(self, prenom, password):
        with self.conn.cursor() as cur:
            cur.execute(
                "SELECT motdepasse FROM Profil WHERE prenom = %s",
                (prenom,)
            )
            row = cur.fetchone()

            if row is None:
                return False

            stored_hash = row[0].encode()

            return bcrypt.checkpw(password.encode(), stored_hash)
        
    def get_users(self):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT * FROM 
                Profil;
                """
            )
            users = cur.fetchall()
        return users

    

    def make_adherent(self, idProfil, statut):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO Adherent (idProfil, statut)
                VALUES (%s, %s)
                """,
                (idProfil,statut)
            )

    def count_bioco(self, query = ''):
        with self.conn.cursor() as cur:
            cur.execute("SELECT COUNT(idHabitat) FROM Habitat WHERE nomHabitat ILIKE %s;", (f"%{query}%",))
            count_biomes = cur.fetchone()[0]

            cur.execute("SELECT COUNT(idHabitat) FROM Habitat WHERE idHabitat IN (SELECT habitat FROM Info_Habitat WHERE type_info = 'statut_nichoir') AND nomHabitat ILIKE %s;", (f"%{query}%",))
            count_nichoirs = cur.fetchone()[0]

            cur.execute("SELECT COUNT(idEspece) FROM Etre_vivant;")
            count_vivant = cur.fetchone()[0]

            return (count_vivant, count_nichoirs, count_biomes - count_nichoirs)
        

    def clear_animal(self):
        with self.conn.cursor() as cur:
            cur.execute("TRUNCATE TABLE Attribut, Observe, Etre_vivant CASCADE;")
        print("Suppression de tous les oiseaux")

    def clear_flore(self):
        with self.conn.cursor() as cur:
            cur.execute("DELETE FROM Attribut WHERE idEspece IN (SELECT idEspece FROM Etre_vivant WHERE groupe != 'oiseaux');")
            cur.execute("DELETE FROM Observe WHERE idEspece IN (SELECT idEspece FROM Etre_vivant WHERE groupe != 'oiseaux');")
            cur.execute("DELETE FROM Etre_vivant WHERE groupe != 'oiseaux';")
        print("Suppression de la flore")

    def clear_oiseaux(self):
        with self.conn.cursor() as cur:
            cur.execute("DELETE FROM Attribut WHERE idEspece IN (SELECT idEspece FROM Etre_vivant WHERE groupe = 'oiseaux');")
            cur.execute("DELETE FROM Observe WHERE idEspece IN (SELECT idEspece FROM Etre_vivant WHERE groupe = 'oiseaux');")
            cur.execute("DELETE FROM Etre_vivant WHERE groupe = 'oiseaux';")
        print("Suppression de la flore")

    def get_observations(self):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT img
                FROM Observe
                WHERE img IS NOT NULL AND idEspece = 'Cygnus atratus'
                ORDER BY date
                LIMIT 2;
                """
            )
            return cur.fetchall()
        
    def retrieve_species(self, query = '', offset = 0):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT 
                    DISTINCT ON (ev.idEspece)
                    ev.idEspece as nom_sci, 
                    ev.nomEspece as nom,    
                    ev.groupe as groupe, 
                    ev.taille as taille, 
                    COUNT(o.lieu) AS habitatCount, 
                    Oldest_img.img AS img FROM 
                Etre_vivant AS ev
                LEFT JOIN (
                    SELECT
                        DISTINCT
                        o2.idEspece AS nom_sci, 
                        o2.img,
                        o2.date
                    FROM Observe o2 
                    WHERE o2.img IS NOT NULL
                    ORDER BY o2.date
                ) AS Oldest_img ON ev.idEspece = Oldest_img.nom_sci
                JOIN Observe o ON ev.idEspece = o.idEspece
                WHERE ev.nomEspece ILIKE %s OR ev.idEspece ILIKE %s
                GROUP BY ev.idEspece, ev.nomEspece, ev.groupe, Oldest_img.img
                LIMIT 9
                OFFSET %s;
                """, (f"%{query}%", offset,)
            )
            columns = [desc[0] for desc in cur.description]
            print(columns)
            return [dict(zip(columns, row)) for row in cur.fetchall()]




                
        



if __name__ == "__main__":
    db = Db()

    # 0 = nothing, 1 = reset, 2 = backup

    print(db.count_bioco())
    # print(db.get_observations())
    print(db.retrieve_species())




# dump la DB
# pg_dump -U arl -d arl > db/dump.sql

# revert to dump
# psql -U arl -d arl -f /Users/arl/prog/eiffel/TP\ Infos/projet-bdd/db/dump.sql