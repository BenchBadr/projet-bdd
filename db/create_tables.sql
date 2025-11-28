-- psql -U arl -h localhost -d postgres -f create_tables.sql

-- Les drop pour eviter des erreurs
DROP TABLE IF EXISTS Specialise CASCADE;
DROP TABLE IF EXISTS Inscription CASCADE;
DROP TABLE IF EXISTS Coordonnees CASCADE;
DROP TABLE IF EXISTS Renseigne CASCADE;
DROP TABLE IF EXISTS Observe CASCADE;
DROP TABLE IF EXISTS Info_Habitat CASCADE;
DROP TABLE IF EXISTS Anime CASCADE;
DROP TABLE IF EXISTS Sortie CASCADE;
DROP TABLE IF EXISTS Cotisation_Inscription CASCADE;
DROP TABLE IF EXISTS Adherent CASCADE;
DROP TABLE IF EXISTS Attribut CASCADE;
DROP TABLE IF EXISTS Profil CASCADE;
DROP TABLE IF EXISTS Etre_vivant CASCADE;
DROP TABLE IF EXISTS Habitat CASCADE;
DROP TABLE IF EXISTS Statut CASCADE;

-- I. **Tables indépendantes** - À savoir les tables sans références externes

-- Statut : associe un ID à un statut, en prévision d'un éventuel renommage de statut.

CREATE TABLE Statut (
    IdStatut integer PRIMARY KEY,
    libelle_statut VARCHAR(50),
    CONSTRAINT exists_libelle CHECK (libelle_statut IS NOT NULL)
);

-- Habitat : associe ID / Nom habitat pour avoir des références constantes
-- Note : Cette table englobe le statut éventuel de nichoir par l'intérmediaire de la table info_habitat.

CREATE TABLE Habitat (
    IdHabitat serial PRIMARY KEY,
    nomHabitat VARCHAR(50),
    coords VARCHAR(150),
    CONSTRAINT exists_nom_hab CHECK (nomHabitat IS NOT NULL)
);

-- Être vivant : décrit une espèce, nom et relie à différents attributs
-- Nommé ainsi pour éviter la moindre ambiguïté sur les inclusions, les plantes étant des êtres vivants

CREATE TABLE Etre_vivant (
    IdEspece VARCHAR(100) PRIMARY KEY,
    nomEspece VARCHAR(100),
    groupe VARCHAR(100),
    taille float
);

-- Profil : Comme son nom l'indique, stocke un profil individuel indépendant du statut d'adhérent.

CREATE TABLE Profil (
    idProfil VARCHAR(32) PRIMARY KEY,
    prenom VARCHAR(50),
    nom VARCHAR(50),
    pw_hash VARCHAR(500) -- jamais trop surs avec le hash
);

-- II. Tables dépendantes



-- Coordonnees : Coordonnées liées a un utilisateur dont le type est permissif (num, mail, moodle, discord...) sont tous des types. On fait le choix d'ajouter un id, une personne pouvant renseigner plusieurs adresses mail.
CREATE TABLE Coordonnees (
    idCoord serial PRIMARY KEY,
    profil VARCHAR(32) REFERENCES Profil (idProfil),
    type_coord VARCHAR(30),
    coordonnee varchar(150)
);

-- Adhérent : Stocke les numéros d'adhérents associés (accessoirement permet de vérifier facilement si un profil est adhérent)
CREATE TABLE Adherent (
    num BIGSERIAL PRIMARY KEY,
    idProfil VARCHAR(32) REFERENCES Profil (idProfil),
    statut integer REFERENCES Statut (idStatut),
    XP integer DEFAULT 0
);

-- Attribut
-- Attribut associé à un être vivant (eg. Forme des ailes, Taille, Couleur, Courbature des griffe...). Attributs propres à chaque espèce mais on utilisera des noms d'attributs similaires dans la mesure du possible pour permettre par la suite de filtrer les espèces stockées.

CREATE TABLE Attribut (
    idAtt serial PRIMARY KEY,
    type_att VARCHAR(50),
    idEspece VARCHAR(100) REFERENCES Etre_vivant(IdEspece),
    auteur integer REFERENCES Adherent (num),
    contenu text

);

-- Cotisation Inscription
-- Pour vérifier l'historique des paiements des adhérents. Les modes de paiements sont restreint à (1,2,3, 4) correspondants respectivement a (espece, carte, cheque, izly)

CREATE TABLE Cotisation_Inscription (
    idPaiement serial PRIMARY KEY,
    mode_paiement int,
    montant integer,
    date DATE,
    num integer REFERENCES Adherent(num),
    CONSTRAINT modePaiementValide CHECK (mode_paiement in (1, 2, 3, 4))
);

-- Sortie : définit une sortie. L'animateur est renseigné par son ID.

CREATE TABLE Sortie (
    idSortie serial PRIMARY KEY,
    nom VARCHAR(50),
    theme VARCHAR(100),
    lieu integer REFERENCES Habitat(idHabitat) NOT NULL,
    date_rdv TIMESTAMP,
    distance_km integer NOT NULL,
    effectif_max integer NOT NULL,
    descriptif text
);

-- Anime : Table stockant les animateurs d'une sortie (puisque pouvant être plusieurs)
CREATE TABLE Anime (
    idProfile VARCHAR(32) REFERENCES Profil (idProfil),
    idSortie integer REFERENCES Sortie(idSortie),
    CONSTRAINT pkey_couple PRIMARY KEY (idProfile, idSortie)
);

-- Info Habitat : Stocke toutes les informations concernant un habitat donné. Eg. Superficie, climat, humidité, localisation et surtout: le statut conditionnel de nichoir peremettant par la suite d'obtenir des informations relatives aux nichoirs.
-- Pour ajouter un nichoir, habitat = nichoir suffit, type_info dispensable

CREATE TABLE Info_Habitat (
    idInfoHab serial PRIMARY KEY,
    habitat integer REFERENCES Habitat(idHabitat),
    type_info VARCHAR(100),
    information VARCHAR(200),
    auteur VARCHAR(32) REFERENCES Profil (idProfil)
);

-- Observe : Permet de renseigner les especes observées dans un lieu donné. Comme pour un petit jeu "repérer toutes les espèces d'un habitat". Le descriptif serait épisodique, indépendant des attributs de l'espèce simplement des informations du type "je l'ai trouvé dans un tronc d'arbre"
CREATE TABLE Observe (
    num integer REFERENCES Adherent (num),
    idEspece VARCHAR(100) REFERENCES Etre_vivant(idEspece),
    lieu integer REFERENCES Habitat(idHabitat),
    date DATE,
    remarques VARCHAR(500),
    img VARCHAR(200),
    CONSTRAINT observe_pkey PRIMARY KEY (num, idEspece, lieu)
);


-- Inscription : renseigne tous les adherents inscripts aux sorties
CREATE TABLE Inscription (
    num integer REFERENCES Adherent(num),
    idSortie integer REFERENCES Sortie(idSortie),
    CONSTRAINT pkey_ins PRIMARY KEY (num, idSortie)
);


-- Specialise : Permet d'ajouter des spécialités à un adhérent.
CREATE TABLE Specialise (
  num integer REFERENCES Adherent(num),
  libelle VARCHAR(50),
  CONSTRAINT pkey_spe PRIMARY KEY (num, libelle)
);

------------------------------------------------------------------------------------------------------
-- Pour Jean-Paul
-- CREATE USER JeanPaul WITH PASSWORD 'motdepasse_secret';

CREATE VIEW EspecesFrequentes (idHabitat, idEspece, nombre_observations) AS
  SELECT DISTINCT ON (Habitat.idHabitat) Habitat.idHabitat, Etre_vivant.idEspece, COUNT(*) AS nombre_observations
  FROM observe
    JOIN Habitat ON observe.lieu = Habitat.idHabitat
    JOIN Info_Habitat ON observe.lieu = Habitat.idHabitat
    JOIN Etre_vivant ON observe.idEspece = Etre_vivant.idEspece
  WHERE Info_Habitat.type_info = 'statut_nichoir'
  GROUP BY Habitat.idHabitat, Etre_vivant.idEspece
  ORDER BY Habitat.idHabitat, nombre_observations DESC;

CREATE VIEW ObservationsMensuelles (idHabitat, mois, nombre_observations) AS (
  SELECT  habitat.idHabitat, EXTRACT(MONTH FROM observe.date) AS mois, count(*) AS nombre_observations
  FROM observe JOIN habitat ON  observe.lieu = habitat.idHabitat JOIN Info_Habitat ON  observe.lieu = Info_Habitat.Habitat
  WHERE type_info = 'statut_nichoir'
  GROUP BY habitat.idHabitat, EXTRACT(MONTH FROM observe.date)
);

------------------------------------------------------------------------------------------------------
-- Donnees de base

INSERT INTO Statut (idStatut, libelle_statut) VALUES
  (1,'Étudiant'),
  (2,'Personnel universitaire'),
  (3,'Externe'),
  (4,'Bénévole');