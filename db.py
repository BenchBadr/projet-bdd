import psycopg2

class Db:
    def __init__(self):
        self.conn = psycopg2.connect(
            user='arl',
            dbname='arl',
            password='test',
            host='localhost',
            port='5432'
        )
        self.cursor = self.conn.cursor()

    def create_tables(self, sql_file='db/create_tables.sql'):
        with open(sql_file, 'r') as f:
            sql_script = f.read()
        self.cursor.execute(sql_script)
        self.conn.commit()

    def get_habitat(self):
        self.cursor.execute("SELECT * FROM Habitat;")
        return self.cursor.fetchall()

    def get_sorties(self):
        self.cursor.execute(
            """                    
            SELECT s.*, COUNT(num) AS inscrits, h.nomHabitat AS lieu FROM Sortie s
            NATURAL JOIN Inscription
            JOIN Habitat h ON h.idHabitat = s.lieu
            GROUP BY s.*, s.idSortie, h.nomHabitat;
        """)
        columns = [desc[0] for desc in self.cursor.description]
        return [dict(zip(columns, row)) for row in self.cursor.fetchall()]
    
    def get_nichoirs(self):
        self.cursor.execute(
            """
            SELECT h.IdHabitat, h.nomHabitat, COUNT(observe.idEspece) AS nb_espece, COUNT(observe.num) AS nb_pers, COUNT(observe.img) AS nb_images
            FROM Habitat h
            JOIN Info_Habitat ih ON h.IdHabitat = ih.habitat
            JOIN Observe ON observe.lieu = h.idHabitat
            WHERE ih.type_info = 'statut_nichoir'
            GROUP BY h.idHabitat;
            """)
        columns = [desc[0] for desc in self.cursor.description]

        return [dict(zip(columns, row)) for row in self.cursor.fetchall()]
    
    def get_biomes(self):
        self.cursor.execute(
            """
            SELECT h.IdHabitat, h.nomHabitat, COUNT(observe.idEspece) AS nb_espece, COUNT(observe.num) AS nb_pers, COUNT(observe.img) AS nb_images
            FROM Habitat h
            JOIN Info_Habitat ih ON h.IdHabitat = ih.habitat
            JOIN Observe ON observe.lieu = h.idHabitat
            WHERE NOT EXISTS (
                SELECT ih2.type_info FROM Info_Habitat ih2 
                WHERE ih2.habitat = h.idHabitat AND ih2.type_info = 'statut_nichoir'
            )
            GROUP BY h.idHabitat;
            """)
        columns = [desc[0] for desc in self.cursor.description]

        return [dict(zip(columns, row)) for row in self.cursor.fetchall()]
    

if __name__ == "__main__":
    db = Db()
    db.create_tables()
    print(db.get_sorties())
