from faker import Faker
from datetime import datetime
from faker_animals import AnimalsProvider
import pandas
from db import Db

class DataGen:
    def __init__(self):
        self.faker =  Faker("fr_FR")
        self.faker.add_provider(AnimalsProvider)

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
    
    



DataGen().fill_in_nichoirs()