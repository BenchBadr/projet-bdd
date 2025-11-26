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
    num integer NOT NULL,
    idprofil integer,
    statut integer,
    xp integer DEFAULT 0
);


ALTER TABLE public.adherent OWNER TO arl;

--
-- Name: anime; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.anime (
    idprofile integer NOT NULL,
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
    profil integer,
    type_coord character varying(30),
    coordonnee character varying(50)
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
    auteur integer
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
    idprofil integer NOT NULL,
    prenom character varying(50),
    nom character varying(50)
);


ALTER TABLE public.profil OWNER TO arl;

--
-- Name: profil_idprofil_seq; Type: SEQUENCE; Schema: public; Owner: arl
--

CREATE SEQUENCE public.profil_idprofil_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profil_idprofil_seq OWNER TO arl;

--
-- Name: profil_idprofil_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arl
--

ALTER SEQUENCE public.profil_idprofil_seq OWNED BY public.profil.idprofil;


--
-- Name: renseigne; Type: TABLE; Schema: public; Owner: arl
--

CREATE TABLE public.renseigne (
    idprofil integer NOT NULL,
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
-- Name: statut_idstatut_seq; Type: SEQUENCE; Schema: public; Owner: arl
--

CREATE SEQUENCE public.statut_idstatut_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.statut_idstatut_seq OWNER TO arl;

--
-- Name: statut_idstatut_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arl
--

ALTER SEQUENCE public.statut_idstatut_seq OWNED BY public.statut.idstatut;


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
-- Name: profil idprofil; Type: DEFAULT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.profil ALTER COLUMN idprofil SET DEFAULT nextval('public.profil_idprofil_seq'::regclass);


--
-- Name: sortie idsortie; Type: DEFAULT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.sortie ALTER COLUMN idsortie SET DEFAULT nextval('public.sortie_idsortie_seq'::regclass);


--
-- Name: statut idstatut; Type: DEFAULT; Schema: public; Owner: arl
--

ALTER TABLE ONLY public.statut ALTER COLUMN idstatut SET DEFAULT nextval('public.statut_idstatut_seq'::regclass);


--
-- Data for Name: adherent; Type: TABLE DATA; Schema: public; Owner: arl
--

COPY public.adherent (num, idprofil, statut, xp) FROM stdin;
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
70	Parc des Berges de Queyries 9
71	Jardin de la Béchade C 4
72	Parc Monséjour 86
73	Parc Floral D 47
74	Parc Bordelais Jj 231 Lisière
75	Jardin Public P 10 Lisière
76	Parc Bordelais W 15 Espaces centraux
77	Jardin Public T 11 Lac
78	Jardin des Dames de la foi 69
79	Parc Bordelais Abris O Chênaie
80	Parc Monséjour 104
81	Parc des Berges de Garonne A 209
82	Jardin Public C 4 Espaces Centraux
83	Parc Rivière Lisière
84	Jardin de la Visitation_Bâtiment
85	Parc Rivière 108 Lisière
86	Jardin de la Béchade A
87	Jardin des Dames de la foi 134
88	Jardin Public B 12 Lisière
89	Jardin de la Visitation 10
90	Jardin de la Visitation 22
91	Jardin des Dames de la foi 124
92	Jardin des Dames de la foi 20
93	Parc Rivière 179 Lisière
94	Parc Bordelais O 22 Chênaie
95	Parc des Berges de Garonne A 116
96	Jardin Public J 2 Espaces Centraux
97	Jardin Public Abris J Espaces Centraux
98	Parc Bordelais Jj 112 Lisière
99	Parc des Berges de Garonne A 24
100	Parc des Berges de Garonne E 76
101	Parc Bordelais N 12 Chênaie
102	Parc Bordelais Y Lisière
103	Parc Bordelais Qr 27 Espaces centraux
104	Parc Bordelais G 39 Espaces centraux
105	Parc Bordelais F 91 Espaces centraux
106	Parc Bordelais Abris Cc Espaces centraux
107	Parc Floral J 198
108	Parc Floral J 210
109	Parc Bordelais P 43 Chênaie
110	Parc Bordelais P 29 Chênaie
111	Jardin Public D 4 Espaces Centraux
112	Jardin Public G 25 Espaces Centraux
113	Jardin Public AB 5 Espaces Centraux
114	Jardin Public R Espaces Centraux
115	Parc des Berges de Queyries Quai de Queyries_B 145
116	Parc Denis et Eugène Bühler A 192
117	Parc Bordelais H 179 Lisière
118	Parc Bordelais Z 217 Lisière
119	Parc Rivière Maison du Jardinier
120	Parc des Berges de Queyries 25
121	Parc des Berges de Queyries 17
122	Parc Bordelais Abris H Lisière
123	Parc Bordelais N 18 Chênaie
124	Parc Bordelais G 15 Espaces centraux
125	Parc Bordelais E 53 Lisière
126	Parc Rivière 61 Lisière
127	Parc des Berges de Queyries 40
128	Parc Monséjour 14
129	Parc Monséjour 123
130	Jardin Brascassat 48
131	Parc Bordelais Z 79 Lisière
132	Parc Monséjour 29
133	Parc Bordelais Z 160 Lisière
134	Jardin de la Béchade A 14
135	Jardin de la Béchade A 26
136	Parc Rivière 198 Lisière
137	Parc Monséjour_Bâtiment
138	Parc des Berges de Garonne C 65
139	Parc Floral K 86
140	Parc Bordelais E 147 Lisière
141	Jardin des Dames de la foi 93
142	Parc Bordelais V 60 Lisière
143	Parc Denis et Eugène Bühler A 140
144	Parc Monséjour 13
145	Parc Bordelais G 150 Espaces centraux
146	Parc Bordelais L 3 Chênaie
147	Jardin Brascassat 26
148	Parc des Berges de Garonne C 126
149	Jardin des Dames de la foi 116
150	Jardin de la Visitation 26
151	Jardin de la Visitation 4
152	Jardin des Dames de la foi 1
153	Jardin des Dames de la foi 74
154	Jardin Public V 25 Lac
155	Parc des Berges de Garonne D 6
156	Jardin Public JB K 2 Jardin Botanique
157	Parc des Berges de Garonne D 44
158	Parc Rivière Ruines Espaces centraux
159	Parc Bordelais Z 39 Lisière
160	Parc Denis et Eugène Bühler B 40
161	Jardin des Dames de la foi 60
162	Parc Denis et Eugène Bühler A 127
163	Parc des Berges de Garonne C 104
164	Parc Bordelais Qr 2 Espaces centraux
165	Parc Bordelais O 49 Chênaie
166	Parc Bordelais K 17 Chênaie
167	Parc Rivière Espaces centraux
168	Jardin Public M 11 Aire de jeux-Ile aux enfants
169	Jardin Public F 10 Espaces Centraux
170	Jardin Public AC 9 Espaces Centraux
171	Parc des Berges de Garonne B 94
172	Parc des Berges de Garonne B 7
173	Parc des Berges de Garonne C 120
174	Jardin de la Visitation_Bâtiment
175	Parc Floral_Bâtiment Classes vertes
176	Jardin de la Béchade A
177	Parc Monséjour_Bâtiment
178	Parc Monséjour_Bâtiment
179	Jardin de la Béchade A 49
180	Parc Bordelais F 24 Espaces centraux
181	Parc Rivière Maison du Jardinier
182	Jardin de la Béchade A 34
183	Parc Bordelais Agent logé H Lisière
184	Jardin Brascassat 88
185	Parc Bordelais I 7 Espaces centraux
186	Jardin Public H 8 Espaces Centraux
187	Jardin Public O 27 Espaces Centraux
188	Parc des Berges de Queyries Quai de Queyries_B 120
189	Parc Bordelais Jj 131 Lisière
190	Parc Bordelais D 16 Espaces centraux
191	Jardin Public AA 6 Espaces Centraux
192	Parc Bordelais Qr 38 Espaces centraux
193	Parc Bordelais Bb 13 Espaces centraux
194	Parc des Berges de Garonne A 260
195	Parc des Berges de Garonne E 97
196	Parc Bordelais Qr 186 Espaces centraux
197	Jardin Public JB H 10 Jardin Botanique
198	Parc Floral J 217
199	Parc des Berges de Queyries Quai de Queyries_B 116
200	Parc des Berges de Queyries Quai de Queyries_B 128
201	Parc Bordelais Local Animaux Ee Espaces centraux
202	Parc Bordelais Buvette Q Chênaie
203	Parc Denis et Eugène Bühler A 112
204	Parc Bordelais Z 104 Lisière
205	Parc des Berges de Queyries 22
206	Parc des Berges de Queyries 12
207	Parc Rivière 37 Espaces centraux
208	Parc Bordelais O 8 Chênaie
209	Jardin Public Z 12 Lisière
210	Parc Rivière 28 Espaces centraux
211	Parc Monséjour Entrée à droite
212	Parc des Berges de Garonne C 90
213	Parc Rivière 170 Lisière
214	Parc Denis et Eugène Bühler A 145
215	Parc Rivière Lisière
216	Parc Monséjour 5
217	Parc Monséjour 187
218	Jardin Public Q 4 Lisière
219	Parc Rivière 144 Lisière
220	Parc Rivière 146 Lisière
221	Parc Monséjour 66
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
139	70	statut_nichoir	\N	\N
140	70	coord	44.84739429085423, -0.5650934689228767	\N
141	71	statut_nichoir	\N	\N
142	71	coord	44.826134324304036, -0.5988760796882622	\N
143	72	statut_nichoir	\N	\N
144	72	coord	44.85402406958259, -0.6318264513232998	\N
145	73	statut_nichoir	\N	\N
146	73	coord	44.90125537971666, -0.5618886579819312	\N
147	74	statut_nichoir	\N	\N
148	74	coord	44.85224819730487, -0.6049965787632341	\N
149	75	statut_nichoir	\N	\N
150	75	coord	44.849109349131126, -0.5757846083686671	\N
151	76	statut_nichoir	\N	\N
152	76	coord	44.85528709697896, -0.6028318114250042	\N
153	77	statut_nichoir	\N	\N
154	77	coord	44.85012608973844, -0.5785708331128069	\N
155	78	statut_nichoir	\N	\N
156	78	coord	44.824661115785, -0.5818709072465998	\N
157	79	statut_nichoir	\N	\N
158	79	coord	44.855174728524595, -0.6014863937209527	\N
159	80	statut_nichoir	\N	\N
160	80	coord	44.854131328858514, -0.632327131056902	\N
161	81	statut_nichoir	\N	\N
162	81	coord	44.88294059282123, -0.5405153228361179	\N
163	82	statut_nichoir	\N	\N
164	82	coord	44.84901526611568, -0.5786808774605657	\N
165	83	statut_nichoir	\N	\N
166	83	coord	44.85519419187455, -0.5864462524626002	\N
167	84	statut_nichoir	\N	\N
168	84	coord	44.84794065948023, -0.5955466201592837	\N
169	85	statut_nichoir	\N	\N
170	85	coord	44.854512116497126, -0.5874033728214573	\N
171	86	statut_nichoir	\N	\N
172	86	coord	44.82641757392131, -0.5974764315483911	\N
173	87	statut_nichoir	\N	\N
174	87	coord	44.82480694448113, -0.582166036216812	\N
175	88	statut_nichoir	\N	\N
176	88	coord	44.85052061152282, -0.5792107828440793	\N
177	89	statut_nichoir	\N	\N
178	89	coord	44.84823913747018, -0.5951433210464511	\N
179	90	statut_nichoir	\N	\N
180	90	coord	44.84864033013897, -0.5948391214540405	\N
181	91	statut_nichoir	\N	\N
182	91	coord	44.82499876258882, -0.5824682028323331	\N
183	92	statut_nichoir	\N	\N
184	92	coord	44.825046573309386, -0.5820654930931081	\N
185	93	statut_nichoir	\N	\N
186	93	coord	44.854969435858784, -0.5863405669410081	\N
187	94	statut_nichoir	\N	\N
188	94	coord	44.85450481811712, -0.6014114500757755	\N
189	95	statut_nichoir	\N	\N
190	95	coord	44.88584805714403, -0.5402023871723697	\N
191	96	statut_nichoir	\N	\N
192	96	coord	44.84798680017282, -0.5770133664033134	\N
193	97	statut_nichoir	\N	\N
194	97	coord	44.84826954660709, -0.5769479827086214	\N
195	98	statut_nichoir	\N	\N
196	98	coord	44.85138135753778, -0.6047171641810242	\N
197	99	statut_nichoir	\N	\N
198	99	coord	44.887766881378, -0.5400873710225663	\N
199	100	statut_nichoir	\N	\N
200	100	coord	44.88848291877718, -0.5404872207546337	\N
201	101	statut_nichoir	\N	\N
202	101	coord	44.854720381063835, -0.6008989751175591	\N
203	102	statut_nichoir	\N	\N
204	102	coord	44.85535369207082, -0.6045099827238122	\N
205	103	statut_nichoir	\N	\N
206	103	coord	44.85458239008017, -0.6037850523460951	\N
207	104	statut_nichoir	\N	\N
208	104	coord	44.85046194982184, -0.6017015562531477	\N
209	105	statut_nichoir	\N	\N
210	105	coord	44.85134011657259, -0.6009853761894758	\N
211	106	statut_nichoir	\N	\N
212	106	coord	44.85285498796239, -0.6027858033945142	\N
213	107	statut_nichoir	\N	\N
214	107	coord	44.9031353341329, -0.5617648289567335	\N
215	108	statut_nichoir	\N	\N
216	108	coord	44.90299909819424, -0.5617832675609125	\N
217	109	statut_nichoir	\N	\N
218	109	coord	44.853866187833916, -0.6018426277575162	\N
219	110	statut_nichoir	\N	\N
220	110	coord	44.853849876719345, -0.6017858850476567	\N
221	111	statut_nichoir	\N	\N
222	111	coord	44.84864066105785, -0.5794072505455494	\N
223	112	statut_nichoir	\N	\N
224	112	coord	44.84851461024403, -0.5778551754705685	\N
225	113	statut_nichoir	\N	\N
226	113	coord	44.8492784026918, -0.5803992712227687	\N
227	114	statut_nichoir	\N	\N
228	114	coord	44.849820317180345, -0.5775919661848183	\N
229	115	statut_nichoir	\N	\N
230	115	coord	44.845027835321886, -0.5647297347727751	\N
231	116	statut_nichoir	\N	\N
232	116	coord	44.87609982895916, -0.5729920510065986	\N
233	117	statut_nichoir	\N	\N
234	117	coord	44.85341774973475, -0.5992056446387013	\N
235	118	statut_nichoir	\N	\N
236	118	coord	44.85462561213879, -0.6045054501841295	\N
237	119	statut_nichoir	\N	\N
238	119	coord	44.85553385922754, -0.5858638130297505	\N
239	120	statut_nichoir	\N	\N
240	120	coord	44.84548419526279, -0.5652671201627497	\N
241	121	statut_nichoir	\N	\N
242	121	coord	44.84656118106911, -0.56541709538104	\N
243	122	statut_nichoir	\N	\N
244	122	coord	44.85346515592864, -0.5994755671914456	\N
245	123	statut_nichoir	\N	\N
246	123	coord	44.85482897003203, -0.6010714152126686	\N
247	124	statut_nichoir	\N	\N
248	124	coord	44.85082449326397, -0.6012072987376657	\N
249	125	statut_nichoir	\N	\N
250	125	coord	44.85127741990669, -0.6004841540602284	\N
251	126	statut_nichoir	\N	\N
252	126	coord	44.85545291663876, -0.5881753631877097	\N
253	127	statut_nichoir	\N	\N
254	127	coord	44.8450274237568, -0.5649643371372376	\N
255	128	statut_nichoir	\N	\N
256	128	coord	44.85414328361508, -0.6309217434491216	\N
257	129	statut_nichoir	\N	\N
258	129	coord	44.85421771222505, -0.6327874892565571	\N
259	130	statut_nichoir	\N	\N
260	130	coord	44.81542881248361, -0.5538192436022845	\N
261	131	statut_nichoir	\N	\N
262	131	coord	44.854338464433134, -0.6044588582968399	\N
263	132	statut_nichoir	\N	\N
264	132	coord	44.853703500961345, -0.6311588320919467	\N
265	133	statut_nichoir	\N	\N
266	133	coord	44.85365282680685, -0.6048123406527779	\N
267	134	statut_nichoir	\N	\N
268	134	coord	44.82666978562503, -0.5986677489032614	\N
269	135	statut_nichoir	\N	\N
270	135	coord	44.826565034093534, -0.5992312073779205	\N
271	136	statut_nichoir	\N	\N
272	136	coord	44.85540784111293, -0.5862897256268265	\N
273	137	statut_nichoir	\N	\N
274	137	coord	44.85391262131457, -0.6316433876136646	\N
275	138	statut_nichoir	\N	\N
276	138	coord	44.88498974929214, -0.5392123543361482	\N
277	139	statut_nichoir	\N	\N
278	139	coord	44.9057593433986, -0.5611885207735793	\N
279	140	statut_nichoir	\N	\N
280	140	coord	44.85164338121278, -0.6002604669062033	\N
281	141	statut_nichoir	\N	\N
282	141	coord	44.82525497487082, -0.5818952887021027	\N
283	142	statut_nichoir	\N	\N
284	142	coord	44.85545898882601, -0.6016812199404008	\N
285	143	statut_nichoir	\N	\N
286	143	coord	44.8780734475018, -0.5744889084914291	\N
287	144	statut_nichoir	\N	\N
288	144	coord	44.85408787113224, -0.6307780541366351	\N
289	145	statut_nichoir	\N	\N
290	145	coord	44.85041849637921, -0.6012670141199202	\N
291	146	statut_nichoir	\N	\N
292	146	coord	44.8541977077791, -0.6002786736161408	\N
293	147	statut_nichoir	\N	\N
294	147	coord	44.8160475006127, -0.554256929714486	\N
295	148	statut_nichoir	\N	\N
296	148	coord	44.88362537519562, -0.5392485892168312	\N
297	149	statut_nichoir	\N	\N
298	149	coord	44.82457163620305, -0.5819748344178001	\N
299	150	statut_nichoir	\N	\N
300	150	coord	44.848478783508156, -0.5949370551964919	\N
301	151	statut_nichoir	\N	\N
302	151	coord	44.84802236982777, -0.5953211286979437	\N
303	152	statut_nichoir	\N	\N
304	152	coord	44.82531554743872, -0.5824348602746398	\N
305	153	statut_nichoir	\N	\N
306	153	coord	44.82484126953506, -0.5822174085384537	\N
307	154	statut_nichoir	\N	\N
308	154	coord	44.85020653459385, -0.5803267841533117	\N
309	155	statut_nichoir	\N	\N
310	155	coord	44.8868850505175, -0.5390831896875908	\N
311	156	statut_nichoir	\N	\N
312	156	coord	44.84969788220098, -0.5799361665567339	\N
313	157	statut_nichoir	\N	\N
314	157	coord	44.88784696593865, -0.539000157477065	\N
315	158	statut_nichoir	\N	\N
316	158	coord	44.85505119947738, -0.5865874216217162	\N
317	159	statut_nichoir	\N	\N
318	159	coord	44.85345053564365, -0.6056048686008143	\N
319	160	statut_nichoir	\N	\N
320	160	coord	44.87462420615611, -0.5699537619393354	\N
321	161	statut_nichoir	\N	\N
322	161	coord	44.82542745419847, -0.5816843704414474	\N
323	162	statut_nichoir	\N	\N
324	162	coord	44.87790407213572, -0.5742170240562878	\N
325	163	statut_nichoir	\N	\N
326	163	coord	44.88410898293126, -0.5396145956551803	\N
327	164	statut_nichoir	\N	\N
328	164	coord	44.854778435052964, -0.6029418345998273	\N
329	165	statut_nichoir	\N	\N
330	165	coord	44.8550169693905, -0.6015384583403216	\N
331	166	statut_nichoir	\N	\N
332	166	coord	44.8535806244485, -0.6006097682313618	\N
333	167	statut_nichoir	\N	\N
334	167	coord	44.855414295934, -0.5873514114887688	\N
335	168	statut_nichoir	\N	\N
336	168	coord	44.849225402320776, -0.5773977413873524	\N
337	169	statut_nichoir	\N	\N
338	169	coord	44.847985140954194, -0.5790119586105952	\N
339	170	statut_nichoir	\N	\N
340	170	coord	44.84965540746308, -0.5807252285001382	\N
341	171	statut_nichoir	\N	\N
342	171	coord	44.88189503512549, -0.5397478371743717	\N
343	172	statut_nichoir	\N	\N
344	172	coord	44.882602237583335, -0.5394871109350325	\N
345	173	statut_nichoir	\N	\N
346	173	coord	44.8837743183072, -0.5396906935935032	\N
347	174	statut_nichoir	\N	\N
348	174	coord	44.848037547215895, -0.5955079677464113	\N
349	175	statut_nichoir	\N	\N
350	175	coord	44.90510228597442, -0.567011940178138	\N
351	176	statut_nichoir	\N	\N
352	176	coord	44.826687135267285, -0.5972843991587204	\N
353	177	statut_nichoir	\N	\N
354	177	coord	44.854118164442845, -0.6315736486591061	\N
355	178	statut_nichoir	\N	\N
356	178	coord	44.85410124011399, -0.6313869198348395	\N
357	179	statut_nichoir	\N	\N
358	179	coord	44.82613765633451, -0.5980443950381061	\N
359	180	statut_nichoir	\N	\N
360	180	coord	44.852284782504434, -0.6002200162404967	\N
361	181	statut_nichoir	\N	\N
362	181	coord	44.85545668273783, -0.5858573616705544	\N
363	182	statut_nichoir	\N	\N
364	182	coord	44.8265100291547, -0.5990051136052509	\N
365	183	statut_nichoir	\N	\N
366	183	coord	44.85396615818533, -0.5987500613456364	\N
367	184	statut_nichoir	\N	\N
368	184	coord	44.81512179076897, -0.5546015271844202	\N
369	185	statut_nichoir	\N	\N
370	185	coord	44.85408336785559, -0.5993679297243858	\N
371	186	statut_nichoir	\N	\N
372	186	coord	44.847574681535534, -0.5777499428211699	\N
373	187	statut_nichoir	\N	\N
374	187	coord	44.84962582308253, -0.5767954042648652	\N
375	188	statut_nichoir	\N	\N
376	188	coord	44.84702051233242, -0.5647494684946325	\N
377	189	statut_nichoir	\N	\N
378	189	coord	44.85186295804892, -0.604989563475107	\N
379	190	statut_nichoir	\N	\N
380	190	coord	44.85237819364341, -0.6013307816363441	\N
381	191	statut_nichoir	\N	\N
382	191	coord	44.85027207057961, -0.5789818356513076	\N
383	192	statut_nichoir	\N	\N
384	192	coord	44.85430962930962, -0.6034404853876911	\N
385	193	statut_nichoir	\N	\N
386	193	coord	44.853217895371046, -0.6043974708685249	\N
387	194	statut_nichoir	\N	\N
388	194	coord	44.88274812148258, -0.5402130853148243	\N
389	195	statut_nichoir	\N	\N
390	195	coord	44.888252259536415, -0.5400746454579581	\N
391	196	statut_nichoir	\N	\N
392	196	coord	44.855037646373134, -0.6029546304107156	\N
393	197	statut_nichoir	\N	\N
394	197	coord	44.8498809789909, -0.5802266435598864	\N
395	198	statut_nichoir	\N	\N
396	198	coord	44.90286004411004, -0.5618659193764576	\N
397	199	statut_nichoir	\N	\N
398	199	coord	44.84739920932494, -0.5645366201018663	\N
399	200	statut_nichoir	\N	\N
400	200	coord	44.846407278547325, -0.5649555235123881	\N
401	201	statut_nichoir	\N	\N
402	201	coord	44.85193733019004, -0.603736065402274	\N
403	202	statut_nichoir	\N	\N
404	202	coord	44.85330887137566, -0.6020668840241536	\N
405	203	statut_nichoir	\N	\N
406	203	coord	44.877717232954026, -0.5739734499433506	\N
407	204	statut_nichoir	\N	\N
408	204	coord	44.85374602009994, -0.6046088334043535	\N
409	205	statut_nichoir	\N	\N
410	205	coord	44.84572028084005, -0.5653107281836858	\N
411	206	statut_nichoir	\N	\N
412	206	coord	44.847032864960745, -0.5653013046666696	\N
413	207	statut_nichoir	\N	\N
414	207	coord	44.85567389349891, -0.5872347296053158	\N
415	208	statut_nichoir	\N	\N
416	208	coord	44.85433104104534, -0.6017477138769854	\N
417	209	statut_nichoir	\N	\N
418	209	coord	44.849119427392495, -0.5803586184533697	\N
419	210	statut_nichoir	\N	\N
420	210	coord	44.85558736040485, -0.5870849644144263	\N
421	211	statut_nichoir	\N	\N
422	211	coord	44.8545527411188, -0.631581673289929	\N
423	212	statut_nichoir	\N	\N
424	212	coord	44.88454959898156, -0.5392219118988973	\N
425	213	statut_nichoir	\N	\N
426	213	coord	44.854807992845394, -0.5862582009086308	\N
427	214	statut_nichoir	\N	\N
428	214	coord	44.8780356555869, -0.574263707859505	\N
429	215	statut_nichoir	\N	\N
430	215	coord	44.85592855250936, -0.5853961140165485	\N
431	216	statut_nichoir	\N	\N
432	216	coord	44.854165836673076, -0.6311297235455143	\N
433	217	statut_nichoir	\N	\N
434	217	coord	44.855185589381904, -0.6323888075725365	\N
435	218	statut_nichoir	\N	\N
436	218	coord	44.84952912461638, -0.5760455679903079	\N
437	219	statut_nichoir	\N	\N
438	219	coord	44.854463938169054, -0.5858360806595262	\N
439	220	statut_nichoir	\N	\N
440	220	coord	44.85449907368477, -0.5859503469942247	\N
441	221	statut_nichoir	\N	\N
442	221	coord	44.85353485994612, -0.6306223750658412	\N
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

COPY public.profil (idprofil, prenom, nom) FROM stdin;
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
\.


--
-- Name: attribut_idatt_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.attribut_idatt_seq', 1, false);


--
-- Name: coordonnees_idcoord_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.coordonnees_idcoord_seq', 1, false);


--
-- Name: cotisation_inscription_idpaiement_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.cotisation_inscription_idpaiement_seq', 1, false);


--
-- Name: habitat_idhabitat_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.habitat_idhabitat_seq', 221, true);


--
-- Name: info_habitat_idinfohab_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.info_habitat_idinfohab_seq', 442, true);


--
-- Name: profil_idprofil_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.profil_idprofil_seq', 1, false);


--
-- Name: sortie_idsortie_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.sortie_idsortie_seq', 1, false);


--
-- Name: statut_idstatut_seq; Type: SEQUENCE SET; Schema: public; Owner: arl
--

SELECT pg_catalog.setval('public.statut_idstatut_seq', 1, false);


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

