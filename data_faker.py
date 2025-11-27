from faker import Faker
from datetime import datetime
import pandas
from db import Db
from random import choice, randrange
from unidecode import unidecode
from util.wiki import get_obs

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

    def fill_in_biomes(self, m = 150):
        """
        Remple les donnees des biomes (autres que nichoirs)
        
        Args
            m : limite du nombre de biomes
        """

        print("Filling in biomes...")

        df = pandas.read_csv('data/znieff-type2.csv', delimiter=',')
        noms = df['NOM']
        geos = df['Geo Point']
        for i in range(min(len(df), m)):
            if len(noms[i]) <= 50:
                Db().insert_habitat(noms[i], geos[i])

    def gen_users(self, lim = 100):
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

    def gen_oiseaux(self, lim = float('inf')):
        df = pandas.read_csv('data/oiseaux.csv', delimiter=',')
        noms = df['nom']
        nomsci = df['sci']
        i = 0

        adherents = Db().get_adherents()
        biomes = Db().get_biomes_id()
        nichoirs = Db().get_nichoirs_id()

        for nom, sci in zip(noms, nomsci):

            print(f"{i}. {nom} {sci}")

            obs = get_obs(sci)

            taille = obs['taille'] if 'taille' in obs else None
            images = obs['images'] if 'images' in obs else []

            # On insere l'animal
            Db().insert_animal(sci, nom, taille)


            # On stocke toutes les images comme des "observations"
            for image in images:
                if taille and int(taille) < 50:
                    habitat = choice(nichoirs)
                else:
                    habitat = choice(biomes)
                Db().add_observation(choice(adherents), sci, habitat, image)

            # On genere les attributs
            for attr, elts in obs.items():
                if 'attr' in ['images','taille']:
                    continue
                else:
                    for elt in elts:
                        Db().add_animal_info(attr, sci, choice(adherents), elt)

            i+=1
    
    


if __name__ == '__main__':
    pass
    DataGen().fill_in_nichoirs()
    DataGen().fill_in_biomes()
    DataGen().gen_users()