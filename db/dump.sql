--
-- PostgreSQL database dump
--

-- Dumped from database version 14.14 (Homebrew)
-- Dumped by pg_dump version 14.14 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adherent; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.adherent (
    num bigint NOT NULL,
    idprofil character varying(32),
    statut integer,
    xp integer DEFAULT 0
);


ALTER TABLE public.adherent OWNER TO arl;

--
-- Name: adherent_num_seq; Type: SEQUENCE; Schema: public; Owner: arl
--

CREATE SEQUENCE public.adherent_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adherent_num_seq OWNER TO arl;

--
-- Name: adherent_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arl
--

ALTER SEQUENCE public.adherent_num_seq OWNED BY public.adherent.num;


--
-- Name: anime; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.anime (
    idprofile character varying(32) NOT NULL,
    idsortie integer NOT NULL
);


ALTER TABLE public.anime OWNER TO arl;

--
-- Name: attribut; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.attribut (
    idatt integer NOT NULL,
    nom character varying(50),
    idespece character varying(100),
    txt_descriptif character varying(150)
);


ALTER TABLE public.attribut OWNER TO arl;

--
-- Name: attribut_idatt_seq; Type: SEQUENCE; Schema: public; Owner: arl
--

CREATE SEQUENCE public.attribut_idatt_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attribut_idatt_seq OWNER TO arl;

--
-- Name: attribut_idatt_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arl
--

ALTER SEQUENCE public.attribut_idatt_seq OWNED BY public.attribut.idatt;


--
-- Name: coordonnees; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.coordonnees (
    idcoord integer NOT NULL,
    profil character varying(32),
    type_coord character varying(30),
    coordonnee character varying(150)
);


ALTER TABLE public.coordonnees OWNER TO arl;

--
-- Name: coordonnees_idcoord_seq; Type: SEQUENCE; Schema: public; Owner: arl
--

CREATE SEQUENCE public.coordonnees_idcoord_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coordonnees_idcoord_seq OWNER TO arl;

--
-- Name: coordonnees_idcoord_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arl
--

ALTER SEQUENCE public.coordonnees_idcoord_seq OWNED BY public.coordonnees.idcoord;


--
-- Name: cotisation_inscription; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.cotisation_inscription (
    idpaiement integer NOT NULL,
    mode_paiement integer,
    montant integer,
    date date,
    num integer,
    CONSTRAINT modepaiementvalide CHECK ((mode_paiement = ANY (ARRAY[1, 2, 3, 4])))
);


ALTER TABLE public.cotisation_inscription OWNER TO arl;

--
-- Name: cotisation_inscription_idpaiement_seq; Type: SEQUENCE; Schema: public; Owner: arl
--

CREATE SEQUENCE public.cotisation_inscription_idpaiement_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cotisation_inscription_idpaiement_seq OWNER TO arl;

--
-- Name: cotisation_inscription_idpaiement_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arl
--

ALTER SEQUENCE public.cotisation_inscription_idpaiement_seq OWNED BY public.cotisation_inscription.idpaiement;


--
-- Name: etre_vivant; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.etre_vivant (
    idespece character varying(100) NOT NULL,
    taille double precision,
    couleur character varying(30)
);


ALTER TABLE public.etre_vivant OWNER TO arl;

--
-- Name: habitat; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.habitat (
    idhabitat integer NOT NULL,
    nomhabitat character varying(50),
    CONSTRAINT exists_nom_hab CHECK ((nomhabitat IS NOT NULL))
);


ALTER TABLE public.habitat OWNER TO arl;

--
-- Name: info_habitat; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.info_habitat (
    idinfohab integer NOT NULL,
    habitat integer,
    type_info character varying(100),
    information character varying(200),
    auteur character varying(32)
);


ALTER TABLE public.info_habitat OWNER TO arl;

--
-- Name: observe; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.observe (
    num integer NOT NULL,
    idespece character varying(100) NOT NULL,
    lieu integer NOT NULL,
    date date,
    remarques character varying(500),
    img character varying(200)
);


ALTER TABLE public.observe OWNER TO arl;

--
-- Name: especesfrequentes; Type: VIEW; Schema: public; Owner: arl
--

CREATE VIEW public.especesfrequentes AS
 SELECT DISTINCT ON (habitat.idhabitat) habitat.idhabitat,
    etre_vivant.idespece,
    count(*) AS nombre_observations
   FROM (((public.observe
     JOIN public.habitat ON ((observe.lieu = habitat.idhabitat)))
     JOIN public.info_habitat ON ((observe.lieu = habitat.idhabitat)))
     JOIN public.etre_vivant ON (((observe.idespece)::text = (etre_vivant.idespece)::text)))
  WHERE ((info_habitat.type_info)::text = 'statut_nichoir'::text)
  GROUP BY habitat.idhabitat, etre_vivant.idespece
  ORDER BY habitat.idhabitat, (count(*)) DESC;


ALTER TABLE public.especesfrequentes OWNER TO arl;

--
-- Name: habitat_idhabitat_seq; Type: SEQUENCE; Schema: public; Owner: arl
--

CREATE SEQUENCE public.habitat_idhabitat_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.habitat_idhabitat_seq OWNER TO arl;

--
-- Name: habitat_idhabitat_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arl
--

ALTER SEQUENCE public.habitat_idhabitat_seq OWNED BY public.habitat.idhabitat;


--
-- Name: info_habitat_idinfohab_seq; Type: SEQUENCE; Schema: public; Owner: arl
--

CREATE SEQUENCE public.info_habitat_idinfohab_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.info_habitat_idinfohab_seq OWNER TO arl;

--
-- Name: info_habitat_idinfohab_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arl
--

ALTER SEQUENCE public.info_habitat_idinfohab_seq OWNED BY public.info_habitat.idinfohab;


--
-- Name: inscription; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.inscription (
    num integer NOT NULL,
    idsortie integer NOT NULL
);


ALTER TABLE public.inscription OWNER TO arl;

--
-- Name: observationsmensuelles; Type: VIEW; Schema: public; Owner: arl
--

CREATE VIEW public.observationsmensuelles AS
 SELECT habitat.idhabitat,
    EXTRACT(month FROM observe.date) AS mois,
    count(*) AS nombre_observations
   FROM ((public.observe
     JOIN public.habitat ON ((observe.lieu = habitat.idhabitat)))
     JOIN public.info_habitat ON ((observe.lieu = info_habitat.habitat)))
  WHERE ((info_habitat.type_info)::text = 'statut_nichoir'::text)
  GROUP BY habitat.idhabitat, (EXTRACT(month FROM observe.date));


ALTER TABLE public.observationsmensuelles OWNER TO arl;

--
-- Name: profil; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.profil (
    idprofil character varying(32) NOT NULL,
    prenom character varying(50),
    nom character varying(50),
    pw_hash character varying(500)
);


ALTER TABLE public.profil OWNER TO arl;

--
-- Name: renseigne; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.renseigne (
    idprofil character varying(32) NOT NULL,
    idatt integer NOT NULL,
    date date,
    commit_msg character varying(100)
);


ALTER TABLE public.renseigne OWNER TO arl;

--
-- Name: sortie; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.sortie (
    idsortie integer NOT NULL,
    nom character varying(50),
    theme character varying(100),
    lieu integer NOT NULL,
    date_rdv timestamp without time zone,
    distance_km integer NOT NULL,
    effectif_max integer NOT NULL,
    descriptif text
);


ALTER TABLE public.sortie OWNER TO arl;

--
-- Name: sortie_idsortie_seq; Type: SEQUENCE; Schema: public; Owner: arl
--

CREATE SEQUENCE public.sortie_idsortie_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sortie_idsortie_seq OWNER TO arl;

--
-- Name: sortie_idsortie_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arl
--

ALTER SEQUENCE public.sortie_idsortie_seq OWNED BY public.sortie.idsortie;


--
-- Name: specialise; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.specialise (
    num integer NOT NULL,
    libelle character varying(50) NOT NULL
);


ALTER TABLE public.specialise OWNER TO arl;

--
-- Name: statut; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.statut (
    idstatut integer NOT NULL,
    libelle_statut character varying(50),
    CONSTRAINT exists_libelle CHECK ((libelle_statut IS NOT NULL))
);


ALTER TABLE public.statut OWNER TO arl;

--
-- Name: adherent num; Type: DEFAULT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.adherent ALTER COLUMN num SET DEFAULT nextval('public.adherent_num_seq'::regclass);


--
-- Name: attribut idatt; Type: DEFAULT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.attribut ALTER COLUMN idatt SET DEFAULT nextval('public.attribut_idatt_seq'::regclass);


--
-- Name: coordonnees idcoord; Type: DEFAULT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.coordonnees ALTER COLUMN idcoord SET DEFAULT nextval('public.coordonnees_idcoord_seq'::regclass);


--
-- Name: cotisation_inscription idpaiement; Type: DEFAULT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.cotisation_inscription ALTER COLUMN idpaiement SET DEFAULT nextval('public.cotisation_inscription_idpaiement_seq'::regclass);


--
-- Name: habitat idhabitat; Type: DEFAULT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.habitat ALTER COLUMN idhabitat SET DEFAULT nextval('public.habitat_idhabitat_seq'::regclass);


--
-- Name: info_habitat idinfohab; Type: DEFAULT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.info_habitat ALTER COLUMN idinfohab SET DEFAULT nextval('public.info_habitat_idinfohab_seq'::regclass);


--
-- Name: sortie idsortie; Type: DEFAULT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.sortie ALTER COLUMN idsortie SET DEFAULT nextval('public.sortie_idsortie_seq'::regclass);


--
-- Data for Name: adherent; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.adherent (num, idprofil, statut, xp) FROM stdin;
1	pruvost.francoise31	2	0
2	virginie.alexandre	2	0
3	g_bertrand	2	0
4	adele.costa	1	0
5	b_agathe	1	0
6	guillou_laure	1	0
7	oceane.masse	1	0
8	raynaud.antoinette10	1	0
9	legendre.penelope73	1	0
10	albert.etienne65	2	0
11	gomez_jean	2	0
12	daniel.nicolas	1	0
13	zacharie.thierry	2	0
14	suzanne.ferrand	1	0
15	thierry.bazin	2	0
16	legalln	2	0
17	emilie.delannoy	1	0
18	carre.stephane46	1	0
19	b_suzanne	1	0
20	delahaye_remy	1	0
21	b_dominique	1	0
22	f_maurice	2	0
23	leroux_eugene	1	0
24	v_maggie	2	0
25	m_jeanne	2	0
26	daniel.peron	2	0
27	gauthierg	1	0
28	bourgeoism	1	0
29	marie.adrienne20	1	0
30	lefebvre.daniel59	2	0
31	lebreton.diane94	2	0
32	benoit_marianne	1	0
33	l_maurice	1	0
34	bertin_marianne	2	0
35	d_constance	2	0
36	godard_michelle	2	0
37	robinm	1	0
38	paul.pereira	1	0
39	barbes	1	0
40	isaac.lemoine	1	0
41	thomaso	1	0
42	penelope.pires	1	0
43	toussaint.emmanuelle8	2	0
44	zacharie.leduc	2	0
45	gerard.laurent	2	0
46	hoarau_maggie	2	0
47	leduci	2	0
\.


--
-- Data for Name: anime; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.anime (idprofile, idsortie) FROM stdin;
\.


--
-- Data for Name: attribut; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.attribut (idatt, nom, idespece, txt_descriptif) FROM stdin;
\.


--
-- Data for Name: coordonnees; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.coordonnees (idcoord, profil, type_coord, coordonnee) FROM stdin;
1	pruvost.francoise31	mail	pruvost.françoise@ifrance.com
2	pruvost.francoise31	addr	11, boulevard Mahe\n30781 Fernandes
3	pruvost.francoise31	tel	+33 (0)1 80 35 98 86
4	virginie.alexandre	mail	alexandre.virginie@tele2.fr
5	virginie.alexandre	addr	50, chemin Vallée\n77932 Bertrand
6	virginie.alexandre	tel	+33 7 69 44 52 76
7	g_bertrand	mail	georges.bertrand@tele2.fr
8	g_bertrand	addr	40, chemin Wagner\n48396 Coulon
9	g_bertrand	tel	02 79 50 44 27
10	adele.costa	mail	costa.adèle@voila.fr
11	adele.costa	addr	avenue Guérin\n03396 Robert
12	adele.costa	tel	0366442701
13	b_agathe	mail	bailly.agathe@tele2.fr
14	b_agathe	addr	18, avenue Bonnin\n34394 Lopez
15	b_agathe	tel	+33 (0)2 23 47 40 46
16	guillou_laure	mail	guillou.laure@gmail.com
17	guillou_laure	addr	37, boulevard Besson\n29906 Gauthier
18	guillou_laure	tel	+33 (0)4 15 43 15 64
19	oceane.masse	mail	masse.océane@orange.fr
20	oceane.masse	addr	7, rue de Cousin\n51266 Giraud-sur-Mer
21	oceane.masse	tel	+33 (0)2 79 51 74 80
22	raynaud.antoinette10	mail	raynaud.antoinette@dbmail.com
23	raynaud.antoinette10	addr	69, avenue de Richard\n09330 Delaunay
24	raynaud.antoinette10	tel	05 49 07 11 59
25	legendre.penelope73	mail	legendre.pénélope@orange.fr
26	legendre.penelope73	addr	227, boulevard Barthelemy\n91411 Pons-sur-Mer
27	legendre.penelope73	tel	04 38 17 42 26
28	albert.etienne65	mail	albert.étienne@wanadoo.fr
29	albert.etienne65	addr	77, rue Becker\n63345 HardyBourg
30	albert.etienne65	tel	+33 3 70 03 43 20
31	gomez_jean	mail	gomez.jean@gmail.com
32	gomez_jean	addr	75, rue Théodore Normand\n66532 Gimenez
33	gomez_jean	tel	+33 4 49 83 88 30
34	daniel.nicolas	mail	nicolas.daniel@free.fr
35	daniel.nicolas	addr	chemin Pires\n01180 Sainte LéonBourg
36	daniel.nicolas	tel	01 79 36 49 03
37	zacharie.thierry	mail	thierry.zacharie@tele2.fr
38	zacharie.thierry	addr	73, rue Guillaume\n44183 Evrard
39	zacharie.thierry	tel	0241433563
40	suzanne.ferrand	mail	ferrand.suzanne@laposte.net
41	suzanne.ferrand	addr	62, rue Stéphanie Delorme\n81930 Regnier
42	suzanne.ferrand	tel	0443465762
43	thierry.bazin	mail	bazin.thierry@free.fr
44	thierry.bazin	addr	43, rue Élise Renaud\n74102 Allain
45	thierry.bazin	tel	+33 3 10 88 13 00
46	legalln	mail	le gall.nicole@noos.fr
47	legalln	addr	chemin de Vaillant\n03216 Robin-sur-Langlois
48	legalln	tel	06 75 85 05 90
49	emilie.delannoy	mail	delannoy.émilie@yahoo.fr
50	emilie.delannoy	addr	6, rue Moreau\n08855 Lebrun
51	emilie.delannoy	tel	0772919444
52	carre.stephane46	mail	carre.stéphane@voila.fr
53	carre.stephane46	addr	389, rue Schneider\n67232 Sainte Chantal
54	carre.stephane46	tel	01 69 70 05 64
55	b_suzanne	mail	blot.suzanne@tiscali.fr
56	b_suzanne	addr	11, chemin Charles Carlier\n40849 Saint Luc
57	b_suzanne	tel	+33 (0)5 17 74 75 77
58	delahaye_remy	mail	delahaye.rémy@hotmail.fr
59	delahaye_remy	addr	32, rue Richard\n41334 Vaillant
60	delahaye_remy	tel	+33 2 77 46 09 80
61	b_dominique	mail	blanchet.dominique@tiscali.fr
62	b_dominique	addr	12, avenue Margaret Weiss\n09961 Hamonnec
63	b_dominique	tel	+33 (0)5 57 06 13 36
64	f_maurice	mail	fabre.maurice@tiscali.fr
65	f_maurice	addr	11, chemin de Lelièvre\n41301 Saint Arthur-la-Forêt
66	f_maurice	tel	+33 2 34 84 15 78
67	lefort.lucie58	mail	lefort.lucie@tele2.fr
68	lefort.lucie58	addr	23, rue de Techer\n10578 Hardy
69	lefort.lucie58	tel	+33 (0)2 50 41 21 36
70	gimenez_robert	mail	gimenez.robert@sfr.fr
71	gimenez_robert	addr	735, rue Agathe Dos Santos\n38193 Hebert
72	gimenez_robert	tel	+33 4 81 81 39 13
73	leroux_eugene	mail	le roux.eugène@club-internet.fr
74	leroux_eugene	addr	35, rue Hugues Le Roux\n30521 Mercierboeuf
75	leroux_eugene	tel	+33 4 74 59 71 19
76	v_maggie	mail	voisin.maggie@club-internet.fr
77	v_maggie	addr	10, rue de Lombard\n79302 Charlesdan
78	v_maggie	tel	03 64 27 07 67
79	m_jeanne	mail	muller.jeanne@bouygtel.fr
80	m_jeanne	addr	314, rue Rousset\n29283 Saint Élise
81	m_jeanne	tel	04 73 13 99 18
82	daniel.peron	mail	peron.daniel@ifrance.com
83	daniel.peron	addr	31, rue Tristan Leclercq\n87250 Guyon-sur-Becker
84	daniel.peron	tel	+33 5 79 83 74 70
85	gauthierg	mail	gauthier.georges@club-internet.fr
86	gauthierg	addr	chemin de Lecoq\n74980 Lemonnierboeuf
87	gauthierg	tel	+33 (0)5 24 97 51 81
88	bourgeoism	mail	bourgeois.michelle@voila.fr
89	bourgeoism	addr	39, chemin de Delannoy\n82576 Fournier-sur-Pelletier
90	bourgeoism	tel	02 40 41 25 66
91	marie.adrienne20	mail	marie.adrienne@dbmail.com
92	marie.adrienne20	addr	94, chemin Margaud Chevallier\n90786 Garnier
93	marie.adrienne20	tel	0144440954
94	lefebvre.daniel59	mail	lefebvre.daniel@bouygtel.fr
95	lefebvre.daniel59	addr	977, rue de Carpentier\n75486 Bodin
96	lefebvre.daniel59	tel	+33 6 95 43 93 48
97	lebreton.diane94	mail	lebreton.diane@noos.fr
98	lebreton.diane94	addr	85, boulevard de Bourdon\n07534 Rémy-sur-Martinez
99	lebreton.diane94	tel	+33 4 85 54 42 22
100	benoit_marianne	mail	benoit.marianne@orange.fr
101	benoit_marianne	addr	35, rue Lacroix\n57597 Vidal
102	benoit_marianne	tel	0379543882
103	l_maurice	mail	letellier.maurice@wanadoo.fr
104	l_maurice	addr	55, avenue de Masse\n97344 BoyerBourg
105	l_maurice	tel	0516811082
106	bertin_marianne	mail	bertin.marianne@yahoo.fr
107	bertin_marianne	addr	8, rue Rolland\n25381 Legrand
108	bertin_marianne	tel	+33 2 23 53 95 53
109	d_constance	mail	dos santos.constance@laposte.net
110	d_constance	addr	3, rue Georges Maury\n51363 Gay
111	d_constance	tel	+33 (0)4 77 11 75 84
112	godard_michelle	mail	godard.michelle@orange.fr
113	godard_michelle	addr	boulevard Martin Le Roux\n55296 Saint Philippe-les-Bains
114	godard_michelle	tel	+33 2 33 41 87 75
115	robinm	mail	robin.martine@live.com
116	robinm	addr	92, avenue Legros\n16805 Sainte Timothée
117	robinm	tel	+33 (0)4 98 47 68 52
118	paul.pereira	mail	pereira.paul@tiscali.fr
119	paul.pereira	addr	392, rue Lopez\n59845 Moulin
120	paul.pereira	tel	+33 (0)4 73 99 22 67
121	barbes	mail	barbe.susan@gmail.com
122	barbes	addr	boulevard Stéphanie Vaillant\n52914 PerretBourg
123	barbes	tel	+33 (0)4 15 72 17 39
124	pelletierl	mail	pelletier.laetitia@voila.fr
125	pelletierl	addr	avenue Émile Boulay\n40789 Weiss-sur-Loiseau
126	pelletierl	tel	+33 2 28 39 72 07
127	isaac.lemoine	mail	lemoine.isaac@tele2.fr
128	isaac.lemoine	addr	980, chemin Corinne Delmas\n04119 Descamps-sur-Rossi
129	isaac.lemoine	tel	+33 4 79 42 53 25
130	thomaso	mail	thomas.olivier@voila.fr
131	thomaso	addr	17, chemin Zoé Techer\n20495 Perrin-les-Bains
132	thomaso	tel	+33 (0)1 60 23 68 80
133	penelope.pires	mail	pires.pénélope@dbmail.com
134	penelope.pires	addr	15, avenue de Camus\n26484 Delahaye-sur-Mer
135	penelope.pires	tel	+33 (0)5 16 96 90 07
136	toussaint.emmanuelle8	mail	toussaint.emmanuelle@ifrance.com
137	toussaint.emmanuelle8	addr	24, chemin de Morin\n23438 Saint Thérèse
138	toussaint.emmanuelle8	tel	+33 4 34 29 83 20
139	zacharie.leduc	mail	leduc.zacharie@free.fr
140	zacharie.leduc	addr	605, boulevard Rocher\n52268 Dupont-la-Forêt
141	zacharie.leduc	tel	03 22 57 54 92
142	gerard.laurent	mail	laurent.gérard@live.com
143	gerard.laurent	addr	741, rue de Hardy\n84209 Valette
144	gerard.laurent	tel	05 19 47 04 50
145	hoarau_maggie	mail	hoarau.maggie@sfr.fr
146	hoarau_maggie	addr	442, avenue Vallet\n64313 Renault
147	hoarau_maggie	tel	+33 5 94 31 57 20
148	leduci	mail	leduc.isaac@noos.fr
149	leduci	addr	952, chemin Leleu\n97282 Martel-sur-Albert
150	leduci	tel	0322366920
\.


--
-- Data for Name: cotisation_inscription; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.cotisation_inscription (idpaiement, mode_paiement, montant, date, num) FROM stdin;
\.


--
-- Data for Name: etre_vivant; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.etre_vivant (idespece, taille, couleur) FROM stdin;
\.


--
-- Data for Name: habitat; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.habitat (idhabitat, nomhabitat) FROM stdin;
1	Jardin des Dames de la foi 28
2	Jardin des Dames de la foi 71
3	Jardin des Dames de la foi 122
4	Parc Bordelais S Lisière
5	Parc des Berges de Garonne D 76
6	Jardin Public JB A 8 Jardin Botanique
7	Jardin Public U 1 Espaces Centraux
8	Jardin Public G 16 Espaces Centraux
9	Parc Bordelais Abris Uu Lac
10	Parc Monséjour 11
11	Parc des Berges de Queyries Quai de Queyries_B 112
12	Jardin Public F 6 Aire de jeux-Entrée
13	Parc Bordelais L 16 Chênaie
14	Parc Denis et Eugène Bühler A 92
15	Jardin Public O12 Espaces Centraux
16	Parc Bordelais H 24 Lisière
17	Parc Bordelais G 21 Espaces centraux
18	Parc Bordelais G 3 Espaces centraux
19	Parc Bordelais F 89 Espaces centraux
20	Parc Bordelais Cc 48 Espaces centraux
21	Parc Bordelais N 7 Chênaie
22	Parc Bordelais Ee 50 Espaces centraux
23	Jardin Public JB L 10 Jardin Botanique
24	Parc Bordelais Qr 50 Espaces centraux
25	Parc Bordelais Qr 44 Espaces centraux
26	Parc Bordelais G 36 Espaces centraux
27	Parc Bordelais Cc 40 Espaces centraux
28	Parc Bordelais F 68 Espaces centraux
29	Parc Bordelais Cc 30 Espaces centraux
30	Jardin Public M 10 Aire de jeux-Ile aux enfants
31	Parc des Berges de Garonne E 75
32	Parc Floral J 213
33	Parc Rivière Ruines Espaces centraux
34	Parc Bordelais F 53 Espaces centraux
35	Parc Bordelais Abris Uu Lac
36	Parc Bordelais Abris O Chênaie
37	Jardin Public H 12 Espaces Centraux
38	Jardin Public O 20 Espaces Centraux
39	Jardin Public C 14 Espaces Centraux
40	Jardin Public J 1 Espaces Centraux
41	Parc Bordelais Abris Cc Espaces centraux
42	Parc des Berges de Queyries Quai de Queyries_B 117
43	Parc des Berges de Queyries Quai de Queyries_B 123
44	Parc des Berges de Queyries Quai de Queyries_B 131
45	Parc Bordelais Abris H Lisière
46	Parc Bordelais Local Aa Prévention routière
47	Parc Denis et Eugène Bühler A 235
48	Parc Bordelais Jj 65 Lisière
49	Parc Bordelais E 48 Lisière
50	Jardin de la Béchade A 58
51	Parc Denis et Eugène Bühler A 241
52	Parc Denis et Eugène Bühler A 208
53	Parc Bordelais L 39 Chênaie
54	Parc des Berges de Garonne C 45
55	Parc Denis et Eugène Bühler A 209
56	Parc des Berges de Queyries 46
57	Parc Bordelais M 13 Chênaie
58	Parc Bordelais J 31 Chênaie
59	Parc Rivière 55 Lisière
60	Parc Rivière Ruines Espaces centraux
61	Parc des Berges de Queyries 36
62	Parc des Berges de Garonne C 68
63	Parc des Berges de Garonne D 69
64	Parc Monséjour 141
65	Jardin Brascassat 97
66	Jardin Brascassat 51
67	Parc Bordelais K 43 Chênaie
68	Parc Rivière 101 Lisière
69	Parc Rivière 36 Lisière
\.


--
-- Data for Name: info_habitat; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.info_habitat (idinfohab, habitat, type_info, information, auteur) FROM stdin;
1	1	statut_nichoir	\N	\N
2	1	coord	44.82496498108209, -0.5826971070140672	\N
3	2	statut_nichoir	\N	\N
4	2	coord	44.82485279489022, -0.5818885174108315	\N
5	3	statut_nichoir	\N	\N
6	3	coord	44.824891136246066, -0.5824360699076871	\N
7	4	statut_nichoir	\N	\N
8	4	coord	44.85437462387557, -0.5992931749468693	\N
9	5	statut_nichoir	\N	\N
10	5	coord	44.88620214688763, -0.5389649262306322	\N
11	6	statut_nichoir	\N	\N
12	6	coord	44.84970556350323, -0.5793624952694811	\N
13	7	statut_nichoir	\N	\N
14	7	coord	44.85011631934097, -0.5807548938900732	\N
15	8	statut_nichoir	\N	\N
16	8	coord	44.84869748818537, -0.578055339140325	\N
17	9	statut_nichoir	\N	\N
18	9	coord	44.854524018887595, -0.6040382342703873	\N
19	10	statut_nichoir	\N	\N
20	10	coord	44.854020094577976, -0.6305164392434941	\N
21	11	statut_nichoir	\N	\N
22	11	coord	44.84773397455367, -0.56429699156094	\N
23	12	statut_nichoir	\N	\N
24	12	coord	44.84812735314189, -0.5794281579325548	\N
25	13	statut_nichoir	\N	\N
26	13	coord	44.85431464806744, -0.6005003906828041	\N
27	14	statut_nichoir	\N	\N
28	14	coord	44.877460414808546, -0.5738700897295438	\N
29	15	statut_nichoir	\N	\N
30	15	coord	44.84908891130452, -0.5761656362560668	\N
31	16	statut_nichoir	\N	\N
32	16	coord	44.85357336830592, -0.5990873344310302	\N
33	17	statut_nichoir	\N	\N
34	17	coord	44.85025338756352, -0.6013862383611732	\N
35	18	statut_nichoir	\N	\N
36	18	coord	44.85062039296851, -0.6013744869802635	\N
37	19	statut_nichoir	\N	\N
38	19	coord	44.85138361432764, -0.601082566778306	\N
39	20	statut_nichoir	\N	\N
40	20	coord	44.851499123708486, -0.6025678989717217	\N
41	21	statut_nichoir	\N	\N
42	21	coord	44.854542409974805, -0.6009378727201115	\N
43	22	statut_nichoir	\N	\N
44	22	coord	44.85148851648768, -0.603955941005387	\N
45	23	statut_nichoir	\N	\N
46	23	coord	44.849455382741574, -0.5802913651476924	\N
47	24	statut_nichoir	\N	\N
48	24	coord	44.8546844587685, -0.6021682378071974	\N
49	25	statut_nichoir	\N	\N
50	25	coord	44.85426481716422, -0.6028071239454721	\N
51	26	statut_nichoir	\N	\N
52	26	coord	44.85042269722834, -0.6016381904128913	\N
53	27	statut_nichoir	\N	\N
54	27	coord	44.85195380044732, -0.6028287186437341	\N
55	28	statut_nichoir	\N	\N
56	28	coord	44.85129561025599, -0.6011706493958795	\N
57	29	statut_nichoir	\N	\N
58	29	coord	44.85192224342198, -0.6030117632955405	\N
59	30	statut_nichoir	\N	\N
60	30	coord	44.84922483635055, -0.57757625540709	\N
61	31	statut_nichoir	\N	\N
62	31	coord	44.88838774398652, -0.5403845572969557	\N
63	32	statut_nichoir	\N	\N
64	32	coord	44.90296309191505, -0.5617190594207219	\N
65	33	statut_nichoir	\N	\N
66	33	coord	44.85502234040775, -0.5869487128570092	\N
67	34	statut_nichoir	\N	\N
68	34	coord	44.85158271455911, -0.6009652111461246	\N
69	35	statut_nichoir	\N	\N
70	35	coord	44.85444128568523, -0.6041105633664147	\N
71	36	statut_nichoir	\N	\N
72	36	coord	44.855204365696046, -0.6016202114903123	\N
73	37	statut_nichoir	\N	\N
74	37	coord	44.84776632397309, -0.5778174352081112	\N
75	38	statut_nichoir	\N	\N
76	38	coord	44.84943364515927, -0.576679000308578	\N
77	39	statut_nichoir	\N	\N
78	39	coord	44.84926256982205, -0.5783388899031706	\N
79	40	statut_nichoir	\N	\N
80	40	coord	44.84778404265502, -0.5769957105953939	\N
81	41	statut_nichoir	\N	\N
82	41	coord	44.85286611600725, -0.6029009823624192	\N
83	42	statut_nichoir	\N	\N
84	42	coord	44.84724337597214, -0.5646256183127872	\N
85	43	statut_nichoir	\N	\N
86	43	coord	44.84678921774554, -0.5648606400339379	\N
87	44	statut_nichoir	\N	\N
88	44	coord	44.846196805841096, -0.5649799786218507	\N
89	45	statut_nichoir	\N	\N
90	45	coord	44.853367775519956, -0.5995012684580048	\N
91	46	statut_nichoir	\N	\N
92	46	coord	44.853235068773984, -0.6053741903519265	\N
93	47	statut_nichoir	\N	\N
94	47	coord	44.8756623460351, -0.5729994877474872	\N
95	48	statut_nichoir	\N	\N
96	48	coord	44.850951423847924, -0.6037005955076891	\N
97	49	statut_nichoir	\N	\N
98	49	coord	44.85080982160368, -0.6007541652675605	\N
99	50	statut_nichoir	\N	\N
100	50	coord	44.82637719802458, -0.5977932768642812	\N
101	51	statut_nichoir	\N	\N
102	51	coord	44.8755383552407, -0.5723489776390355	\N
103	52	statut_nichoir	\N	\N
104	52	coord	44.875710009225465, -0.5726057839100591	\N
105	53	statut_nichoir	\N	\N
106	53	coord	44.85441900484589, -0.6000404859210429	\N
107	54	statut_nichoir	\N	\N
108	54	coord	44.885200876798976, -0.5395636424873069	\N
109	55	statut_nichoir	\N	\N
110	55	coord	44.87567279386167, -0.5725401304542169	\N
111	56	statut_nichoir	\N	\N
112	56	coord	44.84460265421007, -0.5648649909799104	\N
113	57	statut_nichoir	\N	\N
114	57	coord	44.85466473505142, -0.6004994797813077	\N
115	58	statut_nichoir	\N	\N
116	58	coord	44.85312721937915, -0.6013451951087808	\N
117	59	statut_nichoir	\N	\N
118	59	coord	44.85555208008678, -0.5879329364317152	\N
119	60	statut_nichoir	\N	\N
120	60	coord	44.85503594043426, -0.5869344891986072	\N
121	61	statut_nichoir	\N	\N
122	61	coord	44.84531507419438, -0.5650268357337032	\N
123	62	statut_nichoir	\N	\N
124	62	coord	44.884893980268004, -0.5391026938999953	\N
125	63	statut_nichoir	\N	\N
126	63	coord	44.88659660938745, -0.5389733381231006	\N
127	64	statut_nichoir	\N	\N
128	64	coord	44.854325590789394, -0.6319898404692035	\N
129	65	statut_nichoir	\N	\N
130	65	coord	44.81505883200218, -0.5536959471422863	\N
131	66	statut_nichoir	\N	\N
132	66	coord	44.81531471018188, -0.5543142500453607	\N
133	67	statut_nichoir	\N	\N
134	67	coord	44.853069394644216, -0.6005105633612647	\N
135	68	statut_nichoir	\N	\N
136	68	coord	44.85452836721848, -0.5877280844252866	\N
137	69	statut_nichoir	\N	\N
138	69	coord	44.85586353494476, -0.5865050297385617	\N
\.


--
-- Data for Name: inscription; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.inscription (num, idsortie) FROM stdin;
\.


--
-- Data for Name: observe; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.observe (num, idespece, lieu, date, remarques, img) FROM stdin;
\.


--
-- Data for Name: profil; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.profil (idprofil, prenom, nom, pw_hash) FROM stdin;
pruvost.francoise31	Pruvost	Françoise	$2b$12$DisK5ytZZjejjgCN96p5q.M6wbuEzQdHD2viICFRWsSbhPduvAX4y
virginie.alexandre	Alexandre	Virginie	$2b$12$xvxVeSpVlayz6QW16s3zROd6eHhOvF0Oj1hgxUOiAn0uZuv.foTfq
g_bertrand	Georges	Bertrand	$2b$12$J6Lb160VcrsxcROdwImcHup46OrGk5jwA3RlduCAaVeHnuLVf9eHq
adele.costa	Costa	Adèle	$2b$12$Up1hB4Ep9mL6NyRfrVti7Ozn9QQyr2LSV.Goqnv5OcK2POIw5dlwO
b_agathe	Bailly	Agathe	$2b$12$B7MgvIEKCSB9N6sPJAj6feDjo15Q8hMo4lQFBkQ3N63k16HoJx9Te
guillou_laure	Guillou	Laure	$2b$12$a1OQvEQM0fxkXjNnyYpYWeF0N191vMWueZcUWDA3jJjjfHuF7pGR6
oceane.masse	Masse	Océane	$2b$12$kbbDc1ZLTbwSENkDKstoPe8EQl6ciY/d8angOuwLNjVWslabxg2eO
raynaud.antoinette10	Raynaud	Antoinette	$2b$12$GCDR7QSpX0VCfTo20LK0DeKHzRbbGwEW6BzjKhExx7uXlZ5iSiSJO
legendre.penelope73	Legendre	Pénélope	$2b$12$uAYgkIQcL.gNEp3qR.yoE.Ldi8dksalF3Rqh/zheSfA2ZLS36a2w6
albert.etienne65	Albert	Étienne	$2b$12$RDwJNjJguk7n/FGjvtTLvO11aqyjJo2ZK9MTTrna0OFI.tSBmcNR6
gomez_jean	Gomez	Jean	$2b$12$EcFRnE8NwCOODG2gavdy7OKyDeMyPsC03vE1I.BcibBtms/Y1XUdu
daniel.nicolas	Nicolas	Daniel	$2b$12$riuPa7qCWf/1UnB71NGJBuJdO2X04w6VxelhlcY/X3gxSSisZD7v.
zacharie.thierry	Thierry	Zacharie	$2b$12$wVo8aV2FGW5QZemQeBR19erKcphuJOhEsMXVw0mAaA3uuyNYgTsp6
suzanne.ferrand	Ferrand	Suzanne	$2b$12$MWLyBcbkMEElgBZuxTEy1O/OgiCVF9qaWccDXzY6BP00HkUaOFERS
thierry.bazin	Bazin	Thierry	$2b$12$SdjEoVCbZLb2/Q8o00l7yOxhgsbVpC3hbh5Q6VENwJmzopnBb1nEO
legalln	Le Gall	Nicole	$2b$12$UTeZPVeCD9UN20CumtyrM.Y7LexszN02AorI0tkl2hFuwlYvmOzUa
emilie.delannoy	Delannoy	Émilie	$2b$12$MMuw.62daWeTgRPpmzAVAeMhfk0s/qEUp/6ngNVyxOxDEj4990/nG
carre.stephane46	Carre	Stéphane	$2b$12$Zlf27bXguBn.uzVPOq8ScuuFM8H/XAmpWkwbWKghJ74WxOoVRL952
b_suzanne	Blot	Suzanne	$2b$12$aWX3fbF715SFoEeMKxmQLuvMzhfb0s/k2OJc9TjvZb8Yi4m0KSx3.
delahaye_remy	Delahaye	Rémy	$2b$12$SGAuBkhJGZO3qmyIeXKQqeJr26KV4xLE/y2K/VV.VpDWccyiK6rjm
b_dominique	Blanchet	Dominique	$2b$12$EKx.OfXLwxQOZ.wuJkJ8yuAPxUgFuqs/nX5CLtlmGt6cTijqVsbfe
f_maurice	Fabre	Maurice	$2b$12$xL8xcoOwExX/KSmsAucKouAu2rSpnrwRy8A73/RReF8GNtJChyz1m
lefort.lucie58	Lefort	Lucie	$2b$12$Bd.Umq0vh3JOHcDFFkzVf.wt9dsq1Skm53v2XhVdLYaf2pk4lROFe
gimenez_robert	Gimenez	Robert	$2b$12$B.0ZCoI0kJIWVas62v2mpOuIuvsAVhzXCR/UZq982kgO1YKG9i7ma
leroux_eugene	Le Roux	Eugène	$2b$12$sOYE3F/G5qxwTEbWObQ3tuk7/1qt7jA7ihgqCW4d3rupJumwzjRfm
v_maggie	Voisin	Maggie	$2b$12$RXPSm9eOHAz2pxEGeOBpjuniV/OkCuGPNCkxZBRJE52HFx1rIwsLO
m_jeanne	Muller	Jeanne	$2b$12$V6Zk0uliRZb4aalwK.0yTud/o23zZsgwLtTcfwBBxwmfg7B7C5omi
daniel.peron	Peron	Daniel	$2b$12$7RndF73x3HV.YHA.87vJneQI6GrMPaZdEV9XG6GiWd6oHxwj5.pFW
gauthierg	Gauthier	Georges	$2b$12$z1AJAF8xKuGweJi0H.yGuuX68r1NSuMCVST1.8LYNV/W5L/gunPW.
bourgeoism	Bourgeois	Michelle	$2b$12$iDR.KCwBPksrXmBl8x/kG.VCcai/PDOmkBbsfTSxWl2g4X5n3olH6
marie.adrienne20	Marie	Adrienne	$2b$12$hAxaFf5cGDl7hLXdDQYzfe.u637NNPvd3A84T8Rm7O.QSJNec.uVm
lefebvre.daniel59	Lefebvre	Daniel	$2b$12$iSU26qd6VcwVYofbz6GSzOcNty6RimUJ3b6oLCpjlNbs87hEWXKdG
lebreton.diane94	Lebreton	Diane	$2b$12$R7n2w5E36A1whEfeLuQjP.4qB9GFcanogPyhMEQ7lHMXzQByodqj2
benoit_marianne	Benoit	Marianne	$2b$12$SNd4ZbL7hiYrK6I7OBCXVusbBBnsarNSZX0Oqc0qk9/sjq.nTF00m
l_maurice	Letellier	Maurice	$2b$12$gzbo7XQJbhmKV0CyFNFvaewRzxL2dcMnOPha59AkRk48b0S5BdjAa
bertin_marianne	Bertin	Marianne	$2b$12$uFqF.4.zS.DV/GjZy6w9UOpEMv9BWA.0j9DvuMoKeHaEpCEefJlyi
d_constance	Dos Santos	Constance	$2b$12$YowKH1pFIgfSE08rqw/Rfe7YiktF93gqFITPTAvrBIpQ.prv6n.US
godard_michelle	Godard	Michelle	$2b$12$G3rABmbhpYw/v4Mp.dySH.Llcz1uDKOkXutdGGOnu0vFtgH6FZ.mC
robinm	Robin	Martine	$2b$12$R6QewrtrFc3ZijZOxMg7.e6LlJDP9ZCM20MeyTc2GwM2S2IXUfyiS
paul.pereira	Pereira	Paul	$2b$12$goKXVCXOudeBBfCFgO18JuJit.lsvfLlwTKD01K10Z4VAG4nPmgvm
barbes	Barbe	Susan	$2b$12$hXc50hg9LLaT3DyBLcbW9uBTNQL5KfxY2URT2fDceAaHkRfl1yqva
pelletierl	Pelletier	Laetitia	$2b$12$1joULicV0w1vIUGgqQNEbeT0ExAu5dnuWFqeXMu7EmBzEFrGUYN3C
isaac.lemoine	Lemoine	Isaac	$2b$12$2GsPKcEPlUy7zeWaogC5iuEZw0j9Uw9lvUNbidtAVODWrWPMnaM42
thomaso	Thomas	Olivier	$2b$12$7EN32R0RHJXA78iWodFoQOYc95e4Tjt/Snu6rxltAgkg5zd/j.IAu
penelope.pires	Pires	Pénélope	$2b$12$6TzIfeCEQuGzUxHfoM2IF.lGr6Y/m8yTmHpcLlD3W3cZSG9KGoMcG
toussaint.emmanuelle8	Toussaint	Emmanuelle	$2b$12$lL1xctJtQdkL0yofYcC8KeCGoHJ2no5GG6N/QAnLphZ6eEGuJgbmC
zacharie.leduc	Leduc	Zacharie	$2b$12$9LtvhrE8vQvHhrQ9VRHaceFZSYPUI28EB72ihYI15XB/0f98Z49Ne
gerard.laurent	Laurent	Gérard	$2b$12$yQlEFBoMlPIGnmLtiDPtFuCgjzgeSb7hpQyFbIZUdHYGzMJeIdf4W
hoarau_maggie	Hoarau	Maggie	$2b$12$IvD9A8uZS9rLUb1FopCDIecsP4C2oTc9Z3ELJ54Cs/s3EVhAzd4E2
leduci	Leduc	Isaac	$2b$12$4gBo5BA9mmgB4/ijOTY4A.oYpb9tr0a9SCY6gA6sCUEKyZ.QdTGeS
\.


--
-- Data for Name: renseigne; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.renseigne (idprofil, idatt, date, commit_msg) FROM stdin;
\.


--
-- Data for Name: sortie; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.sortie (idsortie, nom, theme, lieu, date_rdv, distance_km, effectif_max, descriptif) FROM stdin;
\.


--
-- Data for Name: specialise; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.specialise (num, libelle) FROM stdin;
\.


--
-- Data for Name: statut; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.statut (idstatut, libelle_statut) FROM stdin;
1	Étudiant
2	Personnel universitaire
3	Externe
4	Bénévole
\.


--
-- Name: adherent_num_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.adherent_num_seq', 47, true);


--
-- Name: attribut_idatt_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.attribut_idatt_seq', 1, false);


--
-- Name: coordonnees_idcoord_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.coordonnees_idcoord_seq', 150, true);


--
-- Name: cotisation_inscription_idpaiement_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.cotisation_inscription_idpaiement_seq', 1, false);


--
-- Name: habitat_idhabitat_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.habitat_idhabitat_seq', 69, true);


--
-- Name: info_habitat_idinfohab_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.info_habitat_idinfohab_seq', 138, true);


--
-- Name: sortie_idsortie_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.sortie_idsortie_seq', 1, false);


--
-- Name: adherent adherent_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.adherent
    ADD CONSTRAINT adherent_pkey PRIMARY KEY (num);


--
-- Name: attribut attribut_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.attribut
    ADD CONSTRAINT attribut_pkey PRIMARY KEY (idatt);


--
-- Name: coordonnees coordonnees_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.coordonnees
    ADD CONSTRAINT coordonnees_pkey PRIMARY KEY (idcoord);


--
-- Name: cotisation_inscription cotisation_inscription_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.cotisation_inscription
    ADD CONSTRAINT cotisation_inscription_pkey PRIMARY KEY (idpaiement);


--
-- Name: etre_vivant etre_vivant_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.etre_vivant
    ADD CONSTRAINT etre_vivant_pkey PRIMARY KEY (idespece);


--
-- Name: habitat habitat_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.habitat
    ADD CONSTRAINT habitat_pkey PRIMARY KEY (idhabitat);


--
-- Name: info_habitat info_habitat_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.info_habitat
    ADD CONSTRAINT info_habitat_pkey PRIMARY KEY (idinfohab);


--
-- Name: observe observe_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.observe
    ADD CONSTRAINT observe_pkey PRIMARY KEY (num, idespece, lieu);


--
-- Name: renseigne pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.renseigne
    ADD CONSTRAINT pkey PRIMARY KEY (idprofil, idatt);


--
-- Name: anime pkey_couple; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.anime
    ADD CONSTRAINT pkey_couple PRIMARY KEY (idprofile, idsortie);


--
-- Name: inscription pkey_ins; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.inscription
    ADD CONSTRAINT pkey_ins PRIMARY KEY (num, idsortie);


--
-- Name: specialise pkey_spe; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.specialise
    ADD CONSTRAINT pkey_spe PRIMARY KEY (num, libelle);


--
-- Name: profil profil_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.profil
    ADD CONSTRAINT profil_pkey PRIMARY KEY (idprofil);


--
-- Name: sortie sortie_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.sortie
    ADD CONSTRAINT sortie_pkey PRIMARY KEY (idsortie);


--
-- Name: statut statut_pkey; Type: CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.statut
    ADD CONSTRAINT statut_pkey PRIMARY KEY (idstatut);


--
-- Name: adherent adherent_idprofil_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.adherent
    ADD CONSTRAINT adherent_idprofil_fkey FOREIGN KEY (idprofil) REFERENCES public.profil(idprofil);


--
-- Name: adherent adherent_statut_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.adherent
    ADD CONSTRAINT adherent_statut_fkey FOREIGN KEY (statut) REFERENCES public.statut(idstatut);


--
-- Name: anime anime_idprofile_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.anime
    ADD CONSTRAINT anime_idprofile_fkey FOREIGN KEY (idprofile) REFERENCES public.profil(idprofil);


--
-- Name: anime anime_idsortie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.anime
    ADD CONSTRAINT anime_idsortie_fkey FOREIGN KEY (idsortie) REFERENCES public.sortie(idsortie);


--
-- Name: attribut attribut_idespece_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.attribut
    ADD CONSTRAINT attribut_idespece_fkey FOREIGN KEY (idespece) REFERENCES public.etre_vivant(idespece);


--
-- Name: coordonnees coordonnees_profil_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.coordonnees
    ADD CONSTRAINT coordonnees_profil_fkey FOREIGN KEY (profil) REFERENCES public.profil(idprofil);


--
-- Name: cotisation_inscription cotisation_inscription_num_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.cotisation_inscription
    ADD CONSTRAINT cotisation_inscription_num_fkey FOREIGN KEY (num) REFERENCES public.adherent(num);


--
-- Name: info_habitat info_habitat_auteur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.info_habitat
    ADD CONSTRAINT info_habitat_auteur_fkey FOREIGN KEY (auteur) REFERENCES public.profil(idprofil);


--
-- Name: info_habitat info_habitat_habitat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.info_habitat
    ADD CONSTRAINT info_habitat_habitat_fkey FOREIGN KEY (habitat) REFERENCES public.habitat(idhabitat);


--
-- Name: inscription inscription_idsortie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.inscription
    ADD CONSTRAINT inscription_idsortie_fkey FOREIGN KEY (idsortie) REFERENCES public.sortie(idsortie);


--
-- Name: inscription inscription_num_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.inscription
    ADD CONSTRAINT inscription_num_fkey FOREIGN KEY (num) REFERENCES public.adherent(num);


--
-- Name: observe observe_idespece_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.observe
    ADD CONSTRAINT observe_idespece_fkey FOREIGN KEY (idespece) REFERENCES public.etre_vivant(idespece);


--
-- Name: observe observe_lieu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.observe
    ADD CONSTRAINT observe_lieu_fkey FOREIGN KEY (lieu) REFERENCES public.habitat(idhabitat);


--
-- Name: observe observe_num_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.observe
    ADD CONSTRAINT observe_num_fkey FOREIGN KEY (num) REFERENCES public.adherent(num);


--
-- Name: renseigne renseigne_idatt_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.renseigne
    ADD CONSTRAINT renseigne_idatt_fkey FOREIGN KEY (idatt) REFERENCES public.attribut(idatt);


--
-- Name: renseigne renseigne_idprofil_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.renseigne
    ADD CONSTRAINT renseigne_idprofil_fkey FOREIGN KEY (idprofil) REFERENCES public.profil(idprofil);


--
-- Name: sortie sortie_lieu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.sortie
    ADD CONSTRAINT sortie_lieu_fkey FOREIGN KEY (lieu) REFERENCES public.habitat(idhabitat);


--
-- Name: specialise specialise_num_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.specialise
    ADD CONSTRAINT specialise_num_fkey FOREIGN KEY (num) REFERENCES public.adherent(num);


--
-- PostgreSQL database dump complete
--

