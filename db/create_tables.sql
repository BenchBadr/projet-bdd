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
    IdStatut serial PRIMARY KEY,
    libelle_statut VARCHAR(50),
    CONSTRAINT exists_libelle CHECK (libelle_statut IS NOT NULL)
);

-- Habitat : associe ID / Nom habitat pour avoir des références constantes
-- Note : Cette table englobe le statut éventuel de nichoir par l'intérmediaire de la table info_habitat.

CREATE TABLE Habitat (
    IdHabitat serial PRIMARY KEY,
    nomHabitat VARCHAR(50),
    CONSTRAINT exists_nom_hab CHECK (nomHabitat IS NOT NULL)
);

-- Être vivant : décrit une espèce, nom et relie à différents attributs
-- Nommé ainsi pour éviter la moindre ambiguïté sur les inclusions, les plantes étant des êtres vivants

CREATE TABLE Etre_vivant (
    IdEspece VARCHAR(100) PRIMARY KEY,
    taille float,
    couleur VARCHAR(30)
);

-- Profil : Comme son nom l'indique, stocke un profil individuel indépendant du statut d'adhérent.

CREATE TABLE Profil (
    idProfil serial PRIMARY KEY,
    prenom VARCHAR(50),
    nom VARCHAR(50)
);

-- II. Tables dépendantes

-- Attribut
-- Attribut associé à un être vivant (eg. Forme des ailes, Taille, Couleur, Courbature des griffe...). Attributs propres à chaque espèce mais on utilisera des noms d'attributs similaires dans la mesure du possible pour permettre par la suite de filtrer les espèces stockées.

CREATE TABLE Attribut (
    idAtt serial PRIMARY KEY,
    nom VARCHAR(50),
    idEspece VARCHAR(100) REFERENCES Etre_vivant(IdEspece),
    txt_descriptif VARCHAR(150)
);

-- Coordonnees : Coordonnées liées a un utilisateur dont le type est permissif (num, mail, moodle, discord...) sont tous des types. On fait le choix d'ajouter un id, une personne pouvant renseigner plusieurs adresses mail.
CREATE TABLE Coordonnees (
    idCoord serial PRIMARY KEY,
    profil integer REFERENCES Profil (idProfil),
    type_coord VARCHAR(30),
    coordonnee varchar(50)
);

-- Adhérent : Stocke les numéros d'adhérents associés (accessoirement permet de vérifier facilement si un profil est adhérent)
CREATE TABLE Adherent (
    num integer PRIMARY KEY, -- numero d'adhesion, pas en serial dans la mesure ou cela peut correspondre au numero d'etudiant
    idProfil integer REFERENCES Profil (IdProfil),
    statut integer REFERENCES Statut (idStatut),
    XP integer DEFAULT 0
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
    date_rdv DATE,
    distance_km integer NOT NULL,
    effectif_max integer NOT NULL,
    descriptif text
);

-- Anime : Table stockant les animateurs d'une sortie (puisque pouvant être plusieurs)
CREATE TABLE Anime (
    idProfile integer REFERENCES Profil(idProfil),
    idSortie integer REFERENCES Sortie(idSortie),
    CONSTRAINT pkey_couple PRIMARY KEY (idProfile, idSortie)
);

-- Info Habitat : Stocke toutes les informations concernant un habitat donné. Eg. Superficie, climat, humidité, localisation et surtout: le statut conditionnel de nichoir peremettant par la suite d'obtenir des informations relatives aux nichoirs.
-- Pour ajouter un nichoir, habitat = nichoir suffit, type_info dispensable

CREATE TABLE Info_Habitat (
    idInfoHab serial PRIMARY KEY,
    habitat integer REFERENCES Habitat(idHabitat),
    type_info VARCHAR(100),
    information VARCHAR(200)
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

-- Renseigne : L'écriture des attributs d'espèces est collaborative à la manière de Wikipédia. Cette table permet de garder un historique des modifications afin de récompenser les utilisateurs les plus actifs mais aussi de révoquer les accès aux éditeurs mal intentionnés. On part du principe que les animateurs non-adhérents peuvent contribuer de même d'où l'usage de la table Profil. L'utilisateur pourra renseigner un "commit message" un petit commentaire sur les modifications effectuées rendant l'historique plus accessible par la suite à feuilleter.
CREATE TABLE Renseigne (
    idProfil integer REFERENCES Profil (idProfil),
    idAtt integer REFERENCES Attribut (idAtt),
    date DATE,
    commit_msg VARCHAR(100),
    CONSTRAINT pkey PRIMARY KEY (idProfil, idAtt)
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
-- Donnees d'illustration



INSERT INTO Statut (libelle_statut) VALUES
  ('Étudiant'),
  ('Personnel universitaire'),
  ('Externe'),
  ('Bénévole');


INSERT INTO Habitat (nomHabitat) VALUES
  ('Bois de La Grâce'),
  ('Forêt de Rambouillet'),
  ('Parc de Noisiel'),
  ('Lac du Bois de Lagrange'),
  ('Bords de Marne'),
  ('Bâtiment Rabelais'),
  ('Bâtiment Lavoisier');


INSERT INTO Info_Habitat (habitat, type_info, information) VALUES
    (1, 'superficie', '12 hectares'),
    (1, 'climat', 'Tempéré, humide'),
    (2, 'superficie', '50 hectares'),
    (2, 'climat', 'Forêt dense, sol acide'),
    (3, 'superficie', '8 hectares'),
    (3, 'localisation', 'Centre-ville, accès facile'),
    (4, 'statut_nichoir', 'Présence de nichoirs installés'),
    (4, 'hauteur_nichoir', '7m'),
    (4, 'date_installation_nichoir', '10/07/24'),
    (4, 'lieu_nichoir', 'Rive nord du lac'),
    (4, 'support_nichoir', 'Bois'),
    (5, 'humidité', 'Bords de rivière, sol détrempé'),
    (6, 'usage', 'Bâtiment universitaire, accès restreint'),
    (6, 'statut_nichoir', ''), -- le '' est dispensable juste ici on a prefere le garder pour ne faire qu'un seul insert
    (6, 'hauteur_nichoir', '4m'),
    (6, 'date_installation_nichoir', '15/07/24'),
    (6, 'lieu_nichoir', 'Face Sud'),
    (6, 'support_nichoir', 'Bois');


INSERT INTO Etre_vivant (IdEspece, taille, couleur) VALUES
  ('rougegorge', 0.30, 'brun'),
  ('mesange_charbonniere', 0.12, 'gris'),
  ('fougere_male', 1.10, 'vert'),
  ('scarabee_rhinoceros', 0.05, 'noir'),
  ('herisson', 0.25, 'marron'),
  ('roseau', 0.60, 'vert'),
  ('abeille_domestique', 0.02, 'jaune'),
  ('crapaud_commun_juv', 0.08, 'brun'),
  ('amanite', 0.15, 'blanc'),
  ('canard_colvert_femelle', 0.40, 'gris');

INSERT INTO Attribut (nom, idEspece, txt_descriptif) VALUES
  ('forme_des_ailes', 'rougegorge', 'Ailes arrondies, vol nerveux'),
  ('chant', 'rougegorge', 'Chant mélodieux, territorial'),
  ('feuillage', 'fougere_male', 'Frondes pennées, persistantes'),
  ('stries', 'mesange_charbonniere', 'Bandeau noir, joue blanche'),
  ('épines', 'herisson', 'Épines denses, protection'),
  ('tiges', 'roseau', 'Tiges creuses, colonise berges'),
  ('dard', 'abeille_domestique', 'Dard présent, défensif'),
  ('peau', 'crapaud_commun_juv', 'Peau verruqueuse, brun-olive'),
  ('chapeau', 'amanite', 'Chapeau blanc ponctué, certains variétés sont toxiques voir mortelles, attention'),
  ('bec', 'canard_colvert_femelle', 'Bec plat, adapté à la nage');






-- Profils (Par Python data faker)
INSERT INTO Profil (prenom, nom) VALUES
  ('Jean-Paul', 'Dupont'), -- ajouté a la main en concordance avec l'énoncé
  ('Vincent', 'Chevallier-Girard'),
  ('Odette', 'Antoine'),
  ('Claude', 'Bernier de Diallo'),
  ('Gabriel', 'Leroy'),
  ('Inès', 'Guyot de la Barbe'),
  ('Michelle', 'Thierry-Carlier'),
  ('Gilles', 'Henry'),
  ('Laurence', 'Guillaume-Alexandre'),
  ('Nicolas', 'Boutin'),
  ('Newt', 'Scamander'),
  ('Placeholder', 'Profil'),
  ('Valid', 'Reference');


-- Adherents
INSERT INTO Adherent (num, idProfil, statut, XP) VALUES
  (290630, 1, 1, 900),
  (290631, 2, 2, 1200),
  (290632, 3, 3, 600),
  (290633, 4, 4, 300),
  (290634, 5, 1, 1500),
  (290635, 6, 2, 900),
  (290636, 7, 3, 1200),
  (290637, 8, 4, 600),
  (290638, 9, 1, 300),
  (290639, 10, 2, 1500),
  (290640, 11, 1, 0),
  (290641, 12, 2, 100);


-- Specialite
INSERT INTO Specialise (num, libelle) VALUES
  (290630, 'Ornithologie'),
  (290630, 'Botanique'),
  (290632, 'Entomologie'),
  (290633, 'Mycologie'),
  (290633, 'Herpétologie'),
  (290634, 'Herpétologie'),
  (290634, 'Ornithologie'),
  (290635, 'Botanique'),
  (290635, 'Mycologie'),
  (290636, 'Ornithologie'),
  (290636, 'Botanique'),
  (290637, 'Entomologie'),
  (290637, 'Ornithologie'),
  (290638, 'Mycologie'),
  (290638, 'Botanique'),
  (290639, 'Ornithologie'),
  (290639, 'Herpétologie');


-- Coordonnees diverses
INSERT INTO Coordonnees (profil, type_coord, coordonnee) VALUES
  (1, 'mail', 'jeanpaul@club-internet.fr'),
  (1, 'url', 'http://www.legrand.fr/'),
  (1, 'discord', '@jeanpaul'),

  (2, 'mail', 'richard27@free.fr'),

  (3, 'mail', 'wchartier@gmail.com'),
  (3, 'adresse', '29, avenue Lévy\n40467 Allard'),

  (4, 'url', 'https://www.laine.org/'),
  (4, 'discord', '@rocheralix'),
  (4, 'adresse', '9, rue Simone Meyer\n13861 Sainte René'),

  (5, 'mail', 'sjulien@club-internet.fr'),
  (5, 'url', 'https://www.lebon.com/'),
  (5, 'discord', '@adriennefaure'),

  (6, 'mail', 'mathildelefort@laposte.net'),
  (6, 'discord', '@carolinemathieu'),

  (7, 'mail', 'juliele-roux@hotmail.fr'),
  (7, 'url', 'https://colin.net/'),
  (7, 'adresse', 'rue Martins\n71659 Renard'),

  (8, 'mail', 'tleclercq@yahoo.fr'),
  (8, 'url', 'https://www.lambert.net/'),
  (8, 'adresse', '2, rue David\n02391 Saint Éric'),

  (9, 'mail', 'margaretlecoq@live.com'),
  (9, 'url', 'http://www.delorme.fr/'),
  (9, 'discord', '@valettefranck'),
  (9, 'adresse', '4, chemin de Lenoir\n95818 Sainte Camille-sur-Mer'),

  (10, 'mail', 'margaudcoulon@tiscali.fr'),
  (10, 'url', 'https://www.mary.com/'),
  (10, 'discord', '@sebastien60'),
  (10, 'adresse', '31, rue Joseph\n69426 Bazin'),
  
  (11, 'téléphone', '0779657698');


-- Contributions au codex
INSERT INTO Renseigne (idProfil, idAtt, date, commit_msg) VALUES
  (1, 1, '2025-03-16', 'Clarifie la forme des ailes'),
  (1, 2, '2025-03-16', 'Ajout précision sur le chant'),
  (2, 4, '2025-04-12', 'Décrit les stries faciales'),
  (4, 9, '2025-10-18', 'Mentionne toxicité du chapeau'),
  (6, 5, '2025-03-17', 'Complète la description des épines'),
  (8, 7, '2025-05-10', 'Précise l’usage du dard'),
  (10, 10, '2025-03-20', 'Affinement du contour du bec'),
  (11, 9, '2025-10-18', 'Clarifie les subtilités sur les différents niveaux de toxicités');


-- Sorties
INSERT INTO Sortie (nom, theme, lieu, date_rdv, distance_km, effectif_max, descriptif) VALUES
  ('Jeu du Snapshot #5', 'Oiseaux des zones humides', 1, '2025-03-15', 5, 20, 
   $$### Jeu du Snapshot #5
Observation et identification des oiseaux présents dans les zones humides du Bois de La Grâce.
- Activité ludique en équipe
- Prise de photos et partage d'observations
- Conseils d'experts sur la faune locale$$),

  ('Conférence en plein air', 'Biodiversité locale', 2, '2025-04-12', 8, 25, 
   $$### Conférence en plein air
Présentation sur la biodiversité de la Forêt de Rambouillet.  
- Interventions de spécialistes  
- Questions/réponses  
- Découverte de la faune et de la flore locale$$),

  ('Jeu du Snapshot #3', 'Plantes aquatiques', 4, '2025-05-10', 4, 15, 
   $$### Jeu du Snapshot #3
Sortie dédiée à l'observation des plantes aquatiques du Lac du Bois de Lagrange.  
- Identification des espèces  
- Prises de notes collaboratives  
- Atelier de dessin botanique$$),

  ('Débat + Picnic', 'Protection des habitats', 5, '2025-10-18', 3, 30, 
   $$### Débat + Picnic
Discussion sur les enjeux de la protection des habitats naturels aux Bords de Marne.  
- Débat ouvert à tous  
- Partage d'expériences  
- Picnic convivial en bord de rivière$$),

  ('Apprentissange plantes', 'Reconnaitre les champignons de notre région', 3, '2025-10-18', 6, 10, 
   $$### Apprentissage plantes
Atelier pour apprendre à reconnaître les champignons de la région au Parc de Noisiel.  
- Présentation des espèces locales  
- Conseils sur la cueillette responsable  
- Séance de questions/réponses$$),

  ('Observation des oiseaux', 'Ornithologie', 1, '2025-03-15', 5, 20, 
   $$### Observation des oiseaux
Sortie ornithologique au Bois de La Grâce.  
- Observation des espèces migratrices et résidentes  
- Utilisation de jumelles et guides d'identification  
- Comptage et enregistrement des observations$$);

-- Observe

-- Ajout de plusieurs oiseaux observés

INSERT INTO Observe (num, idEspece, lieu, date, remarques, img) VALUES
    (290630, 'rougegorge', 1, '2025-03-15', 'Observé près des buissons, chant actif', '/uploads/obs/rg_1.jpg'),
    (290631, 'fougere_male', 2, '2025-04-12', 'Frondes jeunes en sous-bois humide', '/uploads/obs/fer_1.jpg'),
    (290633, 'amanite', 3, '2025-10-18', 'Chapeau bien visible, prudence signalée', '/uploads/obs/ama_1.jpg'),
    (290635, 'roseau', 4, '2025-03-17', 'Colonisation berge, vent fort', '/uploads/obs/ros_1.jpg'),
    (290635, 'rougegorge', 4, '2025-03-17', 'Mâle présent dans le nichoir (nidification)', '/uploads/obs/rg_2.jpg'),
    (290637, 'abeille_domestique', 5, '2025-05-10', 'Butinage sur fleurs de prairie', '/uploads/obs/abe_1.jpg'),
    (290639, 'canard_colvert_femelle', 3, '2025-03-20', 'Nage calme, groupe familial', '/uploads/obs/col_1.jpg'),

    (290630, 'mesange_charbonniere', 6, '2025-03-16', 'Vue sur une branche basse, chant aigu', '/uploads/obs/mc_1.jpg'),
    (290635, 'rougegorge', 6, '2025-04-10', 'Chant territorial, vol rapide', '/uploads/obs/rg_3.jpg'),
    (290631, 'canard_colvert_femelle', 6, '2025-05-11', 'Groupe de 3 femelles sur le lac', '/uploads/obs/col_2.jpg'),
    (290638, 'mesange_charbonniere', 6, '2025-03-18', 'Nidification observée sous le toit', '/uploads/obs/mc_2.jpg');






--Inscription 
INSERT INTO Inscription(num, idSortie) VALUES
    (290630, 1),
    (290633, 2),
    (290636, 2),
    (290637, 2),
    (290630, 3),
    (290633, 3),
    (290639, 4),
    (290638, 4)
;


-- Cotisation_Inscription (historique paiements)
INSERT INTO Cotisation_Inscription (mode_paiement, montant, date, num) VALUES
  (2, 50, '2025-01-15', 290630),
  (4, 100, '2025-03-01', 290630),
  (1, 130, '2025-02-10', 290631),
  (2, 130, '2025-03-10', 290632),
  (4, 150, '2025-04-01', 290633),
  (2, 50, '2024-02-20', 290634),
  (2, 100, '2025-01-20', 290635),
  (2, 100, '2025-11-10', 290636),
  (3, 150, '2025-05-10', 290637),
  (1, 50, '2025-05-24', 290638),
  (2, 50, '2025-03-20', 290639);


--Anime 
INSERT INTO Anime(idProfile, idSortie) VALUES
    (2, 1),
    (3, 2),
    (11, 3),
    (11, 4),
    (1, 4),
    (5, 5);

/*
-- Obtenir tous les nichoirs
SELECT h.IdHabitat, h.nomHabitat
FROM Habitat h
JOIN Info_Habitat ih ON h.IdHabitat = ih.habitat
WHERE ih.type_info = 'statut_nichoir';
*/

-- SELECT h.IdHabitat FROM habitat H 
-- WHERE h.idHabitat =  (
--   SELECT idHabitat FROM habitat WHERE habitat = 19
-- );