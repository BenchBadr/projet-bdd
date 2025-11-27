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
    coords character varying(150),
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
1	p_francoise	2	0
2	alexandre.virginie53	2	0
3	g_bertrand	2	0
4	costa.adele41	2	0
5	bailly.agathe13	1	0
6	laure.guillou	2	0
7	masse.oceane75	1	0
8	raynaud_antoinette	2	0
9	l_penelope	1	0
10	albert.etienne65	2	0
11	g_jean	1	0
12	nicolas.daniel75	2	0
13	thierryz	1	0
14	suzanne.ferrand	2	0
15	nicole.legall	1	0
16	d_emilie	1	0
17	blots	1	0
18	delahaye_remy	1	0
19	blanchet.dominique40	2	0
20	fabre_maurice	2	0
21	lefort_lucie	2	0
22	robert.gimenez	1	0
23	leroux_eugene	1	0
24	voisin_maggie	1	0
25	muller.jeanne82	2	0
26	peron_daniel	1	0
27	gauthier_georges	1	0
28	b_michelle	1	0
29	mariea	1	0
30	lefebvred	2	0
31	letellier_maurice	2	0
32	bertin_marianne	1	0
33	dossantos.constance64	1	0
34	godard.michelle55	2	0
35	martine.robin	1	0
36	p_paul	2	0
37	susan.barbe	1	0
38	laetitia.pelletier	2	0
39	l_isaac	2	0
40	t_olivier	1	0
41	penelope.pires	1	0
42	t_emmanuelle	2	0
43	leduc_zacharie	2	0
44	gerard.laurent	1	0
45	hoarau_maggie	1	0
46	isaac.leduc	2	0
47	collet_camille	1	0
48	danielm	1	0
49	j_michelle	2	0
50	lopes_leon	1	0
51	letellier_victor	2	0
52	dossantosl	2	0
53	guibertl	2	0
54	pelletier_zoe	2	0
55	leclerc.brigitte55	1	0
56	salmonc	1	0
57	marie_gilles	1	0
58	chauveta	1	0
59	lambert_thibault	2	0
60	leroux_chantal	1	0
61	christophe.monnier	1	0
62	pascald	1	0
63	nath.pruvost	1	0
64	e_maggie	1	0
65	g_catherine	1	0
66	f_paul	1	0
67	penelope.prevost	2	0
68	noel.fouquet	1	0
69	alphonse.leroux	2	0
70	robin_robert	1	0
71	b_laurence	2	0
72	huberto	1	0
73	hoarau.philippe35	1	0
74	guyot_cecile	1	0
75	p_cecile	1	0
76	astrid.guichard	2	0
77	h_denis	1	0
78	h_louis	1	0
79	claire.guerin	2	0
80	petitjeanc	1	0
81	adele.allard	2	0
82	dorothee.benard	1	0
83	boulaya	2	0
84	v_richard	1	0
85	rocher_catherine	2	0
86	allaind	2	0
87	l_elise	2	0
88	d_matthieu	2	0
89	tessier.martin15	2	0
90	andre.francois	2	0
91	denis.lefevre	2	0
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
1	p_francoise	mail	pruvost.françoise@ifrance.com
2	p_francoise	addr	11, boulevard Mahe\n30781 Fernandes
3	p_francoise	tel	+33 (0)1 80 35 98 86
4	alexandre.virginie53	mail	alexandre.virginie@tele2.fr
5	alexandre.virginie53	addr	50, chemin Vallée\n77932 Bertrand
6	alexandre.virginie53	tel	+33 7 69 44 52 76
7	g_bertrand	mail	georges.bertrand@tele2.fr
8	g_bertrand	addr	40, chemin Wagner\n48396 Coulon
9	g_bertrand	tel	02 79 50 44 27
10	costa.adele41	mail	costa.adèle@voila.fr
11	costa.adele41	addr	avenue Guérin\n03396 Robert
12	costa.adele41	tel	0366442701
13	bailly.agathe13	mail	bailly.agathe@tele2.fr
14	bailly.agathe13	addr	18, avenue Bonnin\n34394 Lopez
15	bailly.agathe13	tel	+33 (0)2 23 47 40 46
16	laure.guillou	mail	guillou.laure@gmail.com
17	laure.guillou	addr	37, boulevard Besson\n29906 Gauthier
18	laure.guillou	tel	+33 (0)4 15 43 15 64
19	masse.oceane75	mail	masse.océane@orange.fr
20	masse.oceane75	addr	7, rue de Cousin\n51266 Giraud-sur-Mer
21	masse.oceane75	tel	+33 (0)2 79 51 74 80
22	raynaud_antoinette	mail	raynaud.antoinette@dbmail.com
23	raynaud_antoinette	addr	69, avenue de Richard\n09330 Delaunay
24	raynaud_antoinette	tel	05 49 07 11 59
25	l_penelope	mail	legendre.pénélope@orange.fr
26	l_penelope	addr	227, boulevard Barthelemy\n91411 Pons-sur-Mer
27	l_penelope	tel	04 38 17 42 26
28	albert.etienne65	mail	albert.étienne@wanadoo.fr
29	albert.etienne65	addr	77, rue Becker\n63345 HardyBourg
30	albert.etienne65	tel	+33 3 70 03 43 20
31	g_jean	mail	gomez.jean@gmail.com
32	g_jean	addr	75, rue Théodore Normand\n66532 Gimenez
33	g_jean	tel	+33 4 49 83 88 30
34	nicolas.daniel75	mail	nicolas.daniel@free.fr
35	nicolas.daniel75	addr	chemin Pires\n01180 Sainte LéonBourg
36	nicolas.daniel75	tel	01 79 36 49 03
37	thierryz	mail	thierry.zacharie@tele2.fr
38	thierryz	addr	73, rue Guillaume\n44183 Evrard
39	thierryz	tel	0241433563
40	suzanne.ferrand	mail	ferrand.suzanne@laposte.net
41	suzanne.ferrand	addr	62, rue Stéphanie Delorme\n81930 Regnier
42	suzanne.ferrand	tel	0443465762
43	bazin_thierry	mail	bazin.thierry@free.fr
44	bazin_thierry	addr	43, rue Élise Renaud\n74102 Allain
45	bazin_thierry	tel	+33 3 10 88 13 00
46	nicole.legall	mail	le gall.nicole@noos.fr
47	nicole.legall	addr	chemin de Vaillant\n03216 Robin-sur-Langlois
48	nicole.legall	tel	06 75 85 05 90
49	d_emilie	mail	delannoy.émilie@yahoo.fr
50	d_emilie	addr	6, rue Moreau\n08855 Lebrun
51	d_emilie	tel	0772919444
52	carres	mail	carre.stéphane@voila.fr
53	carres	addr	389, rue Schneider\n67232 Sainte Chantal
54	carres	tel	01 69 70 05 64
55	blots	mail	blot.suzanne@tiscali.fr
56	blots	addr	11, chemin Charles Carlier\n40849 Saint Luc
57	blots	tel	+33 (0)5 17 74 75 77
58	delahaye_remy	mail	delahaye.rémy@hotmail.fr
59	delahaye_remy	addr	32, rue Richard\n41334 Vaillant
60	delahaye_remy	tel	+33 2 77 46 09 80
61	blanchet.dominique40	mail	blanchet.dominique@tiscali.fr
62	blanchet.dominique40	addr	12, avenue Margaret Weiss\n09961 Hamonnec
63	blanchet.dominique40	tel	+33 (0)5 57 06 13 36
64	fabre_maurice	mail	fabre.maurice@tiscali.fr
65	fabre_maurice	addr	11, chemin de Lelièvre\n41301 Saint Arthur-la-Forêt
66	fabre_maurice	tel	+33 2 34 84 15 78
67	lefort_lucie	mail	lefort.lucie@tele2.fr
68	lefort_lucie	addr	23, rue de Techer\n10578 Hardy
69	lefort_lucie	tel	+33 (0)2 50 41 21 36
70	robert.gimenez	mail	gimenez.robert@sfr.fr
71	robert.gimenez	addr	735, rue Agathe Dos Santos\n38193 Hebert
72	robert.gimenez	tel	+33 4 81 81 39 13
73	leroux_eugene	mail	le roux.eugène@club-internet.fr
74	leroux_eugene	addr	35, rue Hugues Le Roux\n30521 Mercierboeuf
75	leroux_eugene	tel	+33 4 74 59 71 19
76	voisin_maggie	mail	voisin.maggie@club-internet.fr
77	voisin_maggie	addr	10, rue de Lombard\n79302 Charlesdan
78	voisin_maggie	tel	03 64 27 07 67
79	muller.jeanne82	mail	muller.jeanne@bouygtel.fr
80	muller.jeanne82	addr	314, rue Rousset\n29283 Saint Élise
81	muller.jeanne82	tel	04 73 13 99 18
82	peron_daniel	mail	peron.daniel@ifrance.com
83	peron_daniel	addr	31, rue Tristan Leclercq\n87250 Guyon-sur-Becker
84	peron_daniel	tel	+33 5 79 83 74 70
85	gauthier_georges	mail	gauthier.georges@club-internet.fr
86	gauthier_georges	addr	chemin de Lecoq\n74980 Lemonnierboeuf
87	gauthier_georges	tel	+33 (0)5 24 97 51 81
88	b_michelle	mail	bourgeois.michelle@voila.fr
89	b_michelle	addr	39, chemin de Delannoy\n82576 Fournier-sur-Pelletier
90	b_michelle	tel	02 40 41 25 66
91	mariea	mail	marie.adrienne@dbmail.com
92	mariea	addr	94, chemin Margaud Chevallier\n90786 Garnier
93	mariea	tel	0144440954
94	lefebvred	mail	lefebvre.daniel@bouygtel.fr
95	lefebvred	addr	977, rue de Carpentier\n75486 Bodin
96	lefebvred	tel	+33 6 95 43 93 48
97	l_diane	mail	lebreton.diane@noos.fr
98	l_diane	addr	85, boulevard de Bourdon\n07534 Rémy-sur-Martinez
99	l_diane	tel	+33 4 85 54 42 22
100	benoit.marianne97	mail	benoit.marianne@orange.fr
101	benoit.marianne97	addr	35, rue Lacroix\n57597 Vidal
102	benoit.marianne97	tel	0379543882
103	letellier_maurice	mail	letellier.maurice@wanadoo.fr
104	letellier_maurice	addr	55, avenue de Masse\n97344 BoyerBourg
105	letellier_maurice	tel	0516811082
106	bertin_marianne	mail	bertin.marianne@yahoo.fr
107	bertin_marianne	addr	8, rue Rolland\n25381 Legrand
108	bertin_marianne	tel	+33 2 23 53 95 53
109	dossantos.constance64	mail	dos santos.constance@laposte.net
110	dossantos.constance64	addr	3, rue Georges Maury\n51363 Gay
111	dossantos.constance64	tel	+33 (0)4 77 11 75 84
112	godard.michelle55	mail	godard.michelle@orange.fr
113	godard.michelle55	addr	boulevard Martin Le Roux\n55296 Saint Philippe-les-Bains
114	godard.michelle55	tel	+33 2 33 41 87 75
115	martine.robin	mail	robin.martine@live.com
116	martine.robin	addr	92, avenue Legros\n16805 Sainte Timothée
117	martine.robin	tel	+33 (0)4 98 47 68 52
118	p_paul	mail	pereira.paul@tiscali.fr
119	p_paul	addr	392, rue Lopez\n59845 Moulin
120	p_paul	tel	+33 (0)4 73 99 22 67
121	susan.barbe	mail	barbe.susan@gmail.com
122	susan.barbe	addr	boulevard Stéphanie Vaillant\n52914 PerretBourg
123	susan.barbe	tel	+33 (0)4 15 72 17 39
124	laetitia.pelletier	mail	pelletier.laetitia@voila.fr
125	laetitia.pelletier	addr	avenue Émile Boulay\n40789 Weiss-sur-Loiseau
126	laetitia.pelletier	tel	+33 2 28 39 72 07
127	l_isaac	mail	lemoine.isaac@tele2.fr
128	l_isaac	addr	980, chemin Corinne Delmas\n04119 Descamps-sur-Rossi
129	l_isaac	tel	+33 4 79 42 53 25
130	t_olivier	mail	thomas.olivier@voila.fr
131	t_olivier	addr	17, chemin Zoé Techer\n20495 Perrin-les-Bains
132	t_olivier	tel	+33 (0)1 60 23 68 80
133	penelope.pires	mail	pires.pénélope@dbmail.com
134	penelope.pires	addr	15, avenue de Camus\n26484 Delahaye-sur-Mer
135	penelope.pires	tel	+33 (0)5 16 96 90 07
136	t_emmanuelle	mail	toussaint.emmanuelle@ifrance.com
137	t_emmanuelle	addr	24, chemin de Morin\n23438 Saint Thérèse
138	t_emmanuelle	tel	+33 4 34 29 83 20
139	leduc_zacharie	mail	leduc.zacharie@free.fr
140	leduc_zacharie	addr	605, boulevard Rocher\n52268 Dupont-la-Forêt
141	leduc_zacharie	tel	03 22 57 54 92
142	gerard.laurent	mail	laurent.gérard@live.com
143	gerard.laurent	addr	741, rue de Hardy\n84209 Valette
144	gerard.laurent	tel	05 19 47 04 50
145	hoarau_maggie	mail	hoarau.maggie@sfr.fr
146	hoarau_maggie	addr	442, avenue Vallet\n64313 Renault
147	hoarau_maggie	tel	+33 5 94 31 57 20
148	isaac.leduc	mail	leduc.isaac@noos.fr
149	isaac.leduc	addr	952, chemin Leleu\n97282 Martel-sur-Albert
150	isaac.leduc	tel	0322366920
151	collet_camille	mail	collet.camille@tele2.fr
152	collet_camille	addr	80, rue Mathieu\n63880 François
153	collet_camille	tel	01 58 74 82 15
154	danielm	mail	daniel.marguerite@sfr.fr
155	danielm	addr	124, chemin Thierry Vallet\n66444 Collet-la-Forêt
156	danielm	tel	0579169951
157	j_michelle	mail	joly.michelle@yahoo.fr
158	j_michelle	addr	22, boulevard Dufour\n56724 Collet
159	j_michelle	tel	+33 1 55 22 72 22
160	lopes_leon	mail	lopes.léon@free.fr
161	lopes_leon	addr	37, boulevard Dubois\n66435 Mallet
162	lopes_leon	tel	02 76 05 50 36
163	letellier_victor	mail	letellier.victor@wanadoo.fr
164	letellier_victor	addr	396, chemin Margot Imbert\n97143 Dos Santos
165	letellier_victor	tel	+33 (0)5 17 32 90 74
166	faure.marcelle7	mail	faure.marcelle@hotmail.fr
167	faure.marcelle7	addr	78, avenue Anaïs Ferrand\n07802 Thierry-sur-Barre
168	faure.marcelle7	tel	04 30 14 21 79
169	dossantosl	mail	dos santos.laurent@voila.fr
170	dossantosl	addr	94, rue Pinto\n10795 Pasquierboeuf
171	dossantosl	tel	04 99 49 78 41
172	philippep	mail	philippe.paulette@hotmail.fr
173	philippep	addr	rue Louis Lombard\n10268 DevauxBourg
174	philippep	tel	03 63 53 04 52
175	guibertl	mail	guibert.léon@yahoo.fr
176	guibertl	addr	515, boulevard Hortense Robin\n07295 Baron
177	guibertl	tel	+33 4 37 28 10 28
178	pelletier_zoe	mail	pelletier.zoé@voila.fr
179	pelletier_zoe	addr	16, boulevard Michelle Grenier\n07988 Sainte Maryse
180	pelletier_zoe	tel	05 47 46 58 42
181	leclerc.brigitte55	mail	leclerc.brigitte@tiscali.fr
182	leclerc.brigitte55	addr	57, boulevard de Moreno\n53441 Petitjeanboeuf
183	leclerc.brigitte55	tel	05 53 63 79 65
184	salmonc	mail	salmon.christine@free.fr
185	salmonc	addr	254, rue René Clément\n73835 Sainte Zoé-la-Forêt
186	salmonc	tel	0519754911
187	marie_gilles	mail	marie.gilles@gmail.com
188	marie_gilles	addr	rue Lefèvre\n18541 Lejeune
189	marie_gilles	tel	+33 (0)1 44 14 17 73
190	chauveta	mail	chauvet.adrienne@sfr.fr
191	chauveta	addr	91, rue Seguin\n16152 Duhamel
192	chauveta	tel	05 08 51 30 64
193	lambert_thibault	mail	lambert.thibault@laposte.net
194	lambert_thibault	addr	boulevard Gimenez\n69414 Noël
195	lambert_thibault	tel	+33 (0)2 32 59 63 95
196	leroux_chantal	mail	le roux.chantal@laposte.net
197	leroux_chantal	addr	2, chemin de Laurent\n81606 Le Goff
198	leroux_chantal	tel	0482774047
199	hoareau_celina	mail	hoareau.célina@ifrance.com
200	hoareau_celina	addr	23, boulevard Emmanuel Gimenez\n88175 Antoine
201	hoareau_celina	tel	+33 5 90 44 33 17
202	christophe.monnier	mail	monnier.christophe@hotmail.fr
203	christophe.monnier	addr	42, rue de Germain\n82802 Laroche
204	christophe.monnier	tel	+33 (0)2 79 74 77 43
205	pascald	mail	pascal.denis@hotmail.fr
206	pascald	addr	157, avenue Clerc\n26350 Payet
207	pascald	tel	0277503470
208	nath.pruvost	mail	pruvost.nath@noos.fr
209	nath.pruvost	addr	82, rue Élisabeth Lejeune\n62296 Humbertboeuf
210	nath.pruvost	tel	+33 5 56 88 53 54
211	e_maggie	mail	étienne.maggie@wanadoo.fr
212	e_maggie	addr	11, rue de Besnard\n11647 Rossi
213	e_maggie	tel	0479381816
214	g_catherine	mail	guyon.catherine@hotmail.fr
215	g_catherine	addr	11, boulevard Bertrand\n50544 Saint Jeanne
216	g_catherine	tel	04 65 71 04 51
217	f_paul	mail	fischer.paul@voila.fr
218	f_paul	addr	39, rue Renard\n97476 DupuisVille
219	f_paul	tel	+33 (0)4 15 90 20 56
220	penelope.prevost	mail	prévost.pénélope@tiscali.fr
221	penelope.prevost	addr	55, avenue Lucy Muller\n43256 MilletBourg
222	penelope.prevost	tel	+33 (0)5 86 28 47 28
223	noel.fouquet	mail	fouquet.noël@voila.fr
224	noel.fouquet	addr	34, avenue Michelle Lamy\n39474 Hoaraudan
225	noel.fouquet	tel	+33 (0)2 23 93 48 03
226	alphonse.leroux	mail	leroux.alphonse@tele2.fr
227	alphonse.leroux	addr	avenue Geneviève Moreau\n36416 Schmitt-sur-Costa
228	alphonse.leroux	tel	+33 (0)3 23 68 27 15
229	robin_robert	mail	robin.robert@gmail.com
230	robin_robert	addr	42, avenue de Fournier\n34215 Martineaunec
231	robin_robert	tel	04 15 46 90 17
232	b_laurence	mail	benard.laurence@dbmail.com
233	b_laurence	addr	21, rue Gosselin\n66124 Marion-les-Bains
234	b_laurence	tel	+33 3 76 86 14 80
235	huberto	mail	hubert.océane@noos.fr
236	huberto	addr	rue Dupuis\n55628 Brun
237	huberto	tel	03 29 84 89 67
238	hoarau.philippe35	mail	hoarau.philippe@bouygtel.fr
239	hoarau.philippe35	addr	3, avenue Gaudin\n89718 Monnier-les-Bains
240	hoarau.philippe35	tel	0385472483
241	guyot_cecile	mail	guyot.cécile@ifrance.com
242	guyot_cecile	addr	29, rue Étienne Vasseur\n61615 Sainte Adèle-les-Bains
243	guyot_cecile	tel	0498456795
244	p_cecile	mail	parent.cécile@noos.fr
245	p_cecile	addr	56, rue Moreau\n89502 Saint Laetitia-les-Bains
246	p_cecile	tel	+33 (0)7 70 81 08 34
247	astrid.guichard	mail	guichard.astrid@tele2.fr
248	astrid.guichard	addr	52, rue de Barbier\n66711 Sainte Anaïs-la-Forêt
249	astrid.guichard	tel	0556621030
250	h_denis	mail	hebert.denis@bouygtel.fr
251	h_denis	addr	47, avenue Meunier\n97227 Lebon
252	h_denis	tel	0495717461
253	jerome.gauthier	mail	gauthier.jérôme@dbmail.com
254	jerome.gauthier	addr	85, rue de Lopez\n65945 Salmon
255	jerome.gauthier	tel	+33 (0)3 87 19 12 75
256	h_louis	mail	huet.louis@wanadoo.fr
257	h_louis	addr	719, rue de Rolland\n40579 Barbier-la-Forêt
258	h_louis	tel	0140814282
259	claire.guerin	mail	guérin.claire@gmail.com
260	claire.guerin	addr	rue Laure Clerc\n06597 Renaud
261	claire.guerin	tel	0449788233
262	petitjeanc	mail	petitjean.catherine@free.fr
263	petitjeanc	addr	296, avenue de Camus\n34496 Leblanc-sur-Neveu
264	petitjeanc	tel	0486169340
265	adele.allard	mail	allard.adèle@laposte.net
266	adele.allard	addr	27, avenue Lopez\n92281 Navarro-la-Forêt
267	adele.allard	tel	02 52 57 40 16
268	daniela	mail	daniel.alphonse@ifrance.com
269	daniela	addr	rue Jean\n42163 Weber
270	daniela	tel	0231898502
271	dorothee.benard	mail	benard.dorothée@free.fr
272	dorothee.benard	addr	rue Lebon\n44214 Muller
273	dorothee.benard	tel	04 98 82 75 54
274	boulaya	mail	boulay.andrée@yahoo.fr
275	boulaya	addr	69, boulevard Albert\n13520 Lemonnier-sur-Prévost
276	boulaya	tel	+33 (0)2 62 98 88 77
277	v_richard	mail	vaillant.richard@wanadoo.fr
278	v_richard	addr	17, boulevard Brunet\n71397 Brun-sur-Pons
279	v_richard	tel	+33 (0)1 83 43 79 71
280	rocher_catherine	mail	rocher.catherine@tiscali.fr
281	rocher_catherine	addr	7, chemin Devaux\n40278 Martins-sur-Joseph
282	rocher_catherine	tel	+33 6 38 83 10 99
283	allaind	mail	allain.david@laposte.net
284	allaind	addr	avenue Monique Fernandes\n05453 LemaîtreBourg
285	allaind	tel	02 53 22 75 85
286	l_elise	mail	launay.élise@hotmail.fr
287	l_elise	addr	76, rue Alphonse Moreno\n91289 Lesage-sur-Guillot
288	l_elise	tel	0178419446
289	d_matthieu	mail	dupuis.matthieu@club-internet.fr
290	d_matthieu	addr	955, avenue Élisabeth Lemoine\n72751 Girard
291	d_matthieu	tel	+33 8 01 66 68 44
292	tessier.martin15	mail	tessier.martin@bouygtel.fr
293	tessier.martin15	addr	88, avenue de Camus\n57773 Giraudboeuf
294	tessier.martin15	tel	0376014816
295	andre.francois	mail	françois.andré@live.com
296	andre.francois	addr	18, avenue Merle\n44828 Petitjean
297	andre.francois	tel	02 57 19 91 28
298	denis.lefevre	mail	lefèvre.denis@hotmail.fr
299	denis.lefevre	addr	13, chemin Inès Ramos\n08170 Jean-sur-Le Gall
300	denis.lefevre	tel	02 54 54 87 83
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

COPY public.habitat (idhabitat, nomhabitat, coords) FROM stdin;
1	Jardin des Dames de la foi 28	44.82496498108209, -0.5826971070140672
2	Jardin des Dames de la foi 71	44.82485279489022, -0.5818885174108315
3	Jardin des Dames de la foi 122	44.824891136246066, -0.5824360699076871
4	Parc Bordelais S Lisière	44.85437462387557, -0.5992931749468693
5	Parc des Berges de Garonne D 76	44.88620214688763, -0.5389649262306322
6	Jardin Public JB A 8 Jardin Botanique	44.84970556350323, -0.5793624952694811
7	Jardin Public U 1 Espaces Centraux	44.85011631934097, -0.5807548938900732
8	Jardin Public G 16 Espaces Centraux	44.84869748818537, -0.578055339140325
9	Parc Bordelais Abris Uu Lac	44.854524018887595, -0.6040382342703873
10	Parc Monséjour 11	44.854020094577976, -0.6305164392434941
11	Parc des Berges de Queyries Quai de Queyries_B 112	44.84773397455367, -0.56429699156094
12	Jardin Public F 6 Aire de jeux-Entrée	44.84812735314189, -0.5794281579325548
13	Parc Bordelais L 16 Chênaie	44.85431464806744, -0.6005003906828041
14	Parc Denis et Eugène Bühler A 92	44.877460414808546, -0.5738700897295438
15	Jardin Public O12 Espaces Centraux	44.84908891130452, -0.5761656362560668
16	Parc Bordelais H 24 Lisière	44.85357336830592, -0.5990873344310302
17	Parc Bordelais G 21 Espaces centraux	44.85025338756352, -0.6013862383611732
18	Parc Bordelais G 3 Espaces centraux	44.85062039296851, -0.6013744869802635
19	Parc Bordelais F 89 Espaces centraux	44.85138361432764, -0.601082566778306
20	Parc Bordelais Cc 48 Espaces centraux	44.851499123708486, -0.6025678989717217
21	Parc Bordelais N 7 Chênaie	44.854542409974805, -0.6009378727201115
22	Parc Bordelais Ee 50 Espaces centraux	44.85148851648768, -0.603955941005387
23	Jardin Public JB L 10 Jardin Botanique	44.849455382741574, -0.5802913651476924
24	Parc Bordelais Qr 50 Espaces centraux	44.8546844587685, -0.6021682378071974
25	Parc Bordelais Qr 44 Espaces centraux	44.85426481716422, -0.6028071239454721
26	Parc Bordelais G 36 Espaces centraux	44.85042269722834, -0.6016381904128913
27	Parc Bordelais Cc 40 Espaces centraux	44.85195380044732, -0.6028287186437341
28	Parc Bordelais F 68 Espaces centraux	44.85129561025599, -0.6011706493958795
29	Parc Bordelais Cc 30 Espaces centraux	44.85192224342198, -0.6030117632955405
30	Jardin Public M 10 Aire de jeux-Ile aux enfants	44.84922483635055, -0.57757625540709
31	Parc des Berges de Garonne E 75	44.88838774398652, -0.5403845572969557
32	Parc Floral J 213	44.90296309191505, -0.5617190594207219
33	Parc Rivière Ruines Espaces centraux	44.85502234040775, -0.5869487128570092
34	Parc Bordelais F 53 Espaces centraux	44.85158271455911, -0.6009652111461246
35	Parc Bordelais Abris Uu Lac	44.85444128568523, -0.6041105633664147
36	Parc Bordelais Abris O Chênaie	44.855204365696046, -0.6016202114903123
37	Jardin Public H 12 Espaces Centraux	44.84776632397309, -0.5778174352081112
38	Jardin Public O 20 Espaces Centraux	44.84943364515927, -0.576679000308578
39	Jardin Public C 14 Espaces Centraux	44.84926256982205, -0.5783388899031706
40	Jardin Public J 1 Espaces Centraux	44.84778404265502, -0.5769957105953939
41	Parc Bordelais Abris Cc Espaces centraux	44.85286611600725, -0.6029009823624192
42	Parc des Berges de Queyries Quai de Queyries_B 117	44.84724337597214, -0.5646256183127872
43	Parc des Berges de Queyries Quai de Queyries_B 123	44.84678921774554, -0.5648606400339379
44	Parc des Berges de Queyries Quai de Queyries_B 131	44.846196805841096, -0.5649799786218507
45	Parc Bordelais Abris H Lisière	44.853367775519956, -0.5995012684580048
46	Parc Bordelais Local Aa Prévention routière	44.853235068773984, -0.6053741903519265
47	Parc Denis et Eugène Bühler A 235	44.8756623460351, -0.5729994877474872
48	Parc Bordelais Jj 65 Lisière	44.850951423847924, -0.6037005955076891
49	Parc Bordelais E 48 Lisière	44.85080982160368, -0.6007541652675605
50	Jardin de la Béchade A 58	44.82637719802458, -0.5977932768642812
51	Parc Denis et Eugène Bühler A 241	44.8755383552407, -0.5723489776390355
52	Parc Denis et Eugène Bühler A 208	44.875710009225465, -0.5726057839100591
53	Parc Bordelais L 39 Chênaie	44.85441900484589, -0.6000404859210429
54	Parc des Berges de Garonne C 45	44.885200876798976, -0.5395636424873069
55	Parc Denis et Eugène Bühler A 209	44.87567279386167, -0.5725401304542169
56	Parc des Berges de Queyries 46	44.84460265421007, -0.5648649909799104
57	Parc Bordelais M 13 Chênaie	44.85466473505142, -0.6004994797813077
58	Parc Bordelais J 31 Chênaie	44.85312721937915, -0.6013451951087808
59	Parc Rivière 55 Lisière	44.85555208008678, -0.5879329364317152
60	Parc Rivière Ruines Espaces centraux	44.85503594043426, -0.5869344891986072
61	Parc des Berges de Queyries 36	44.84531507419438, -0.5650268357337032
62	Parc des Berges de Garonne C 68	44.884893980268004, -0.5391026938999953
63	Parc des Berges de Garonne D 69	44.88659660938745, -0.5389733381231006
64	Parc Monséjour 141	44.854325590789394, -0.6319898404692035
65	Jardin Brascassat 97	44.81505883200218, -0.5536959471422863
66	Jardin Brascassat 51	44.81531471018188, -0.5543142500453607
67	Parc Bordelais K 43 Chênaie	44.853069394644216, -0.6005105633612647
68	Parc Rivière 101 Lisière	44.85452836721848, -0.5877280844252866
69	Parc Rivière 36 Lisière	44.85586353494476, -0.5865050297385617
70	Ru des Effaneaux et boisements associés	48.985353318969, 3.1250465897295245
71	VALLEE DE LA REMARDE DE SONCHAMPS A SAINT ARNOULT	48.5745183314506, 2.1215265492478967
72	VALLEE DE LA SEINE ENTRE VERNOU ET MONTREAU	48.37453202699681, 2.8878963608305477
73	FORET DE MONTMORENCY	49.02999725231412, 2.279553400306025
74	VALLEE DE LA THEVE ET DE L'YSIEUX	49.11116749437064, 2.4366344889328815
75	VALLEE DE L'ORGE DE SAINT MESMES A BRETHENCOURT	48.51230293456798, 1.934884751083216
76	BOIS DE PORT VILLEZ ET JEUFOSSE	49.05348685261907, 1.51991509464614
77	FORET DE RAMBOUILLET SUD-EST	48.61846779298853, 1.9193065542651668
78	BOIS NOTRE DAME ET DE LA GRANGE	48.75033422113482, 2.567984308931633
79	Basse Vallée de l'Aubetin	48.75014124158929, 3.090064521673589
80	Bois de Saint-Laurent	49.09269028782041, 2.6269902184402936
81	BOIS DE SAINT MESMES	48.533825709932565, 1.9316665339568746
82	FORÊT DE MARLY	48.870711709708374, 2.046404290893421
83	FORET DE NANTEAU	48.24416024262292, 2.7638320113180033
84	BOIS DE DARVAULT	48.26782102256345, 2.754148566578573
85	Vallée de la Marne de Coupvray à Pomponne	48.91566157273562, 2.7448874349118673
86	Massif de Villefermoy	48.50218759388431, 2.939990013254975
87	Forêt de la Lechelle et de Coubert	48.71992818714446, 2.708261406684499
88	BUTTES DE L'ARTHIES	49.081133744799935, 1.782607212229259
89	FORÊT DE BEYNES	48.84895273516256, 1.855664991007909
90	VALLEE DE L'ESSONNE DE MALESHERBES A LA SEINE	48.434449374234426, 2.3817742861034934
91	Forêt de Sourdun	48.51943372392815, 3.3857841754378404
92	Bois de Valence et de Champagne	48.42014365526649, 2.8514141035529
93	BOCAGE A L'EST DE MITTAINVILLE	48.664847545489145, 1.6574796368583717
94	Bois de Bréviande	48.55433090489309, 2.6226210051408994
95	Bois et landes entre Seine-Port et Melun	48.5416879753325, 2.580892867037079
96	Foret domaniale de Jouy	48.630275383772236, 3.177650519765989
97	BASSE VALLEE DE L'YERRES	48.69626496870363, 2.515726315793143
98	Parc Départemental de la Courneuve	48.95336437106862, 2.403941229215414
99	BOIS DES HAUTES BRUYERES	48.75142236972382, 1.8970290660708926
100	BOIS D'ANGERVILLIERS	48.60141889959927, 2.048845631954925
101	FORET DE L'ISLE ADAM	49.09172354382995, 2.2535010952085797
102	BOIS DE LA TOUR DU LAY ET ABORDS	49.15059082264258, 2.1992318344891792
103	Forêts d'Armainvilliers et de Ferrières	48.79356366891438, 2.7159800272461645
104	VALLEE DE L'YVETTE AVAL	48.70238134166303, 2.143307279960388
105	FORET DE MEUDON ET BOIS DE CLAMART	48.79789894787575, 2.2004995881122102
106	Forêt de Barbeau et Bois de Saint-Denis	48.46876982955442, 2.7947719026998965
107	VALLEE DE LA JUINE AMONT ET SES AFFLUENTS	48.4170108201616, 2.0645579141969943
108	VALLEE DU LOING ENTRE MORET SUR LOING ET EPISY	48.35760812477122, 2.8124022725449658
109	BUTTES SUD DU VEXIN FRANCAIS	49.02126434968567, 1.8045272673222914
110	MOYENNE VALLEE DE LA VIOSNE	49.12846165964008, 1.9448607931656046
111	BOIS DES VAUX DE LA SALLE	49.119951319580224, 1.7717076115829118
112	Basse vallée du Bréon	48.67508028563354, 2.8363718970634273
113	Forêt domaniale de Montceaux	48.96827227418159, 2.982158055016544
114	FORET DE RAMBOUILLET NORD-OUEST	48.71238590114823, 1.7524066849513895
115	BOIS DE LA CARRELETTE	49.165468720691095, 1.8334462021535956
116	Le Bois Cadine	48.986505275514794, 3.1583180183930692
117	Bois Saint-Martin et bois de Célie	48.826863470220594, 2.598273510201342
118	BOIS DE SAINTE APPOLINE	48.80696342165956, 1.9293418511990124
119	VALLEE DE L'ORVANNE ENTRE VILLECERF ET FLAGY	48.31926738654628, 2.8874463150394214
120	L'Yerres de la source à Chaume-en-Brie	48.70769954381229, 2.953292065924592
121	Forêt de Rougeau	48.58445733620906, 2.5282931556409514
122	PARC DE GRIGNON	48.84918992474803, 1.9324306710669013
123	VALLEE DE L'ORGE DE DOURDAN A LA SEINE	48.5804699639765, 2.1988561457452103
124	VALLEE DU LOING ENTRE NEMOURS ET SOUPPES SUR LOING	48.216661861968284, 2.7111504790692043
125	FORÊT DE SAINT GERMAIN EN LAYE	48.94220486597151, 2.0968875861782554
126	BOCAGE DE LA GRENOUILLERE	48.66095542293469, 1.6307459755338096
127	VALLEE DE LA RENARDE ET COTE DE TORFOU	48.521524890829646, 2.1522750971666635
128	MASSIF DE FONTAINEBLEAU	48.38913666782669, 2.64164804784755
129	Vallée de l'Ourcq	49.07277166745914, 3.0564787294545677
130	FORET DE CARNELLE	49.11932089000949, 2.3231583726523963
131	FORET DE SENART	48.66669267592317, 2.48186379349853
132	Buisson de Massoury	48.50604297197753, 2.7247780181149692
133	FORÊT DE ROSNY	48.994613642049366, 1.5824820249046037
134	VALLEE DU LUNAIN ENTRE EPISY ET LE LANDY	48.31432877096032, 2.7854784015833243
135	VALLEE DE LA MAULDRE ET AFFLUENTS	48.87806087039599, 1.8766231019369657
136	VALLEE DE L'EPTE	49.13840570606466, 1.658012717194278
137	VALLEE DE L'AULNE	48.603289928306125, 1.9978945984154357
138	FRICHE SUR L'ETANG	48.64443166525707, 1.9513648389652636
139	VALLEE DE SOUPPES SUR LOING ET DORDIVES	48.165201494060575, 2.7448887711371492
140	VALLEE DE LA JUINE D'ETAMPES A ITTEVILLE	48.48667340194683, 2.213156568270984
141	VALLEE DE LA VESGRE EN AVAL DE SAINT LEGER	48.7223273797087, 1.7122518752605536
142	Forêt de Crécy	48.78456486056953, 2.865430555116389
143	VALEE DU PETIT MORIN	48.9062983282448, 3.2009908873622877
144	BOUCLE DE GUERNES-MOISSON	49.04295639217995, 1.6631322548339187
145	VALLEE DE LA BIEVRE	48.755518580542635, 2.2222888758666466
146	BUTTE DE ROSNE	49.17957576870469, 2.0162763522633593
147	Forêt de Malvoisine	48.76589290414576, 2.9950717236317757
148	VAUX DE CERNAY	48.68894302587848, 1.922532861671835
\.


--
-- Data for Name: info_habitat; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.info_habitat (idinfohab, habitat, type_info, information, auteur) FROM stdin;
1	1	statut_nichoir	\N	\N
2	2	statut_nichoir	\N	\N
3	3	statut_nichoir	\N	\N
4	4	statut_nichoir	\N	\N
5	5	statut_nichoir	\N	\N
6	6	statut_nichoir	\N	\N
7	7	statut_nichoir	\N	\N
8	8	statut_nichoir	\N	\N
9	9	statut_nichoir	\N	\N
10	10	statut_nichoir	\N	\N
11	11	statut_nichoir	\N	\N
12	12	statut_nichoir	\N	\N
13	13	statut_nichoir	\N	\N
14	14	statut_nichoir	\N	\N
15	15	statut_nichoir	\N	\N
16	16	statut_nichoir	\N	\N
17	17	statut_nichoir	\N	\N
18	18	statut_nichoir	\N	\N
19	19	statut_nichoir	\N	\N
20	20	statut_nichoir	\N	\N
21	21	statut_nichoir	\N	\N
22	22	statut_nichoir	\N	\N
23	23	statut_nichoir	\N	\N
24	24	statut_nichoir	\N	\N
25	25	statut_nichoir	\N	\N
26	26	statut_nichoir	\N	\N
27	27	statut_nichoir	\N	\N
28	28	statut_nichoir	\N	\N
29	29	statut_nichoir	\N	\N
30	30	statut_nichoir	\N	\N
31	31	statut_nichoir	\N	\N
32	32	statut_nichoir	\N	\N
33	33	statut_nichoir	\N	\N
34	34	statut_nichoir	\N	\N
35	35	statut_nichoir	\N	\N
36	36	statut_nichoir	\N	\N
37	37	statut_nichoir	\N	\N
38	38	statut_nichoir	\N	\N
39	39	statut_nichoir	\N	\N
40	40	statut_nichoir	\N	\N
41	41	statut_nichoir	\N	\N
42	42	statut_nichoir	\N	\N
43	43	statut_nichoir	\N	\N
44	44	statut_nichoir	\N	\N
45	45	statut_nichoir	\N	\N
46	46	statut_nichoir	\N	\N
47	47	statut_nichoir	\N	\N
48	48	statut_nichoir	\N	\N
49	49	statut_nichoir	\N	\N
50	50	statut_nichoir	\N	\N
51	51	statut_nichoir	\N	\N
52	52	statut_nichoir	\N	\N
53	53	statut_nichoir	\N	\N
54	54	statut_nichoir	\N	\N
55	55	statut_nichoir	\N	\N
56	56	statut_nichoir	\N	\N
57	57	statut_nichoir	\N	\N
58	58	statut_nichoir	\N	\N
59	59	statut_nichoir	\N	\N
60	60	statut_nichoir	\N	\N
61	61	statut_nichoir	\N	\N
62	62	statut_nichoir	\N	\N
63	63	statut_nichoir	\N	\N
64	64	statut_nichoir	\N	\N
65	65	statut_nichoir	\N	\N
66	66	statut_nichoir	\N	\N
67	67	statut_nichoir	\N	\N
68	68	statut_nichoir	\N	\N
69	69	statut_nichoir	\N	\N
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
p_francoise	Pruvost	Françoise	$2b$12$Uz5odDNQqH81s4iGWGfkB.AsdUToq4LYHzCxwAYIXNvKdWmu9vJLu
alexandre.virginie53	Alexandre	Virginie	$2b$12$2rKu9dnIQ7hQDdHfmAiUB.gmd9e5l2fTEr8HIvs5g5K7AArOP4W8.
g_bertrand	Georges	Bertrand	$2b$12$EYB/o.I4jnLymEWZQk/AH.29WHWcJ0fc3TB/AfGo4aoFYoG/Bm8u2
costa.adele41	Costa	Adèle	$2b$12$Bd4tpVUFiAAPCzvWJ5nsQONIwuZghLvL9F8FMAlfli9NF5QZCehVO
bailly.agathe13	Bailly	Agathe	$2b$12$5EV7esZiLeBYcghqU8EEduai3wq4Xcm3LfcwEYYCRYOTIkoUiYK9W
laure.guillou	Guillou	Laure	$2b$12$wVKVErIgc8sifL2aMEvJQutfHzJ7dW.t1znpTlkXgaMuBT0PGlke.
masse.oceane75	Masse	Océane	$2b$12$14wB707EKGtY/SCrqRBzzu5/MOWlXlXYqaPsD2gxbb0/oJdDascW.
raynaud_antoinette	Raynaud	Antoinette	$2b$12$f.gs.6JwVriDaOBC/IT.a.EcAB5X/xvOerGBl/CHs9eau/9mMkwp.
l_penelope	Legendre	Pénélope	$2b$12$psTAayhYc5dyA3IhkJefVuxWUuaqn3vrE0v.eHVyFtUAHj62o/82S
albert.etienne65	Albert	Étienne	$2b$12$UIp70E851EE4QeuzNoSNIe9VVOIH7NICgPVwX0zj2vuegxrztOzma
g_jean	Gomez	Jean	$2b$12$5y9tt9DAe0d.o49x6J6sfOzS4c4Tqm/LWZcQZ4zUvWyokzpAHCQUu
nicolas.daniel75	Nicolas	Daniel	$2b$12$/13ytE2leXRRCIO3S7WoPOpV.FqkQqWy4FU3MlklsD/vifcx4p/tW
thierryz	Thierry	Zacharie	$2b$12$nN66vwEwh/..Y0EznqgSBumHQIBa4SLFqvCatSTAet1RvdBEWmJIK
suzanne.ferrand	Ferrand	Suzanne	$2b$12$xiM2P39rM4gnGJCOcZsgk.QpPughCosCLb.5lotgsM7l17kd8jGFu
bazin_thierry	Bazin	Thierry	$2b$12$R6ZF9BFy1PBe3RiHyTY1O.O/wd2O4c.fZsl2vUz/I.TeobOmerEWO
nicole.legall	Le Gall	Nicole	$2b$12$OvoHWaxeID0Kwo.9b.mwceOFUYJymls1zTFWFcHw2iJhZ/sGhRDvS
d_emilie	Delannoy	Émilie	$2b$12$O0fToqsGbFhC1WOrg38u3O3AwQDupr4wLwsjBw7.U2WueNgmP.17S
carres	Carre	Stéphane	$2b$12$iHAKT/JJFU5EPsah9c5PKefvBiR8qY13RmBSqyKoSi162D5YLbuzm
blots	Blot	Suzanne	$2b$12$Ce7b3RrfeIEeDzk0MvQXoOOXYH7/n8JL5Wbx92ZskTuW0h1VuwhNS
delahaye_remy	Delahaye	Rémy	$2b$12$wkJNuYWj50vpEHTB6ebo1.f/q.y4OpGiN3qFTX3RG4Xo0rgBIWG1e
blanchet.dominique40	Blanchet	Dominique	$2b$12$3bt66u.7TduS3AO.phjr3.1EYxW2Ir.NwatdOuaQi0mJel1uxuEUm
fabre_maurice	Fabre	Maurice	$2b$12$/qa8OXTwPYsHDcnYFoStaO0f5A2IQIMvsQT8e/qAZ5rayuGuXMOvS
lefort_lucie	Lefort	Lucie	$2b$12$57UTLhJYDgsJXmMu9CQk7uULdCqoQtspSun5x6Zxf/vQcHSKx7fxu
robert.gimenez	Gimenez	Robert	$2b$12$hfbA/0GqKcUlrXrAOjdyRuR.pkQ56Rd8UaujKUAYOvyU3RxeVrPNy
leroux_eugene	Le Roux	Eugène	$2b$12$4KPk1OhsT2haKaq.uQbtre7lpfIeitjbyTws5jeL1Fkasf6xq1j1W
voisin_maggie	Voisin	Maggie	$2b$12$KIfwlneRjGdQURRBkv2i7uzHn9Agg18e9BAhra6DPr0mt2oGVWfpW
muller.jeanne82	Muller	Jeanne	$2b$12$xb5uSYOefGfmbqlOAUlal.pN4mm92mJWxH4PjcVif.79Ch3r9OFr.
peron_daniel	Peron	Daniel	$2b$12$RovCsQTgtUbOMJ2AvfI.jO3rKbuYn2Ew5KM9fslrM.PRBTb2yAb8i
gauthier_georges	Gauthier	Georges	$2b$12$iesDOrclh3De/x8WrrCiy.6RB19fTgI/tuf4CjHKAJ5dO336K9b8S
b_michelle	Bourgeois	Michelle	$2b$12$z.iOIWTerO278YpAzAIYjuEPrZ1udU1IXm8QkMMSiVNbzaapEeUJ.
mariea	Marie	Adrienne	$2b$12$TSemMAwNmHmtzZjtCtNtkusxMCcWG.sUixnswtkuDpreMsxWzRUsG
lefebvred	Lefebvre	Daniel	$2b$12$sOkdNTagtJx09UdmY552MOZed576tvgDVhMzqoIjYZHUdTOpII4Iu
l_diane	Lebreton	Diane	$2b$12$COgNKNHI.RJC5eKHJfNvPujM.hzrg0mXY0FOM3MXLSQJ1JinGOh9q
benoit.marianne97	Benoit	Marianne	$2b$12$T1veSK0Fi4cK0x7NAR08peR4gsY8wJZXKEdlyx1SwwB1bHWMlG0.O
letellier_maurice	Letellier	Maurice	$2b$12$.OWaRRENF83/FRoJrLS9b.CDmcKDE0yHq33vF2nvXvyo1//s.fYPG
bertin_marianne	Bertin	Marianne	$2b$12$AG3VlJi4HYGNS.cAndMKRO8fA5HPiKQIx8EZnaNqeReQ7ccIw.k0K
dossantos.constance64	Dos Santos	Constance	$2b$12$Gw0owfimgwfkK7X7f74iLe5b2FitKslJXvCuw1PcOlEUQtqpji1ia
godard.michelle55	Godard	Michelle	$2b$12$Ud0aftm5gHK4uSa/q5.VwektmVsSVKP4ZiUAZyorK4kX9upBd80uu
martine.robin	Robin	Martine	$2b$12$4t2nrrU0yQ0sXs2TfD5OnufKx6faHaOmBYJktt0mcHHqTurteeqSG
p_paul	Pereira	Paul	$2b$12$J0eD7W5T9Ees5amgRT48NeYXCNf9iWgoVm15M2Nv1f8Kns8RJdgCq
susan.barbe	Barbe	Susan	$2b$12$ur4m4L3ZYoTQWBfDBJA4lOgqiPmjWq/5dPwp7.YEbe/nz7aMpCi9i
laetitia.pelletier	Pelletier	Laetitia	$2b$12$djtz7bw.CCYl2LB5c6wFluhIuhRw.9WNK7JubD1tEF7xCb1vV8zx2
l_isaac	Lemoine	Isaac	$2b$12$FJPMGduTqonHSgHdh4WMVeP1lx1q0U7SxxrTVvHFvkVYR22iCOkSy
t_olivier	Thomas	Olivier	$2b$12$Sp9Yledz715qw9ss0jSvPe2IxqKKOK4vgXmLFv.k7ZdNX8r88yQ9C
penelope.pires	Pires	Pénélope	$2b$12$1uPnw4y5p5mkClNVONPC6e5eY6IHWBnWDIyupNe1s2lbk3CVUCYRa
t_emmanuelle	Toussaint	Emmanuelle	$2b$12$Y7NoZYjnaoaUtZPO1nkpPuBT3WAorho5JsCXfL6CZvp2Y7gBAcZnm
leduc_zacharie	Leduc	Zacharie	$2b$12$HcIc54nIC6XiHSWhG833XeAU5FyxWIR3tikJ3Xoo67D1i3bruMa5C
gerard.laurent	Laurent	Gérard	$2b$12$Qgdaw/F1PUjNmro/.HOlzOOJQemFEweHdVuueNOhB/YqDvR4F2926
hoarau_maggie	Hoarau	Maggie	$2b$12$Y.Nh49S.5HIiQpmXpDZOh.N55gyjWoHE4.pLHANvw1XXdG/wNgta6
isaac.leduc	Leduc	Isaac	$2b$12$FAo40.7oOUFjId5DphpFFeJfOcq2Fz.h.iORNmvv64sdbjxzAttYi
collet_camille	Collet	Camille	$2b$12$x/MKKi4au4InwgdA6jSXVe1mRQ3z3XNes.DpOSFDDcKvWxkBHpciq
danielm	Daniel	Marguerite	$2b$12$0W1HJqJE/ATVqP2wmWYd1uP4FbcVNn43cCkNYvU//L2jD29vIIAXm
j_michelle	Joly	Michelle	$2b$12$PdaTPd4.jNOEihHU9DukEOZS7rW9Tgg1OuETMuE7.z.oOCVQUNala
lopes_leon	Lopes	Léon	$2b$12$3ZHOBi.2S0FfBWEAWm529Ocf.aYZ0/ILD4nK6jlzjEYk3khp1cDCW
letellier_victor	Letellier	Victor	$2b$12$ZBu5NMSD5Q6RejYU40M/KezZ9cM4Ezql6OT/QWU6e21IpZjW.pUv6
faure.marcelle7	Faure	Marcelle	$2b$12$TMfcc/upX3WdfWDwOrO0gO4tc9DojlahVdUUCUnC.zYjfFvdnxngq
dossantosl	Dos Santos	Laurent	$2b$12$M6BmnLklMPuJBy9FR7s/c.H17IA28xiIz2z0kYUTa5fpb1eTicL5a
philippep	Philippe	Paulette	$2b$12$29yInV5dxPHmrz4iC0b2d.89jXVrRbRf71NJckkxfH0pwU1ahLBYK
guibertl	Guibert	Léon	$2b$12$bb6KpZKvXKT72U9nvBc/Pu/nrAM7K4.Gm68wqzJ5HzkiP6mhVYNnG
pelletier_zoe	Pelletier	Zoé	$2b$12$J1F08KGAfHFMp3DcOGdy6e/8Se1feD2AY5C.MzKsTdEFtNs4cuH.K
leclerc.brigitte55	Leclerc	Brigitte	$2b$12$SRFMY0PWySZY3qZZZ10yTOC6Nu2s.S6Rs0sRVwMfIc6i.uBF.OWK6
salmonc	Salmon	Christine	$2b$12$VyS6huIi4HqzBs6dkpIe8eRARF6oNbmpQbLd5b2N/U7MmJo.RXsna
marie_gilles	Marie	Gilles	$2b$12$0F2GrVwcS1Q0MxKuygYhH.IwCOo9NbSMpwNQ9HnYjDYDadAajUzym
chauveta	Chauvet	Adrienne	$2b$12$Wh6BzkJ4k2/Uuqrt06iVTeKbqliP1uTWEJte4FuRYe.n2.jUg8Em.
lambert_thibault	Lambert	Thibault	$2b$12$4Wm/BGAEMrLZsntNql6WZeDVqVQwEEKukwgg.A9eIwHL1veKIKlau
leroux_chantal	Le Roux	Chantal	$2b$12$ET9uyVDWLD.7sxri18T6TebmCN3Xy5nXYKhqPf21aKqrzz7AWQ6Ii
hoareau_celina	Hoareau	Célina	$2b$12$rOhSy6SSB9fi9Ow1drgepOk/1TFbJ10NKWdBSuzaBWZ98anHHkw2.
christophe.monnier	Monnier	Christophe	$2b$12$JTxhHR9KIIo43pKwj/To3.O8sshOAG9JZQfagpQpGHOAU9uZzrVkm
pascald	Pascal	Denis	$2b$12$XOSNToNbkU8jMhoxPLTSG.rQc/3rQz8t2T694zyT6rmdh8tyj5KT2
nath.pruvost	Pruvost	Nath	$2b$12$FZkCrAMFc.2nI/jB2IkH0uIRwMz6BRlimZyGF8JjuIwDtlen7T2BS
e_maggie	Étienne	Maggie	$2b$12$vToqMPhm4v1pgkRP2x2jlOUutyNbUGg.HZeVOj4OlmLev.uUPGGRm
g_catherine	Guyon	Catherine	$2b$12$qBWH9anVZZIAlzs6PbTCFuyNO.ooL959C3ydkWd2SKrr7WPQez.eS
f_paul	Fischer	Paul	$2b$12$fQuxTVqZOMcdC2/j9f1l9OqnMAPA2Uq9Vwwtahfp6Syiffz7TFjty
penelope.prevost	Prévost	Pénélope	$2b$12$5UilQuN5.Z0HcxoVCySkWeV7fv1a0qQKZNbSnj9KJpltCUD7eh8rW
noel.fouquet	Fouquet	Noël	$2b$12$3fWN412kBAoOE/.ber6USenesPVyzdL/fHqWgkvWH0aJhwkaenZ/G
alphonse.leroux	Leroux	Alphonse	$2b$12$SGHYk5CLemuBTxyYIt5l6enfmgqeYtF58MggvwFwW5hiHZKbJ6rV.
robin_robert	Robin	Robert	$2b$12$nHODukYEheU8kL2HlMj7C.5mS5p3C6jan8yXgaVuWaspz.KePsXqG
b_laurence	Benard	Laurence	$2b$12$SXIU3zKTufZ4/gcJT.AqguOfmt8QxO2vg5Y0/XfKjV/r2MJvl2JRy
huberto	Hubert	Océane	$2b$12$9OavLj2M9tLDSySUlrzKh.AKqHDV65HiqaczBgLdVv51mLJjvgFhq
hoarau.philippe35	Hoarau	Philippe	$2b$12$LgzqlnPvTq.P/nOoRRxJoeO8J34FOS.caDSlbOZ.zAm272bLf5Wm6
guyot_cecile	Guyot	Cécile	$2b$12$ZdSHYo..Fdj0BXhR.1nVdudCW8gPD97XUf/bB0eQ3nErQAviw3Mb6
p_cecile	Parent	Cécile	$2b$12$G8H3gW0fl/WmpsiXMSNN2O/WKVdn3p.mTaFE.30pIjXchX/kI6lHa
astrid.guichard	Guichard	Astrid	$2b$12$Cf7oSwjvoXwFyj1EWTpmaeeBTyf5Rhh0KwUR111vwp.XPgdJBejPm
h_denis	Hebert	Denis	$2b$12$8Ltsb/eOiI6TJNHRY9Zr0eg6QfrG.3wprv17XmuEKvMNeNY95iwbK
jerome.gauthier	Gauthier	Jérôme	$2b$12$zcYg029FAW8sVKYTVjZEf.Ggnt7qAN1G0wqQSLLLfy.fl6UQVMAMa
h_louis	Huet	Louis	$2b$12$TtkKYdvEcPGUYN18o3xF4.1h655bGRHgmPsA6/A/prqAmtwUDrQy6
claire.guerin	Guérin	Claire	$2b$12$8CJsYTEWPzULI5llC8ZlMewVpeDTaKgbTjORRgriJz3GAcudiNRle
petitjeanc	Petitjean	Catherine	$2b$12$k0lGicozRUf55tqwty8P2.iSwHL93Ab1TbS7cxHdvDxNQsG320i8u
adele.allard	Allard	Adèle	$2b$12$4aVWv5fsMF.VB0K6DrQFS.Xs9UF3Mzmht.VMUYGbo/45ySI4waFNO
daniela	Daniel	Alphonse	$2b$12$DuUpdSVdB1u.E4wO7u4Jxeejt3noX57kw2YnwrRHlLNmxCQchytKm
dorothee.benard	Benard	Dorothée	$2b$12$Hkr6CRshWqMlHuFH1f.iz.FpQITqKCwlRw4jEApJAaVYk6/1wVrnu
boulaya	Boulay	Andrée	$2b$12$t9MOVRIuljDVTqJv0xK6HeD.qQp7vMb2eK1oLDxttmWiXFNy8Goca
v_richard	Vaillant	Richard	$2b$12$qqxBdAk1GqVYwdOYl5U8XeWGG106WaRmj7KorDNiJuYl15GLDT.BK
rocher_catherine	Rocher	Catherine	$2b$12$XKIbQ2jS8/l5niMQu9nh4O3M6WugSvkMUtZFrzHZkzMCEMR68xa/C
allaind	Allain	David	$2b$12$FOxlWU9fABonDygifYJo6usUOfeLQsEvugnkxOAt1e8d83hCR/rRy
l_elise	Launay	Élise	$2b$12$fQhBsxf/x7JVDiGroX.aF.EkAGco47ToGZqep0k8uiNqokAKwG9/2
d_matthieu	Dupuis	Matthieu	$2b$12$rM0LC/4rk0384UG.jrV.quNeN/5JJGCKrVKyGL02JCLdAJ0ZhRdjG
tessier.martin15	Tessier	Martin	$2b$12$QyPXhMq4qrmVvxmr4ayMZ.pk0yX1/x6LC3gQ7G8cgrXHo2Gw0tZ6C
andre.francois	François	André	$2b$12$19JBAr5ESCISHQB/oSy68OHvpJYuxe0rvmDXefYpthrZjPNRHEHLC
denis.lefevre	Lefèvre	Denis	$2b$12$ThSraJmJB/dtbxyycUwDoua.KZD8d2UcjPpVf/MpC/w9.V8w2d5pK
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

SELECT pg_catalog.setval('public.adherent_num_seq', 91, true);


--
-- Name: attribut_idatt_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.attribut_idatt_seq', 1, false);


--
-- Name: coordonnees_idcoord_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.coordonnees_idcoord_seq', 300, true);


--
-- Name: cotisation_inscription_idpaiement_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.cotisation_inscription_idpaiement_seq', 1, false);


--
-- Name: habitat_idhabitat_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.habitat_idhabitat_seq', 148, true);


--
-- Name: info_habitat_idinfohab_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.info_habitat_idinfohab_seq', 69, true);


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

