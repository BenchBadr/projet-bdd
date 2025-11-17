from faker import Faker
from datetime import datetime

class DataGen:
    def __init__(self):
        self._faker =  Faker("fr_FR")

        # Génération déterministe pour avoir des tests cohérents
        seed = int(datetime.strptime("24/10/2025", "%d/%m/%Y").strftime("%Y%m%d"))
        if seed is not None:
            self._faker.seed_instance(seed)

    def gen_profile(self) -> dict:
        """
        Generate and return a fake profile as a dictionary.
        """
        return self._faker.profile()
    
    

d = DataGen()
for i in range(10):
    print(d.gen_profile())