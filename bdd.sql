--
-- PostgreSQL database dump
--

-- Dumped from database version 11.9 (Debian 11.9-0+deb10u1)
-- Dumped by pg_dump version 11.9 (Debian 11.9-0+deb10u1)

-- Started on 2020-12-04 23:53:16 CET

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

--
-- TOC entry 609 (class 1247 OID 33183)
-- Name: etat; Type: TYPE; Schema: public; Owner: dbadmin
--

CREATE TYPE public.etat AS ENUM (
    'neuf',
    'moyen',
    'dégradé'
);


ALTER TYPE public.etat OWNER TO dbadmin;

--
-- TOC entry 621 (class 1247 OID 33211)
-- Name: sys; Type: TYPE; Schema: public; Owner: dbadmin
--

CREATE TYPE public.sys AS ENUM (
    'linux',
    'windows',
    'macos'
);


ALTER TYPE public.sys OWNER TO dbadmin;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 33154)
-- Name: auteur; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.auteur (
    id_auteur character varying(50) NOT NULL,
    nom_auteur character varying(50),
    prenom_auteur character varying(50),
    date_naissauteur date,
    nationalite_auteur character varying(50)
);


ALTER TABLE public.auteur OWNER TO dbadmin;

--
-- TOC entry 197 (class 1259 OID 33159)
-- Name: categorie; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.categorie (
    intitule character varying(50) NOT NULL,
    num_salle_cat integer,
    num_etagere_cat integer
);


ALTER TABLE public.categorie OWNER TO dbadmin;

--
-- TOC entry 204 (class 1259 OID 33229)
-- Name: emprunt; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.emprunt (
    id_exemplaire character varying(50) NOT NULL,
    id_utilisateur character varying(50) NOT NULL,
    effet boolean,
    date_emprunt date,
    date_retoure date,
    isbn character varying(50) NOT NULL
);


ALTER TABLE public.emprunt OWNER TO dbadmin;

--
-- TOC entry 199 (class 1259 OID 33189)
-- Name: exemplaire; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.exemplaire (
    id_exemp character varying(50) NOT NULL,
    titre_exemp character varying(50),
    dispo_exemp character varying(50),
    etat_exemp public.etat,
    emplacement_exemp character varying(50),
    id_livre character varying(50)
);


ALTER TABLE public.exemplaire OWNER TO dbadmin;

--
-- TOC entry 200 (class 1259 OID 33199)
-- Name: utilisateur; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.utilisateur (
    id_u character varying(50) NOT NULL,
    nom_u character varying(50),
    prenom_u character varying(50),
    tel_u integer,
    mail_u character varying(50),
    adresse_u character varying(50),
    date_naissu date,
    mot_de_passeu character varying(100)
);


ALTER TABLE public.utilisateur OWNER TO dbadmin;

--
-- TOC entry 206 (class 1259 OID 33285)
-- Name: id_user; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.id_user
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.id_user OWNER TO dbadmin;

--
-- TOC entry 2990 (class 0 OID 0)
-- Dependencies: 206
-- Name: id_user; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.id_user OWNED BY public.utilisateur.id_u;


--
-- TOC entry 198 (class 1259 OID 33164)
-- Name: livre; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.livre (
    isbn character varying NOT NULL,
    titre_livre character varying(50),
    date_publication date,
    maison_edition character varying(50),
    id_auteur character varying(50),
    categorie character varying(50),
    nombre_exemplaire integer
);


ALTER TABLE public.livre OWNER TO dbadmin;

--
-- TOC entry 201 (class 1259 OID 33204)
-- Name: materiel; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.materiel (
    id_mat character varying(50) NOT NULL,
    etat_mat public.etat,
    num_salle integer,
    disponibilte boolean,
    CONSTRAINT materiel_ck CHECK ((((id_mat)::text ~~ 'Tab%'::text) OR ((id_mat)::text ~~ 'Ordi%'::text)))
);


ALTER TABLE public.materiel OWNER TO dbadmin;

--
-- TOC entry 202 (class 1259 OID 33217)
-- Name: ordinateur; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.ordinateur (
    id_ordi character varying(50) NOT NULL,
    marque_ordi character varying(50),
    debit_internet integer,
    system public.sys,
    impression boolean,
    CONSTRAINT ordinateur_ck CHECK (((id_ordi)::text ~~ 'Ordi%'::text))
);


ALTER TABLE public.ordinateur OWNER TO dbadmin;

--
-- TOC entry 205 (class 1259 OID 33244)
-- Name: reservation; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.reservation (
    id_utilisateur character varying(50) NOT NULL,
    id_materiel character varying(50) NOT NULL,
    date_effet date,
    heure character varying
);


ALTER TABLE public.reservation OWNER TO dbadmin;

--
-- TOC entry 203 (class 1259 OID 33223)
-- Name: table_l; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.table_l (
    id_table character varying(50) NOT NULL,
    prise_electricite boolean,
    nombre_place integer,
    CONSTRAINT table_l_ck CHECK (((id_table)::text ~~ 'Tab%'::text))
);


ALTER TABLE public.table_l OWNER TO dbadmin;

--
-- TOC entry 2819 (class 2604 OID 33287)
-- Name: utilisateur id_u; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.utilisateur ALTER COLUMN id_u SET DEFAULT nextval('public.id_user'::regclass);


--
-- TOC entry 2974 (class 0 OID 33154)
-- Dependencies: 196
-- Data for Name: auteur; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY public.auteur (id_auteur, nom_auteur, prenom_auteur, date_naissauteur, nationalite_auteur) FROM stdin;
100	Karl	Marx	1818-05-05	Angleterre
101	Emile	Zola	1840-09-29	France
102	Albert	Camus	1913-11-07	France
103	Victor	Hugo	1885-02-26	France
104	William	Shakespear	1564-04-23	France
105	Mouloud	Mammeri	1927-12-28	Algerie
106	Kateb	Yacine	1929-08-02	Algerie
107	Tahar	Djaout	1954-01-11	Algerie
108	Mouloud	Feraoun	1913-05-11	Algerie
109	Charles	Dickens	1870-06-09	Angleterre
110	Vladimir	Ilitch lenine	1870-04-10	Russie
111	Rosa	luxemburg	1871-03-05	Russie
112	Trotsky	leon	1879-01-12	Russie
\.


--
-- TOC entry 2975 (class 0 OID 33159)
-- Dependencies: 197
-- Data for Name: categorie; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY public.categorie (intitule, num_salle_cat, num_etagere_cat) FROM stdin;
hestoire	3	2
economie	2	2
sociologie	3	3
philosophie	3	1
leterature	1	1
\.


--
-- TOC entry 2982 (class 0 OID 33229)
-- Dependencies: 204
-- Data for Name: emprunt; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY public.emprunt (id_exemplaire, id_utilisateur, effet, date_emprunt, date_retoure, isbn) FROM stdin;
200	34	f	\N	\N	61
225	34	f	\N	\N	63
229	34	f	\N	\N	63
294	34	f	\N	\N	95
296	34	f	\N	\N	95
21	34	f	\N	\N	31
\.


--
-- TOC entry 2977 (class 0 OID 33189)
-- Dependencies: 199
-- Data for Name: exemplaire; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY public.exemplaire (id_exemp, titre_exemp, dispo_exemp, etat_exemp, emplacement_exemp, id_livre) FROM stdin;
20	le capitale	oui	moyen	1	31
21	le capitale	non	moyen	1	31
001	Revolution trahie	oui	neuf	2	100
002	Revolution trahie	oui	neuf	2	100
003	Revolution trahie	oui	neuf	2	100
004	Revolution trahie	oui	neuf	2	100
005	Ma vie	oui	neuf	2	111
006	Ma vie	oui	neuf	2	111
007	Ma vie	oui	neuf	2	111
008	Ma vie	oui	neuf	2	111
009	Ma vie	oui	neuf	2	111
010	Ma vie	oui	neuf	2	111
011	Ma vie	oui	neuf	2	111
012	Ma vie	oui	neuf	2	111
013	Ma vie	oui	neuf	2	111
014	le manifeste	oui	neuf	1	30
015	le manifeste	oui	neuf	1	30
016	le manifeste	oui	neuf	1	30
017	le manifeste	oui	neuf	1	30
018	le manifeste	oui	neuf	1	30
23	le capitale	oui	moyen	1	31
24	le capitale	oui	moyen	1	31
25	le capitale	oui	moyen	1	31
31	Germinale	oui	moyen	1	41
32	Germinale	oui	moyen	1	41
33	Germinale	oui	moyen	1	41
34	Germinale	oui	moyen	1	41
35	Germinale	oui	moyen	1	41
36	Germinale	oui	moyen	1	41
37	Germinale	oui	moyen	1	41
38	Germinale	oui	moyen	1	41
41	Nana	oui	moyen	1	42
42	Nana	oui	moyen	1	42
51	Au bonheur des demes	oui	moyen	1	43
52	Au bonheur des demes	oui	moyen	1	43
53	Au bonheur des demes	oui	moyen	1	43
54	Au bonheur des demes	oui	moyen	1	43
55	Au bonheur des demes	oui	moyen	1	43
61	l etranger	oui	moyen	1	44
62	l etranger	oui	moyen	1	44
63	l etranger	oui	moyen	1	44
64	l etranger	oui	moyen	1	44
65	l etranger	oui	moyen	1	44
66	l etranger	oui	moyen	1	44
67	l etranger	oui	moyen	1	44
6	l etranger	oui	moyen	1	44
68	l etranger	oui	moyen	1	44
69	l etranger	oui	moyen	1	44
70	l etranger	oui	moyen	1	44
71	l etranger	oui	moyen	1	44
72	l etranger	oui	moyen	1	44
73	l etranger	oui	moyen	1	44
74	l etranger	oui	moyen	1	44
80	la chute	oui	moyen	1	45
81	la chute	oui	moyen	1	45
82	la chute	oui	moyen	1	45
83	la chute	oui	moyen	1	45
84	la chute	oui	moyen	1	45
85	la chute	oui	moyen	1	45
86	la chute	oui	moyen	1	45
87	la chute	oui	moyen	1	45
88	la chute	oui	moyen	1	45
89	la chute	oui	moyen	1	45
111	la peste	oui	neuf	1	46
112	la peste	oui	neuf	1	46
113	la peste	oui	neuf	1	46
114	la peste	oui	neuf	1	46
115	la peste	oui	neuf	1	46
116	la peste	oui	neuf	1	46
117	la peste	oui	neuf	1	46
118	la peste	oui	neuf	1	46
119	la peste	oui	neuf	1	46
110	la peste	oui	neuf	1	46
120	la peste	oui	neuf	1	46
121	la peste	oui	neuf	1	46
122	la peste	oui	neuf	1	46
123	la peste	oui	neuf	1	46
124	la peste	oui	neuf	1	46
140	les mesirables	oui	neuf	1	47
141	les mesirables	oui	neuf	1	47
142	les mesirables	oui	neuf	1	47
143	les mesirables	oui	neuf	1	47
144	les mesirables	oui	neuf	1	47
145	les mesirables	oui	neuf	1	47
146	les mesirables	oui	neuf	1	47
147	les mesirables	oui	neuf	1	47
148	les mesirables	oui	neuf	1	47
149	les mesirables	oui	neuf	1	47
150	les mesirables	oui	neuf	1	47
151	les mesirables	oui	neuf	1	47
152	les mesirables	oui	neuf	1	47
153	les mesirables	oui	neuf	1	47
154	les mesirables	oui	neuf	1	47
155	les mesirables	oui	neuf	1	47
156	les mesirables	oui	neuf	1	47
160	Notre dame de paris	oui	neuf	1	48
161	Romeo et juliette	oui	neuf	1	51
162	Romeo et juliette	oui	neuf	1	51
163	Romeo et juliette	oui	neuf	1	51
164	Romeo et juliette	oui	neuf	1	51
165	Romeo et juliette	oui	neuf	1	51
166	Romeo et juliette	oui	neuf	1	51
167	Romeo et juliette	oui	neuf	1	51
168	Romeo et juliette	oui	neuf	1	51
171	Hamlet	oui	neuf	1	52
172	Hamlet	oui	neuf	1	52
173	Hamlet	oui	neuf	1	52
174	Coriolan	oui	neuf	1	53
175	Coriolan	oui	neuf	1	53
176	Coriolan	oui	neuf	1	53
177	Coriolan	oui	neuf	1	53
181	journal 1955-1962	oui	neuf	1	54
182	journal 1955-1962	oui	neuf	1	54
183	journal 1955-1962	oui	neuf	1	54
184	journal 1955-1962	oui	neuf	1	54
185	journal 1955-1962	oui	neuf	1	54
186	journal 1955-1962	oui	neuf	1	54
187	journal 1955-1962	oui	neuf	1	54
191	jours de kabylie	oui	neuf	3	59
192	jours de kabylie	oui	neuf	3	59
193	jours de kabylie	oui	neuf	3	59
194	jours de kabylie	oui	neuf	3	59
195	jours de kabylie	oui	neuf	3	59
196	jours de kabylie	oui	neuf	3	59
197	jours de kabylie	oui	neuf	3	59
198	jours de kabylie	oui	neuf	3	59
201	fils du pauvre	oui	neuf	4	60
202	fils du pauvre	oui	neuf	4	60
203	fils du pauvre	oui	neuf	4	60
204	fils du pauvre	oui	neuf	4	60
205	fils du pauvre	oui	neuf	4	60
206	fils du pauvre	oui	neuf	4	60
207	fils du pauvre	oui	neuf	4	60
208	fils du pauvre	oui	neuf	4	60
209	fils du pauvre	oui	neuf	4	60
211	les chemins qui montent	oui	neuf	4	61
212	les chemins qui montent	oui	neuf	4	61
213	les chemins qui montent	oui	neuf	4	61
215	les chemins qui montent	oui	neuf	4	61
214	les chemins qui montent	oui	neuf	4	61
216	les chemins qui montent	oui	neuf	4	61
221	Nedjma	oui	neuf	4	63
222	Nedjma	oui	neuf	4	63
223	Nedjma	oui	neuf	4	63
224	Nedjma	oui	neuf	4	63
226	Nedjma	oui	neuf	4	63
227	Nedjma	oui	neuf	4	63
228	Nedjma	oui	neuf	4	63
230	Nedjma	oui	neuf	4	63
231	Contes Berberes	oui	neuf	4	64
232	Contes Berberes	oui	neuf	4	64
233	Contes Berberes	oui	neuf	4	64
234	Contes Berberes	oui	neuf	4	64
235	Contes Berberes	oui	neuf	4	64
241	le sommeil du juste	oui	moyen	5	65
242	le sommeil du juste	oui	moyen	5	65
243	le sommeil du juste	oui	moyen	5	65
244	le sommeil du juste	oui	moyen	5	65
245	le sommeil du juste	oui	moyen	5	65
246	le sommeil du juste	oui	moyen	5	65
247	le sommeil du juste	oui	moyen	5	65
251	l etat et la revolution	oui	moyen	5	90
252	l etat et la revolution	oui	moyen	5	90
253	l etat et la revolution	oui	moyen	5	90
254	l etat et la revolution	oui	moyen	5	90
255	l etat et la revolution	oui	moyen	5	90
256	l etat et la revolution	oui	moyen	5	90
257	l etat et la revolution	oui	moyen	5	90
258	l etat et la revolution	oui	moyen	5	90
259	l etat et la revolution	oui	moyen	5	90
260	l etat et la revolution	oui	moyen	5	90
261	l etat et la revolution	oui	moyen	5	90
262	l etat et la revolution	oui	moyen	5	90
263	l etat et la revolution	oui	moyen	5	90
291	accumulation du capital	oui	moyen	6	95
292	accumulation du capital	oui	moyen	6	95
293	accumulation du capital	oui	moyen	6	95
295	accumulation du capital	oui	moyen	6	95
297	accumulation du capital	oui	moyen	6	95
298	accumulation du capital	oui	moyen	6	95
299	accumulation du capital	oui	moyen	6	95
290	accumulation du capital	oui	moyen	6	95
301	Reform of revolution	oui	moyen	6	96
302	Reform of revolution	oui	moyen	6	96
303	Reform of revolution	oui	moyen	6	96
304	Reform of revolution	oui	moyen	6	96
305	Reform of revolution	oui	moyen	6	96
402	que faire	oui	moyen	6	91
403	que faire	oui	moyen	6	91
404	que faire	oui	moyen	6	91
405	que faire	oui	moyen	6	91
407	que faire	oui	moyen	6	91
409	que faire	oui	moyen	6	91
408	que faire	oui	moyen	6	91
200	les chemins qui montent	non	neuf	4	61
406	que faire	oui	moyen	6	91
225	Nedjma	non	neuf	4	63
229	Nedjma	non	neuf	4	63
294	accumulation du capital	non	moyen	6	95
296	accumulation du capital	non	moyen	6	95
411	que faire	oui	moyen	6	91
412	que faire	oui	moyen	6	91
401	que faire	oui	moyen	6	91
410	que faire	oui	moyen	6	91
\.


--
-- TOC entry 2976 (class 0 OID 33164)
-- Dependencies: 198
-- Data for Name: livre; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY public.livre (isbn, titre_livre, date_publication, maison_edition, id_auteur, categorie, nombre_exemplaire) FROM stdin;
30	le manifeste	1848-02-21	flammarion	100	hestoire	5
31	le capitale	1867-09-14	flammarion	100	economie	6
41	Germinale	1884-04-01	monasso	101	leterature	8
42	Nana	1880-02-05	angelic	101	leterature	2
43	Au bonheur des demes	1882-12-12	monasso	101	leterature	4
45	la chute	1956-07-12	Gouraya	102	leterature	10
46	la peste	1947-03-03	Bougie	102	leterature	15
47	les mesirables	1862-03-14	monasso	103	leterature	20
48	Notre dame de paris	1831-02-02	monasso	103	leterature	1
51	Romeo et juliette	1597-03-03	adara	104	leterature	7
52	Hamlet	1603-05-01	Gormandia	104	leterature	3
53	Coriolan	1623-07-12	Gormandia	104	leterature	4
54	journal 1955-1962	1962-01-02	Gouraya	105	hestoire	7
59	jours de kabylie	1968-10-13	Gouraya	105	sociologie	8
60	fils du pauvre	1970-03-08	Gouraya	105	sociologie	9
61	les chemins qui montent	1969-10-10	Bougie	105	hestoire	7
63	Nedjma	1980-11-01	Bougie	106	hestoire	10
64	Contes Berberes	1986-05-26	Bougie	107	hestoire	5
65	le sommeil du juste	1979-03-31	Gouraya	107	sociologie	7
91	que faire	1902-02-02	oulianov	110	hestoire	12
95	accumulation du capital	1913-11-13	zamasc	111	philosophie	10
96	Reform of revolution	1973-06-12	zamasc	111	philosophie	5
100	Revolution trahie	1937-08-08	zamasc	112	sociologie	4
111	Ma vie	1390-09-12	oulianov	112	hestoire	9
90	l etat et la revolution	1917-08-25	oulianov	110	sociologie	13
44	l etranger	1942-06-02	Gouraya	102	leterature	15
\.


--
-- TOC entry 2979 (class 0 OID 33204)
-- Dependencies: 201
-- Data for Name: materiel; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY public.materiel (id_mat, etat_mat, num_salle, disponibilte) FROM stdin;
Tab20	neuf	23	t
Tab19	neuf	23	t
Ordi15	neuf	25	t
Ordi19	moyen	25	t
Tab15	neuf	23	t
Ordi16	neuf	25	t
Ordi17	moyen	25	t
Ordi18	moyen	24	t
Ordi20	neuf	24	t
Tab16	moyen	25	t
Tab18	moyen	25	t
Tab17	moyen	25	t
\.


--
-- TOC entry 2980 (class 0 OID 33217)
-- Dependencies: 202
-- Data for Name: ordinateur; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY public.ordinateur (id_ordi, marque_ordi, debit_internet, system, impression) FROM stdin;
Ordi15	acer	20	windows	t
Ordi17	asus	20	windows	t
Ordi16	dell	22	linux	t
Ordi18	asus	20	macos	t
Ordi19	acer	24	macos	f
Ordi20	toshiba	16	linux	f
\.


--
-- TOC entry 2983 (class 0 OID 33244)
-- Dependencies: 205
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY public.reservation (id_utilisateur, id_materiel, date_effet, heure) FROM stdin;
\.


--
-- TOC entry 2981 (class 0 OID 33223)
-- Dependencies: 203
-- Data for Name: table_l; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY public.table_l (id_table, prise_electricite, nombre_place) FROM stdin;
Tab15	t	2
Tab16	t	2
Tab17	t	4
Tab18	f	2
Tab19	t	4
Tab20	f	4
\.


--
-- TOC entry 2978 (class 0 OID 33199)
-- Dependencies: 200
-- Data for Name: utilisateur; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY public.utilisateur (id_u, nom_u, prenom_u, tel_u, mail_u, adresse_u, date_naissu, mot_de_passeu) FROM stdin;
41	azlaoui	ibtissam	548712369	ibtissam@azlaoui.com	cergy	1999-12-02	azerty11
42	elqour	soufiane	6541286	soufiane@elqour.com	cergy	1999-06-23	azerty22
34	houari	mourtada	696669769	imadhou00@gmail.com	cergy	1999-08-26	azerty00.
\.


--
-- TOC entry 2991 (class 0 OID 0)
-- Dependencies: 206
-- Name: id_user; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('public.id_user', 42, true);


--
-- TOC entry 2824 (class 2606 OID 33158)
-- Name: auteur auteur_pk; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.auteur
    ADD CONSTRAINT auteur_pk PRIMARY KEY (id_auteur);


--
-- TOC entry 2826 (class 2606 OID 33163)
-- Name: categorie categorie_pk; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.categorie
    ADD CONSTRAINT categorie_pk PRIMARY KEY (intitule);


--
-- TOC entry 2840 (class 2606 OID 33284)
-- Name: emprunt emprunt_pk; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.emprunt
    ADD CONSTRAINT emprunt_pk PRIMARY KEY (id_exemplaire, id_utilisateur, isbn);


--
-- TOC entry 2830 (class 2606 OID 33193)
-- Name: exemplaire exemplaire_pk; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT exemplaire_pk PRIMARY KEY (id_exemp);


--
-- TOC entry 2828 (class 2606 OID 33171)
-- Name: livre livre_pk; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.livre
    ADD CONSTRAINT livre_pk PRIMARY KEY (isbn);


--
-- TOC entry 2834 (class 2606 OID 33209)
-- Name: materiel materiel_pk; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.materiel
    ADD CONSTRAINT materiel_pk PRIMARY KEY (id_mat);


--
-- TOC entry 2836 (class 2606 OID 33222)
-- Name: ordinateur ordinateur_pk; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.ordinateur
    ADD CONSTRAINT ordinateur_pk PRIMARY KEY (id_ordi);


--
-- TOC entry 2842 (class 2606 OID 33251)
-- Name: reservation reservation_pk; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pk PRIMARY KEY (id_utilisateur, id_materiel);


--
-- TOC entry 2838 (class 2606 OID 33228)
-- Name: table_l table_l_pk; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.table_l
    ADD CONSTRAINT table_l_pk PRIMARY KEY (id_table);


--
-- TOC entry 2832 (class 2606 OID 33203)
-- Name: utilisateur utilisateur_pk; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_pk PRIMARY KEY (id_u);


--
-- TOC entry 2849 (class 2606 OID 33234)
-- Name: emprunt emprunt_fk; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.emprunt
    ADD CONSTRAINT emprunt_fk FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateur(id_u);


--
-- TOC entry 2850 (class 2606 OID 33239)
-- Name: emprunt emprunt_fk2; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.emprunt
    ADD CONSTRAINT emprunt_fk2 FOREIGN KEY (id_exemplaire) REFERENCES public.exemplaire(id_exemp);


--
-- TOC entry 2848 (class 2606 OID 33278)
-- Name: emprunt emprunt_fk3; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.emprunt
    ADD CONSTRAINT emprunt_fk3 FOREIGN KEY (isbn) REFERENCES public.livre(isbn);


--
-- TOC entry 2845 (class 2606 OID 33194)
-- Name: exemplaire exemplaire_fk2; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT exemplaire_fk2 FOREIGN KEY (id_livre) REFERENCES public.livre(isbn);


--
-- TOC entry 2843 (class 2606 OID 33172)
-- Name: livre livre_fk; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.livre
    ADD CONSTRAINT livre_fk FOREIGN KEY (id_auteur) REFERENCES public.auteur(id_auteur);


--
-- TOC entry 2844 (class 2606 OID 33177)
-- Name: livre livre_fk2; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.livre
    ADD CONSTRAINT livre_fk2 FOREIGN KEY (categorie) REFERENCES public.categorie(intitule);


--
-- TOC entry 2846 (class 2606 OID 33268)
-- Name: ordinateur odrinateur_fk; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.ordinateur
    ADD CONSTRAINT odrinateur_fk FOREIGN KEY (id_ordi) REFERENCES public.materiel(id_mat);


--
-- TOC entry 2851 (class 2606 OID 33252)
-- Name: reservation reservation_fk; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_fk FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateur(id_u);


--
-- TOC entry 2852 (class 2606 OID 33257)
-- Name: reservation reservation_fk2; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_fk2 FOREIGN KEY (id_materiel) REFERENCES public.materiel(id_mat);


--
-- TOC entry 2847 (class 2606 OID 33273)
-- Name: table_l table_l_fk; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.table_l
    ADD CONSTRAINT table_l_fk FOREIGN KEY (id_table) REFERENCES public.materiel(id_mat);


-- Completed on 2020-12-04 23:53:16 CET

--
-- PostgreSQL database dump complete
--

