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
    
    def get_nichoirs(self):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT h.IdHabitat, h.nomHabitat, h.coords, COUNT(observe.idEspece) AS nb_espece, COUNT(observe.num) AS nb_pers, COUNT(observe.img) AS nb_images
                FROM Habitat h
                JOIN Info_Habitat ih ON h.IdHabitat = ih.habitat
                LEFT JOIN Observe ON observe.lieu = h.idHabitat
                WHERE ih.type_info = 'statut_nichoir'
                GROUP BY h.idHabitat
                LIMIT 6;
                """)
            columns = [desc[0] for desc in cur.description]

            return [dict(zip(columns, row)) for row in cur.fetchall()]
    
    def get_biomes(self):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT h.IdHabitat, h.coords, h.nomHabitat, COUNT(observe.idEspece) AS nb_espece, COUNT(observe.num) AS nb_pers, COUNT(observe.img) AS nb_images
                FROM Habitat h
                JOIN Info_Habitat ih ON h.IdHabitat = ih.habitat
                JOIN Observe ON observe.lieu = h.idHabitat
                WHERE NOT EXISTS (
                    SELECT ih2.type_info FROM Info_Habitat ih2 
                    WHERE ih2.habitat = h.idHabitat AND ih2.type_info = 'statut_nichoir'
                )
                GROUP BY h.idHabitat
                LIMIT 6;
                """)
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
    

    def insert_animal(self, idEspece, taille, couleur):
        try:
            with self.conn.cursor() as cur:
                cur.execute(
                    """
                INSERT INTO Etre_vivant (idEspece, taille, couleur)
                VALUES (%s, %s, %s)
                """, (idEspece, taille, couleur)
                )
        except: 
            pass


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
    
    def get_adherents(self):
        with self.conn.cursor() as cur:
            cur.execute(
                """
                SELECT * FROM 
                Adherent;
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



                
        

    

if __name__ == "__main__":
    db = Db()

    # 0 = nothing, 1 = reset, 2 = backup
    reset = 0

    if reset == 1:
        db.run_action()
        
    if reset == 2:
        db.run_action('dump')

    print(db.get_users())




# dump la DB
# pg_dump -U arl -d arl > db/dump.sql
