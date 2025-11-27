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
    type_att character varying(50),
    idespece character varying(100),
    auteur integer,
    contenu text
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
    nomespece character varying(100),
    taille double precision
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
1	francoise.pruvost	2	0
2	alexandrev	2	0
3	bertrand.georges	1	0
4	adele.costa	2	0
5	baillya	1	0
6	g_laure	1	0
7	m_oceane	2	0
8	r_antoinette	2	0
9	etienne.albert	2	0
10	gomez_jean	1	0
11	nicolas.daniel75	1	0
12	t_zacharie	1	0
13	ferrand_suzanne	1	0
14	legall_nicole	1	0
15	delannoy_emilie	2	0
16	c_stephane	1	0
17	b_suzanne	2	0
18	delahaye.remy43	2	0
19	blanchet_dominique	2	0
20	fabrem	2	0
21	l_lucie	1	0
22	g_robert	1	0
23	leroux_eugene	1	0
24	maggie.voisin	2	0
25	mullerj	2	0
26	perond	2	0
27	g_georges	1	0
28	b_michelle	1	0
29	m_adrienne	1	0
30	daniel.lefebvre	1	0
31	lebreton_diane	2	0
32	benoit_marianne	2	0
33	letellier.maurice5	2	0
34	bertinm	2	0
35	dossantosc	1	0
36	godardm	2	0
37	martine.robin	2	0
38	p_paul	1	0
39	barbes	2	0
40	pelletier.laetitia46	1	0
41	l_isaac	2	0
42	thomaso	1	0
43	pires.penelope44	1	0
44	toussaint_emmanuelle	2	0
45	leduc.zacharie57	1	0
46	gerard.laurent	1	0
47	hoarau.maggie50	1	0
48	danielm	1	0
49	lopes_leon	2	0
50	letellierv	2	0
51	marcelle.faure	1	0
52	dossantos.laurent56	1	0
53	philippe_paulette	2	0
54	guibertl	1	0
55	pelletier_zoe	2	0
56	leclerc_brigitte	2	0
57	salmon.christine7	1	0
58	marie_gilles	2	0
59	c_adrienne	1	0
60	lambert_thibault	1	0
61	chantal.leroux	2	0
62	hoareau_celina	2	0
63	monnier_christophe	1	0
64	p_denis	2	0
65	pruvostn	1	0
66	etienne.maggie59	1	0
67	guyon.catherine30	2	0
68	fischerp	2	0
69	penelope.prevost	2	0
70	fouquetn	1	0
71	leroux.alphonse1	1	0
72	robin.robert94	1	0
73	benard_laurence	1	0
74	hubert.oceane82	2	0
75	g_cecile	1	0
76	cecile.parent	2	0
77	hebert.denis10	1	0
78	gauthier.jerome93	2	0
79	huetl	2	0
80	guerin_claire	2	0
81	alphonse.daniel	2	0
82	benard_dorothee	2	0
83	boulay.andree13	2	0
84	v_richard	2	0
85	rocherc	2	0
86	david.allain	2	0
87	elise.launay	2	0
88	dupuism	2	0
89	tessier.martin15	2	0
90	f_andre	1	0
91	denis.lefevre	1	0
\.


--
-- Data for Name: anime; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.anime (idprofile, idsortie) FROM stdin;
\.


--
-- Data for Name: attribut; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.attribut (idatt, type_att, idespece, auteur, contenu) FROM stdin;
\.


--
-- Data for Name: coordonnees; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.coordonnees (idcoord, profil, type_coord, coordonnee) FROM stdin;
1	francoise.pruvost	mail	pruvost.françoise@ifrance.com
2	francoise.pruvost	addr	11, boulevard Mahe\n30781 Fernandes
3	francoise.pruvost	tel	+33 (0)1 80 35 98 86
4	alexandrev	mail	alexandre.virginie@tele2.fr
5	alexandrev	addr	50, chemin Vallée\n77932 Bertrand
6	alexandrev	tel	+33 7 69 44 52 76
7	bertrand.georges	mail	georges.bertrand@tele2.fr
8	bertrand.georges	addr	40, chemin Wagner\n48396 Coulon
9	bertrand.georges	tel	02 79 50 44 27
10	adele.costa	mail	costa.adèle@voila.fr
11	adele.costa	addr	avenue Guérin\n03396 Robert
12	adele.costa	tel	0366442701
13	baillya	mail	bailly.agathe@tele2.fr
14	baillya	addr	18, avenue Bonnin\n34394 Lopez
15	baillya	tel	+33 (0)2 23 47 40 46
16	g_laure	mail	guillou.laure@gmail.com
17	g_laure	addr	37, boulevard Besson\n29906 Gauthier
18	g_laure	tel	+33 (0)4 15 43 15 64
19	m_oceane	mail	masse.océane@orange.fr
20	m_oceane	addr	7, rue de Cousin\n51266 Giraud-sur-Mer
21	m_oceane	tel	+33 (0)2 79 51 74 80
22	r_antoinette	mail	raynaud.antoinette@dbmail.com
23	r_antoinette	addr	69, avenue de Richard\n09330 Delaunay
24	r_antoinette	tel	05 49 07 11 59
25	penelope.legendre	mail	legendre.pénélope@orange.fr
26	penelope.legendre	addr	227, boulevard Barthelemy\n91411 Pons-sur-Mer
27	penelope.legendre	tel	04 38 17 42 26
28	etienne.albert	mail	albert.étienne@wanadoo.fr
29	etienne.albert	addr	77, rue Becker\n63345 HardyBourg
30	etienne.albert	tel	+33 3 70 03 43 20
31	gomez_jean	mail	gomez.jean@gmail.com
32	gomez_jean	addr	75, rue Théodore Normand\n66532 Gimenez
33	gomez_jean	tel	+33 4 49 83 88 30
34	nicolas.daniel75	mail	nicolas.daniel@free.fr
35	nicolas.daniel75	addr	chemin Pires\n01180 Sainte LéonBourg
36	nicolas.daniel75	tel	01 79 36 49 03
37	t_zacharie	mail	thierry.zacharie@tele2.fr
38	t_zacharie	addr	73, rue Guillaume\n44183 Evrard
39	t_zacharie	tel	0241433563
40	ferrand_suzanne	mail	ferrand.suzanne@laposte.net
41	ferrand_suzanne	addr	62, rue Stéphanie Delorme\n81930 Regnier
42	ferrand_suzanne	tel	0443465762
43	b_thierry	mail	bazin.thierry@free.fr
44	b_thierry	addr	43, rue Élise Renaud\n74102 Allain
45	b_thierry	tel	+33 3 10 88 13 00
46	legall_nicole	mail	le gall.nicole@noos.fr
47	legall_nicole	addr	chemin de Vaillant\n03216 Robin-sur-Langlois
48	legall_nicole	tel	06 75 85 05 90
49	delannoy_emilie	mail	delannoy.émilie@yahoo.fr
50	delannoy_emilie	addr	6, rue Moreau\n08855 Lebrun
51	delannoy_emilie	tel	0772919444
52	c_stephane	mail	carre.stéphane@voila.fr
53	c_stephane	addr	389, rue Schneider\n67232 Sainte Chantal
54	c_stephane	tel	01 69 70 05 64
55	b_suzanne	mail	blot.suzanne@tiscali.fr
56	b_suzanne	addr	11, chemin Charles Carlier\n40849 Saint Luc
57	b_suzanne	tel	+33 (0)5 17 74 75 77
58	delahaye.remy43	mail	delahaye.rémy@hotmail.fr
59	delahaye.remy43	addr	32, rue Richard\n41334 Vaillant
60	delahaye.remy43	tel	+33 2 77 46 09 80
61	blanchet_dominique	mail	blanchet.dominique@tiscali.fr
62	blanchet_dominique	addr	12, avenue Margaret Weiss\n09961 Hamonnec
63	blanchet_dominique	tel	+33 (0)5 57 06 13 36
64	fabrem	mail	fabre.maurice@tiscali.fr
65	fabrem	addr	11, chemin de Lelièvre\n41301 Saint Arthur-la-Forêt
66	fabrem	tel	+33 2 34 84 15 78
67	l_lucie	mail	lefort.lucie@tele2.fr
68	l_lucie	addr	23, rue de Techer\n10578 Hardy
69	l_lucie	tel	+33 (0)2 50 41 21 36
70	g_robert	mail	gimenez.robert@sfr.fr
71	g_robert	addr	735, rue Agathe Dos Santos\n38193 Hebert
72	g_robert	tel	+33 4 81 81 39 13
73	leroux_eugene	mail	le roux.eugène@club-internet.fr
74	leroux_eugene	addr	35, rue Hugues Le Roux\n30521 Mercierboeuf
75	leroux_eugene	tel	+33 4 74 59 71 19
76	maggie.voisin	mail	voisin.maggie@club-internet.fr
77	maggie.voisin	addr	10, rue de Lombard\n79302 Charlesdan
78	maggie.voisin	tel	03 64 27 07 67
79	mullerj	mail	muller.jeanne@bouygtel.fr
80	mullerj	addr	314, rue Rousset\n29283 Saint Élise
81	mullerj	tel	04 73 13 99 18
82	perond	mail	peron.daniel@ifrance.com
83	perond	addr	31, rue Tristan Leclercq\n87250 Guyon-sur-Becker
84	perond	tel	+33 5 79 83 74 70
85	g_georges	mail	gauthier.georges@club-internet.fr
86	g_georges	addr	chemin de Lecoq\n74980 Lemonnierboeuf
87	g_georges	tel	+33 (0)5 24 97 51 81
88	b_michelle	mail	bourgeois.michelle@voila.fr
89	b_michelle	addr	39, chemin de Delannoy\n82576 Fournier-sur-Pelletier
90	b_michelle	tel	02 40 41 25 66
91	m_adrienne	mail	marie.adrienne@dbmail.com
92	m_adrienne	addr	94, chemin Margaud Chevallier\n90786 Garnier
93	m_adrienne	tel	0144440954
94	daniel.lefebvre	mail	lefebvre.daniel@bouygtel.fr
95	daniel.lefebvre	addr	977, rue de Carpentier\n75486 Bodin
96	daniel.lefebvre	tel	+33 6 95 43 93 48
97	lebreton_diane	mail	lebreton.diane@noos.fr
98	lebreton_diane	addr	85, boulevard de Bourdon\n07534 Rémy-sur-Martinez
99	lebreton_diane	tel	+33 4 85 54 42 22
100	benoit_marianne	mail	benoit.marianne@orange.fr
101	benoit_marianne	addr	35, rue Lacroix\n57597 Vidal
102	benoit_marianne	tel	0379543882
103	letellier.maurice5	mail	letellier.maurice@wanadoo.fr
104	letellier.maurice5	addr	55, avenue de Masse\n97344 BoyerBourg
105	letellier.maurice5	tel	0516811082
106	bertinm	mail	bertin.marianne@yahoo.fr
107	bertinm	addr	8, rue Rolland\n25381 Legrand
108	bertinm	tel	+33 2 23 53 95 53
109	dossantosc	mail	dos santos.constance@laposte.net
110	dossantosc	addr	3, rue Georges Maury\n51363 Gay
111	dossantosc	tel	+33 (0)4 77 11 75 84
112	godardm	mail	godard.michelle@orange.fr
113	godardm	addr	boulevard Martin Le Roux\n55296 Saint Philippe-les-Bains
114	godardm	tel	+33 2 33 41 87 75
115	martine.robin	mail	robin.martine@live.com
116	martine.robin	addr	92, avenue Legros\n16805 Sainte Timothée
117	martine.robin	tel	+33 (0)4 98 47 68 52
118	p_paul	mail	pereira.paul@tiscali.fr
119	p_paul	addr	392, rue Lopez\n59845 Moulin
120	p_paul	tel	+33 (0)4 73 99 22 67
121	barbes	mail	barbe.susan@gmail.com
122	barbes	addr	boulevard Stéphanie Vaillant\n52914 PerretBourg
123	barbes	tel	+33 (0)4 15 72 17 39
124	pelletier.laetitia46	mail	pelletier.laetitia@voila.fr
125	pelletier.laetitia46	addr	avenue Émile Boulay\n40789 Weiss-sur-Loiseau
126	pelletier.laetitia46	tel	+33 2 28 39 72 07
127	l_isaac	mail	lemoine.isaac@tele2.fr
128	l_isaac	addr	980, chemin Corinne Delmas\n04119 Descamps-sur-Rossi
129	l_isaac	tel	+33 4 79 42 53 25
130	thomaso	mail	thomas.olivier@voila.fr
131	thomaso	addr	17, chemin Zoé Techer\n20495 Perrin-les-Bains
132	thomaso	tel	+33 (0)1 60 23 68 80
133	pires.penelope44	mail	pires.pénélope@dbmail.com
134	pires.penelope44	addr	15, avenue de Camus\n26484 Delahaye-sur-Mer
135	pires.penelope44	tel	+33 (0)5 16 96 90 07
136	toussaint_emmanuelle	mail	toussaint.emmanuelle@ifrance.com
137	toussaint_emmanuelle	addr	24, chemin de Morin\n23438 Saint Thérèse
138	toussaint_emmanuelle	tel	+33 4 34 29 83 20
139	leduc.zacharie57	mail	leduc.zacharie@free.fr
140	leduc.zacharie57	addr	605, boulevard Rocher\n52268 Dupont-la-Forêt
141	leduc.zacharie57	tel	03 22 57 54 92
142	gerard.laurent	mail	laurent.gérard@live.com
143	gerard.laurent	addr	741, rue de Hardy\n84209 Valette
144	gerard.laurent	tel	05 19 47 04 50
145	hoarau.maggie50	mail	hoarau.maggie@sfr.fr
146	hoarau.maggie50	addr	442, avenue Vallet\n64313 Renault
147	hoarau.maggie50	tel	+33 5 94 31 57 20
148	l_isaac1	mail	leduc.isaac@noos.fr
149	l_isaac1	addr	952, chemin Leleu\n97282 Martel-sur-Albert
150	l_isaac1	tel	0322366920
151	c_camille	mail	collet.camille@tele2.fr
152	c_camille	addr	80, rue Mathieu\n63880 François
153	c_camille	tel	01 58 74 82 15
154	danielm	mail	daniel.marguerite@sfr.fr
155	danielm	addr	124, chemin Thierry Vallet\n66444 Collet-la-Forêt
156	danielm	tel	0579169951
157	michelle.joly	mail	joly.michelle@yahoo.fr
158	michelle.joly	addr	22, boulevard Dufour\n56724 Collet
159	michelle.joly	tel	+33 1 55 22 72 22
160	lopes_leon	mail	lopes.léon@free.fr
161	lopes_leon	addr	37, boulevard Dubois\n66435 Mallet
162	lopes_leon	tel	02 76 05 50 36
163	letellierv	mail	letellier.victor@wanadoo.fr
164	letellierv	addr	396, chemin Margot Imbert\n97143 Dos Santos
165	letellierv	tel	+33 (0)5 17 32 90 74
166	marcelle.faure	mail	faure.marcelle@hotmail.fr
167	marcelle.faure	addr	78, avenue Anaïs Ferrand\n07802 Thierry-sur-Barre
168	marcelle.faure	tel	04 30 14 21 79
169	dossantos.laurent56	mail	dos santos.laurent@voila.fr
170	dossantos.laurent56	addr	94, rue Pinto\n10795 Pasquierboeuf
171	dossantos.laurent56	tel	04 99 49 78 41
172	philippe_paulette	mail	philippe.paulette@hotmail.fr
173	philippe_paulette	addr	rue Louis Lombard\n10268 DevauxBourg
174	philippe_paulette	tel	03 63 53 04 52
175	guibertl	mail	guibert.léon@yahoo.fr
176	guibertl	addr	515, boulevard Hortense Robin\n07295 Baron
177	guibertl	tel	+33 4 37 28 10 28
178	pelletier_zoe	mail	pelletier.zoé@voila.fr
179	pelletier_zoe	addr	16, boulevard Michelle Grenier\n07988 Sainte Maryse
180	pelletier_zoe	tel	05 47 46 58 42
181	leclerc_brigitte	mail	leclerc.brigitte@tiscali.fr
182	leclerc_brigitte	addr	57, boulevard de Moreno\n53441 Petitjeanboeuf
183	leclerc_brigitte	tel	05 53 63 79 65
184	salmon.christine7	mail	salmon.christine@free.fr
185	salmon.christine7	addr	254, rue René Clément\n73835 Sainte Zoé-la-Forêt
186	salmon.christine7	tel	0519754911
187	marie_gilles	mail	marie.gilles@gmail.com
188	marie_gilles	addr	rue Lefèvre\n18541 Lejeune
189	marie_gilles	tel	+33 (0)1 44 14 17 73
190	c_adrienne	mail	chauvet.adrienne@sfr.fr
191	c_adrienne	addr	91, rue Seguin\n16152 Duhamel
192	c_adrienne	tel	05 08 51 30 64
193	lambert_thibault	mail	lambert.thibault@laposte.net
194	lambert_thibault	addr	boulevard Gimenez\n69414 Noël
195	lambert_thibault	tel	+33 (0)2 32 59 63 95
196	chantal.leroux	mail	le roux.chantal@laposte.net
197	chantal.leroux	addr	2, chemin de Laurent\n81606 Le Goff
198	chantal.leroux	tel	0482774047
199	hoareau_celina	mail	hoareau.célina@ifrance.com
200	hoareau_celina	addr	23, boulevard Emmanuel Gimenez\n88175 Antoine
201	hoareau_celina	tel	+33 5 90 44 33 17
202	monnier_christophe	mail	monnier.christophe@hotmail.fr
203	monnier_christophe	addr	42, rue de Germain\n82802 Laroche
204	monnier_christophe	tel	+33 (0)2 79 74 77 43
205	p_denis	mail	pascal.denis@hotmail.fr
206	p_denis	addr	157, avenue Clerc\n26350 Payet
207	p_denis	tel	0277503470
208	pruvostn	mail	pruvost.nath@noos.fr
209	pruvostn	addr	82, rue Élisabeth Lejeune\n62296 Humbertboeuf
210	pruvostn	tel	+33 5 56 88 53 54
211	etienne.maggie59	mail	étienne.maggie@wanadoo.fr
212	etienne.maggie59	addr	11, rue de Besnard\n11647 Rossi
213	etienne.maggie59	tel	0479381816
214	guyon.catherine30	mail	guyon.catherine@hotmail.fr
215	guyon.catherine30	addr	11, boulevard Bertrand\n50544 Saint Jeanne
216	guyon.catherine30	tel	04 65 71 04 51
217	fischerp	mail	fischer.paul@voila.fr
218	fischerp	addr	39, rue Renard\n97476 DupuisVille
219	fischerp	tel	+33 (0)4 15 90 20 56
220	penelope.prevost	mail	prévost.pénélope@tiscali.fr
221	penelope.prevost	addr	55, avenue Lucy Muller\n43256 MilletBourg
222	penelope.prevost	tel	+33 (0)5 86 28 47 28
223	fouquetn	mail	fouquet.noël@voila.fr
224	fouquetn	addr	34, avenue Michelle Lamy\n39474 Hoaraudan
225	fouquetn	tel	+33 (0)2 23 93 48 03
226	leroux.alphonse1	mail	leroux.alphonse@tele2.fr
227	leroux.alphonse1	addr	avenue Geneviève Moreau\n36416 Schmitt-sur-Costa
228	leroux.alphonse1	tel	+33 (0)3 23 68 27 15
229	robin.robert94	mail	robin.robert@gmail.com
230	robin.robert94	addr	42, avenue de Fournier\n34215 Martineaunec
231	robin.robert94	tel	04 15 46 90 17
232	benard_laurence	mail	benard.laurence@dbmail.com
233	benard_laurence	addr	21, rue Gosselin\n66124 Marion-les-Bains
234	benard_laurence	tel	+33 3 76 86 14 80
235	hubert.oceane82	mail	hubert.océane@noos.fr
236	hubert.oceane82	addr	rue Dupuis\n55628 Brun
237	hubert.oceane82	tel	03 29 84 89 67
238	hoaraup	mail	hoarau.philippe@bouygtel.fr
239	hoaraup	addr	3, avenue Gaudin\n89718 Monnier-les-Bains
240	hoaraup	tel	0385472483
241	g_cecile	mail	guyot.cécile@ifrance.com
242	g_cecile	addr	29, rue Étienne Vasseur\n61615 Sainte Adèle-les-Bains
243	g_cecile	tel	0498456795
244	cecile.parent	mail	parent.cécile@noos.fr
245	cecile.parent	addr	56, rue Moreau\n89502 Saint Laetitia-les-Bains
246	cecile.parent	tel	+33 (0)7 70 81 08 34
247	guicharda	mail	guichard.astrid@tele2.fr
248	guicharda	addr	52, rue de Barbier\n66711 Sainte Anaïs-la-Forêt
249	guicharda	tel	0556621030
250	hebert.denis10	mail	hebert.denis@bouygtel.fr
251	hebert.denis10	addr	47, avenue Meunier\n97227 Lebon
252	hebert.denis10	tel	0495717461
253	gauthier.jerome93	mail	gauthier.jérôme@dbmail.com
254	gauthier.jerome93	addr	85, rue de Lopez\n65945 Salmon
255	gauthier.jerome93	tel	+33 (0)3 87 19 12 75
256	huetl	mail	huet.louis@wanadoo.fr
257	huetl	addr	719, rue de Rolland\n40579 Barbier-la-Forêt
258	huetl	tel	0140814282
259	guerin_claire	mail	guérin.claire@gmail.com
260	guerin_claire	addr	rue Laure Clerc\n06597 Renaud
261	guerin_claire	tel	0449788233
262	catherine.petitjean	mail	petitjean.catherine@free.fr
263	catherine.petitjean	addr	296, avenue de Camus\n34496 Leblanc-sur-Neveu
264	catherine.petitjean	tel	0486169340
265	adele.allard	mail	allard.adèle@laposte.net
266	adele.allard	addr	27, avenue Lopez\n92281 Navarro-la-Forêt
267	adele.allard	tel	02 52 57 40 16
268	alphonse.daniel	mail	daniel.alphonse@ifrance.com
269	alphonse.daniel	addr	rue Jean\n42163 Weber
270	alphonse.daniel	tel	0231898502
271	benard_dorothee	mail	benard.dorothée@free.fr
272	benard_dorothee	addr	rue Lebon\n44214 Muller
273	benard_dorothee	tel	04 98 82 75 54
274	boulay.andree13	mail	boulay.andrée@yahoo.fr
275	boulay.andree13	addr	69, boulevard Albert\n13520 Lemonnier-sur-Prévost
276	boulay.andree13	tel	+33 (0)2 62 98 88 77
277	v_richard	mail	vaillant.richard@wanadoo.fr
278	v_richard	addr	17, boulevard Brunet\n71397 Brun-sur-Pons
279	v_richard	tel	+33 (0)1 83 43 79 71
280	rocherc	mail	rocher.catherine@tiscali.fr
281	rocherc	addr	7, chemin Devaux\n40278 Martins-sur-Joseph
282	rocherc	tel	+33 6 38 83 10 99
283	david.allain	mail	allain.david@laposte.net
284	david.allain	addr	avenue Monique Fernandes\n05453 LemaîtreBourg
285	david.allain	tel	02 53 22 75 85
286	elise.launay	mail	launay.élise@hotmail.fr
287	elise.launay	addr	76, rue Alphonse Moreno\n91289 Lesage-sur-Guillot
288	elise.launay	tel	0178419446
289	dupuism	mail	dupuis.matthieu@club-internet.fr
290	dupuism	addr	955, avenue Élisabeth Lemoine\n72751 Girard
291	dupuism	tel	+33 8 01 66 68 44
292	tessier.martin15	mail	tessier.martin@bouygtel.fr
293	tessier.martin15	addr	88, avenue de Camus\n57773 Giraudboeuf
294	tessier.martin15	tel	0376014816
295	f_andre	mail	françois.andré@live.com
296	f_andre	addr	18, avenue Merle\n44828 Petitjean
297	f_andre	tel	02 57 19 91 28
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

COPY public.etre_vivant (idespece, nomespece, taille) FROM stdin;
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
francoise.pruvost	Pruvost	Françoise	$2b$12$0JSQ7er74/rPbqizaN34uOuy4p2BPqS0cINjm/7UR1PFk.YhRT4cG
alexandrev	Alexandre	Virginie	$2b$12$By.6w0qypOWdCMPNcwj2pu5MRYmD.cFUarCFtsDdHZ5h29XiZHCVS
bertrand.georges	Georges	Bertrand	$2b$12$kS5Xz3v/P8E0cWSXwP2tpefUE2zXvv7UsKYw4/0RvibTNed/ERYja
adele.costa	Costa	Adèle	$2b$12$.uZR8eRZKE0IvYfvRKgSFe1sdEfMcCOWkIUCA98WM5DDkusb2Z05a
baillya	Bailly	Agathe	$2b$12$CkUkvzQgkVAOav2PBXmZ4uztUD5B3maeLaUwbnWAsfI8gbkMjGkUK
g_laure	Guillou	Laure	$2b$12$MR6S4tZzh3doGFD5Hs30re2B1atZgU.bVTR4XhoosKP4vJg6BiJLu
m_oceane	Masse	Océane	$2b$12$y24lkPhLR9PALZ9p/f3AaOZdDzQRy14tJauonJl0H.zq.MBHsx/Ti
r_antoinette	Raynaud	Antoinette	$2b$12$JmCIvtp71q8WJicj7QQRtuY7waAlLTxkeDy2UoXqumRmbfupiCm9W
penelope.legendre	Legendre	Pénélope	$2b$12$Kwf7QOJgcZNQH7jOiqDiQu8vjDlthEvVmYuk7W3VPDhDzWsv1gyi.
etienne.albert	Albert	Étienne	$2b$12$.WaByhAHShmUl/rPSOp2Tu37Oj1HOqAm3Ya2r3jAqs.ZBkNdu2UBe
gomez_jean	Gomez	Jean	$2b$12$FNd.rZKeyseYpGreXHWmWuOEydNAi3RzgvmgWfoTO4njJwuLpQp2i
nicolas.daniel75	Nicolas	Daniel	$2b$12$2OOT2JOLfNX62bli4eR7feyB6L.VUT39VJskMAGkwcBBsQooVuzD2
t_zacharie	Thierry	Zacharie	$2b$12$bWkAeWiXpCuWwwuH.FvbGuLrO63ODue1UFx4ITNhgUEi5xXNvAegu
ferrand_suzanne	Ferrand	Suzanne	$2b$12$/sbfBRa.yUj0ONv4PDSVC.MyR6Ps4U5X8moSoxbdm9RKOfBG98U4i
b_thierry	Bazin	Thierry	$2b$12$E/7f2Rhl06Z84zwjRUVAX.udGSZLjo1N1Fi/7dojC/pXYpHbG7Byy
legall_nicole	Le Gall	Nicole	$2b$12$awpWGPr0RoAADxSI1vjHKuAqfIUB0RTIYGSXaxzIYgjn2WTE9CXbu
delannoy_emilie	Delannoy	Émilie	$2b$12$O.6WEH2Eu2NMe0r1oqgr.OQIZkaWaf7RYYpSi.oBFN6Uu0RnKxkmi
c_stephane	Carre	Stéphane	$2b$12$gOWjkxTCYW4th/roRcl3EOLUoSDgB7ulJDV8FPieWa40qw3vzfnvC
b_suzanne	Blot	Suzanne	$2b$12$vwLLecpM98Alnlv2SnSbX.v3i7a/bEIn/FMDHA66R9/FUPGNR.89y
delahaye.remy43	Delahaye	Rémy	$2b$12$3qhuM9ootuQcGvhoOmXb6.Pt.LBIF/T3RDgrt5CAkn.GzESDKWc32
blanchet_dominique	Blanchet	Dominique	$2b$12$AvboEs/r57rdMSchM4GfmOTWCR66KupJ5cwBZxfg9fkKYkJM5ieym
fabrem	Fabre	Maurice	$2b$12$CX3pwXvJDfG8QIdliF0Nn.CbaX.7SnHniivXV7xMJsCcylpVPWG7m
l_lucie	Lefort	Lucie	$2b$12$aJhexDWw214RuFNE0j1eEOCW0a//eyj0DXgDkT46qZjXsIPNb2H2u
g_robert	Gimenez	Robert	$2b$12$DLVkSEJw60ARYJ3a8EwokeuPW2UBLjpaSrDtF5M2FBQd5/XzsY1Xe
leroux_eugene	Le Roux	Eugène	$2b$12$5ckKKsStze3d7/NEKQQo7Od2PAxeyByzTpxWkddIc4epokZUq.Acy
maggie.voisin	Voisin	Maggie	$2b$12$GgwYGrq3sXgqpUlunMKIa.2TYAQEK4/8OdjYqoYwg3Z.qNgY9j3SC
mullerj	Muller	Jeanne	$2b$12$HxQ7bz.OiXmo799..312NueHTQs13A2wijqXnSUIZeMHPqps3CxMe
perond	Peron	Daniel	$2b$12$HB883NToiUr.o3Pecz.nD.cOm3XYcRMSlx7AqLflf39JUYKFwu6kC
g_georges	Gauthier	Georges	$2b$12$0uIcankH3jhNbTalbpkOE.Nmvywsc7AAzjae22ybn6Bbk4s61oTre
b_michelle	Bourgeois	Michelle	$2b$12$bpYt0GZGkELFz4skL9kXMOWqUKinXIJi0Q2B1Z1P/czSfntHrohJy
m_adrienne	Marie	Adrienne	$2b$12$FSkVtxdTlBpCwqqUy/fk1euAr9xkRMZN46w4gFL1OpdPNlec.aMDK
daniel.lefebvre	Lefebvre	Daniel	$2b$12$DgORLlPHZzWXdKMiCUImPeMhUthl2X6bzNDRNae6zfYISR97h5HYm
lebreton_diane	Lebreton	Diane	$2b$12$A8vx5OaWbDGaxLQSy6eJxunS9wyBeIcdHxgamOfhC8kVwWIg9r2v6
benoit_marianne	Benoit	Marianne	$2b$12$/5O9atMZOfR.G94GXIe3Z.QzlAGaA18Ge9fOTZGV0Cq8N7HXC84BK
letellier.maurice5	Letellier	Maurice	$2b$12$7lcEkzAw9/UWb1ePJXLfMuFuaadhP5WCTOQOhAw6wVQXHdijQ/tOK
bertinm	Bertin	Marianne	$2b$12$pNNWVF2fJ0fRfLWLsf33We3kjhSuI9bjukvUmmGJs0IRaiA4GN0A2
dossantosc	Dos Santos	Constance	$2b$12$/AXsu6oX1Wtuquli4KJe6ezW7mWU66MSuyX1GrHKkPpuZf1OffyFW
godardm	Godard	Michelle	$2b$12$vrm.kkZ.cmn4DlolRN5qS.zwTkCXf34I31jsI6jJyr6hdjTbEjktO
martine.robin	Robin	Martine	$2b$12$xCAs8UcUGfF/zZb2N4wSqOwgCSu9s8dTEQ74mWt03EAVslqRlxmSO
p_paul	Pereira	Paul	$2b$12$jPkD/144E.BmKS3cYSMxw.C8v7Wr41ViiZMlCutX5ymlEFDsytefa
barbes	Barbe	Susan	$2b$12$OUys8ojUl.9t0Sx5hu0QO.pSzS4qbgQHMiLlszVBiE3MqV.JsefF2
pelletier.laetitia46	Pelletier	Laetitia	$2b$12$h0R19WjM6BnXhseOMYi.eO/vwYoDU9CQdCsb9G4BXv2Mc8yeJ/RI2
l_isaac	Lemoine	Isaac	$2b$12$Nzh7vAC2wws1p4gyxy2LOOPImaKkkR8Z7ny0xZKjqpIG2B6./Sszi
thomaso	Thomas	Olivier	$2b$12$2DjddH7MoeLaO/vtSwi7JO6wL6JvLvIHyt3fs006KOuPncE82JuzS
pires.penelope44	Pires	Pénélope	$2b$12$4gbt3zWDnC2fnWlxQ46LPuiJAYYA22Fo5Tbh11N2gWPpGesFRwF4K
toussaint_emmanuelle	Toussaint	Emmanuelle	$2b$12$bjiCzn1YeO4QcuvLrcnNIeOVVTcU1p9tJsyenEYS7llocx7pXWdIi
leduc.zacharie57	Leduc	Zacharie	$2b$12$iTajEf2VwNCwh70kNCxT.uAfDVfoJ2GBW991yv13/Mjxu6Tgh0Twm
gerard.laurent	Laurent	Gérard	$2b$12$BiIWKLuI4epTZ9eNnuzFE.v0H4Jp5ic7P8Z3vyHkTZd6wIvSMAU1G
hoarau.maggie50	Hoarau	Maggie	$2b$12$6aN4LYxN6/EDbs6RzuJUX.OX6izp3H7rcMmFLPyQuB7G1FyC6CjbG
l_isaac1	Leduc	Isaac	$2b$12$N5WOgmKx0x0C2NACRsmqFe5OoY7MkNhpciezWauNcihqlgVj8cJV2
c_camille	Collet	Camille	$2b$12$ee9GtCJsJskDKiJcp.DvH.QitzFBCkSI30RKx6W1LmPL8X4DFqxWe
danielm	Daniel	Marguerite	$2b$12$VTsWV.SovykYB/WeQdTPwuRjF5/z.3is83kvkUzsslQtfViMJZ5NW
michelle.joly	Joly	Michelle	$2b$12$yA0LrWtY5mK0XIS.H50Y7uWHn4jDOs6qQYY80RxfKaL.0LMecPOUy
lopes_leon	Lopes	Léon	$2b$12$NTcbPc4e3LmWiBzgbIDjl.nHgHLHN80PQEvwTNVbpur0P16m7C0ZS
letellierv	Letellier	Victor	$2b$12$eleHk1HY9m8Yaje1xCVpQuhBYX.dIVU871og3Ws6TpYDNmyRisC.i
marcelle.faure	Faure	Marcelle	$2b$12$kBM4xBYIl8XToVikkKXk/uVjk85HEAke53eZqLKgkFLwmOf6LsQ42
dossantos.laurent56	Dos Santos	Laurent	$2b$12$Xm7JLpvyrUayshAc9s34..EtVAjUUUxgr5izDJD2W5FwgdMPtosUq
philippe_paulette	Philippe	Paulette	$2b$12$PleNOm.CuZR0LLbWWc9wKubriSaoBaMJFtZyHhInLqlwUQe3ga1Xi
guibertl	Guibert	Léon	$2b$12$PHOM3qai9QdJqev6ssmXKuoCoKHAaP6ZX7x5zrS.HA1twp5T2DdkS
pelletier_zoe	Pelletier	Zoé	$2b$12$7hPsIahWxv7Oj5tviiurDee1vcVXl5glrK0n44YswUxSLiJpC77k.
leclerc_brigitte	Leclerc	Brigitte	$2b$12$3aOLnQgSDshIh.VLMggMXuKzKRZ.wjVyuGfRju8.r5MFbG/2eQIIC
salmon.christine7	Salmon	Christine	$2b$12$y69xjfwseK6D7eO19TmCBOAfmFgAZSrd5XMomb6ahJBhXOyPuS3F2
marie_gilles	Marie	Gilles	$2b$12$tFW5ft9J2.cIc/oGKMj7g.hRRKALrTPSPL9sWQYVjyrB/aCtkldF6
c_adrienne	Chauvet	Adrienne	$2b$12$vFE7F1vLggM7xtVfXm4Bt.zRoViEPbqDEL9qLjglhvbWjejYk.bV6
lambert_thibault	Lambert	Thibault	$2b$12$pkpk.8.SHvMM8/57qCCAee1cuvaCzEgcsSwWCJqOyml9Tmvr/vd6m
chantal.leroux	Le Roux	Chantal	$2b$12$U/tMM6G5RvccfabRTTs/3OZFi6pOgW3txpk/J7X3g3mgk/3k6c/6O
hoareau_celina	Hoareau	Célina	$2b$12$5ZDpLnghOIvXAkmFxDGPHOwHCUb6nuhB0uhI39XDu.vkabNuqe73m
monnier_christophe	Monnier	Christophe	$2b$12$MK4K7SaC0GveNt90uf1OSuNZcoRUlr2aIv6dV3RWqGI7nhUd/nEWe
p_denis	Pascal	Denis	$2b$12$uWpl90prwwKKMKIwTXI0aO3/2deUE1TGJTKzsguyRK3.s5uzSE7AW
pruvostn	Pruvost	Nath	$2b$12$Pg1wO7hqsmxjhaYOQyec9OB1XpPWIuSer0HGMWF9p7QsOfYKkj8wW
etienne.maggie59	Étienne	Maggie	$2b$12$5PNLvEHWrkN/NwQ4bxP3yuZwZrDd6nw7TR0OvklB07iarRPkbZX2u
guyon.catherine30	Guyon	Catherine	$2b$12$8z1beu6gmY6YxcGhh/8iCuYqEaDZS6EhMPCrBotLxLXgCFmVbYE6y
fischerp	Fischer	Paul	$2b$12$YywP.Rmea5uqnW/XIyhJg.D8t5OrVpe815ivGo7l88l.PsDo/t2Au
penelope.prevost	Prévost	Pénélope	$2b$12$/RPh2uPSt0MBdCU9ScIU4.35kmAEJpcsG7wtPVkQQCceyxTILoLL2
fouquetn	Fouquet	Noël	$2b$12$jpgSCSMlhVxSSnkDoGfE8eE/mtzbTUX9a9Gzui9/CuWNxtIW/dUaO
leroux.alphonse1	Leroux	Alphonse	$2b$12$2cKOg4.W9M07GX.fQs0o4.4lInlkDKJlhuqIkdFalaZ7SjWxwWDBm
robin.robert94	Robin	Robert	$2b$12$9MqWqd.nlnGmM799HwqjIOaRspPkmYV/X45UJ9NyB.3UV1wZlEFUK
benard_laurence	Benard	Laurence	$2b$12$8Y1DRwG2X0wM6wBVPN2xwe1TvVlBFtiVWB2e9iwghZ1.vSze2ocau
hubert.oceane82	Hubert	Océane	$2b$12$uwldkcbBxh3vj.Qs8OUK4.RhrwCzpd2qstnTC6DkcCfd4OZpxACZa
hoaraup	Hoarau	Philippe	$2b$12$.3KEiSro2xP3l6Ra/L/fqOSnWRVsW7XZ5dwL5o0H.apGvVvlNpq8e
g_cecile	Guyot	Cécile	$2b$12$izZSW2cc1qnuRWON7W0YR.yjFs/hOvb8./GbKlAaqRGLiSIFG1ULm
cecile.parent	Parent	Cécile	$2b$12$1gQpGb/mjM5VHIr5W5gFVu.CJgdlnHt8C0XaxYIduThcP0w71x4Zu
guicharda	Guichard	Astrid	$2b$12$BJ6n1UUEBn2WsIAeOxpEke4jY6qaehHsFfp6NXTcbgL2fF4Cfe7zi
hebert.denis10	Hebert	Denis	$2b$12$CARnEei7fSmGkTzqEHpAM.tMfZ5otc8P44Xx0ZrkADjyLuHWBZzpW
gauthier.jerome93	Gauthier	Jérôme	$2b$12$JsiZUIrqGIPkUPZ/awLT6.YGwiJCK9SIB.H0ru5q.Ufd1Mi0AnT5e
huetl	Huet	Louis	$2b$12$iD5oBPDdJxbGyDlXDLRbVe8980z52FrF/EAM0hy3FIfwaXrfcG9iK
guerin_claire	Guérin	Claire	$2b$12$mYvE5CuRS7AAJLVEkDClkeUYnnSIvHlQolahD2BKAc69LkhamTtLG
catherine.petitjean	Petitjean	Catherine	$2b$12$84qOqHaftPra8ZGugp6AJe5MRDAmdBHHWl70Jia3NXMeAncqGvIRe
adele.allard	Allard	Adèle	$2b$12$s1jHZwRKuUVKYZsF12/fb.UI3qHggD.6hvusFPman7zxmPir5zg7a
alphonse.daniel	Daniel	Alphonse	$2b$12$Fv9FQQDYtIYAWgfL3Y4kf.hg/8T7fjHP5KBb2D7iNvncWNTgKnUjG
benard_dorothee	Benard	Dorothée	$2b$12$pFJIE8X4t/yjFA9ctj96uOYZsSYaLkGo.1g2HTHDh9jnccHag5RVa
boulay.andree13	Boulay	Andrée	$2b$12$bRnuV0YRWSmW2TTRkkkf9.hCON1CYMKnHkTAxyQxdxJ2I/7fKBMzS
v_richard	Vaillant	Richard	$2b$12$gtN/XT2agLCRFTX6uW0AP.IAqlAgF9nhiU7XsA/9GipF3AFpGRShi
rocherc	Rocher	Catherine	$2b$12$4YvmqEJ9aWI05LDIv2M9Neye30ACU5XfB2sq6LNvg2.t6i.i8X.UK
david.allain	Allain	David	$2b$12$PA4NnpgcCpQwxq3dV7GxLexqleNG9qFOE0ZgMWLQ4ke8bzFZmGj6e
elise.launay	Launay	Élise	$2b$12$gO6m.S9s4/PJ9otBWywIOuNLAhv2Eq8hm1ed2NQBsefhAgf62rSva
dupuism	Dupuis	Matthieu	$2b$12$4xuiirt6HOh1Faa4nleNNOT91xnjCSKN5WUqmzrZQ8zLX4RiIHmVS
tessier.martin15	Tessier	Martin	$2b$12$0k8iOkqlhDJMCx.q3S1QzeqLukpZrDfJ.FUZJwgxnNSbkrmzlCk7W
f_andre	François	André	$2b$12$JDD9NMvjiA7MhjtOASX4e.kK1sWQuDBFaj5gd0We01xbm7XDCQO7O
denis.lefevre	Lefèvre	Denis	$2b$12$Jmzqs4vtiAyCsyEKGwtQBOrkr40IoLC.CF4GutAHcZiXYuPxjlKym
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
-- Name: attribut attribut_auteur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.attribut
    ADD CONSTRAINT attribut_auteur_fkey FOREIGN KEY (auteur) REFERENCES public.adherent(num);


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

