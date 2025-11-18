import psycopg2

class Db:
    def __init__(self):
        # Update these connection parameters with your actual PostgreSQL credentials
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
        self.cursor.execute("SELECT * FROM Sortie;")
        columns = [desc[0] for desc in self.cursor.description]
        return [dict(zip(columns, row)) for row in self.cursor.fetchall()]

# Usage
if __name__ == "__main__":
    db = Db()
    db.create_tables()
    print(db.get_sorties())
