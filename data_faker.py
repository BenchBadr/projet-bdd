from faker import Faker
from datetime import datetime
import pandas
from db import Db
from random import choice, randrange
from unidecode import unidecode

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
    
    def fill_in_nichoirs(self, m = 70):
        """
        Remple les donnees des nichoirs
        
        Args
            m : limite du nombre de nichoirs
        """

        print("Filling in nichoirs...")

        df = pandas.read_csv('data/bor_abrisfaune.csv', delimiter=';')
        noms = df['NOM_SITE_A']
        geos = df['Geo Point']
        for i in range(min(len(df), m)):
            if len(noms[i]) <= 50:
                Db().insert_nichoir(noms[i], geos[i])

    def gen_users(self, lim = 50):
        print("Filling in profiles...")

        unique_usernames = {}

        for i in range(lim):
            nom, prenom = self.faker.first_name(),self.faker.last_name()
            coords = [
                ('mail', f"{prenom.lower()}.{nom.lower()}@{self.faker.free_email_domain()}"),
                ('addr', self.faker.address()),
                ('tel', self.faker.phone_number())
            ]

            # on filtre pour eviter erreurs
            coords = [c for c in coords if len(str(c[1])) <= 150]


            pwd = self.faker.password()

            user_templates = [
                f"{prenom}_{nom}",
                f"{nom}.{prenom}",
                f"{prenom[0]}_{nom}",
                f"{prenom}{nom[0]}",
                f"{prenom}.{nom}{self.faker.random_int(1,99)}"
            ]
            user = unidecode(choice(user_templates)).lower().replace(' ', '')
            if user not in unique_usernames:
                unique_usernames[user] = 0
            else:
                user += f"{unique_usernames[user]}"
                unique_usernames[user] = 0
            unique_usernames[user] += 1

            print(f"{i}. {nom}, {prenom}, {user}")

            Db().create_user(user, prenom, nom, pwd, coords)

            # ~ 90% d'adherents
            if randrange(10) < 9:
                statut = choice([1,2])
                Db().make_adherent(user, statut)
    
    


if __name__ == '__main__':
    pass
    DataGen().fill_in_nichoirs()
    DataGen().gen_users()