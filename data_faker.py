from faker import Faker
from datetime import datetime
import pandas
from db import Db

class DataGen:
    def __init__(self):
        self.faker =  Faker(["fr_FR"])

        # Génération déterministe pour avoir des tests cohérents
        seed = int(datetime.strptime("24/10/2025", "%d/%m/%Y").strftime("%Y%m%d"))
        if seed is not None:
            self.faker.seed_instance(seed)

    def gen_profile(self) -> dict:
        """
        Genere un profile
        """
        return self.faker.profile()
    
    def gen_animal(self) -> dict:
        """
        Genere un animal
        """
        return self.faker.animal()
    
    def fill_in_nichoirs(self, m = float('inf')):
        """
        Remple les donnees des nichoirs
        
        Args
            m : limite du nombre de nichoirs
        """
        df = pandas.read_csv('data/bor_abrisfaune.csv', delimiter=';')
        noms = df['NOM_SITE_A']
        geos = df['Geo Point']
        for i in range(min(len(df), m)):
            if len(noms[i]) <= 50:
                Db().insert_nichoir(noms[i], geos[i])
        print('filled in success')

    def gen_users(self, lim = 500):
        # coords = [
        #     ('mail', profile['mail']),
        #     ('addr', profile['address'])
        # ]
        for i in range(10):
            nom, prenom = self.faker.first_name(),self.faker.last_name()
            coords = [
                ('mail', f"{prenom.lower()}.{nom.lower()}@{self.faker.free_email_domain()}"),
                ('addr', self.faker.address())
            ]
            print(f"Nom: {nom}, Prénom: {prenom}, Coords: {coords}")
    
    



print(DataGen().gen_users())