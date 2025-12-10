--
-- PostgreSQL database dump
--

\restrict GjS3ABUgOlColtO1M2pb3b2Mzro5oKbFpLm9I7xAnsY4B845AUV1nTPJn4oY66S

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

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
-- Data for Name: api_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_role (id, name) FROM stdin;
\.


--
-- Data for Name: api_customuser; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_customuser (password, last_login, is_superuser, id, outlook, first_name, last_name, phone, avatar_url, is_active, is_email_verified, is_staff, role_id) FROM stdin;
pbkdf2_sha256$1000000$4dQIz6XkXcYQIlDgifJMoK$SEHCZC8ivDaxwbRaO0sJYjMGttLOn9u8FTJbmciuxvA=	2025-12-09 18:09:05.293252+00	t	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d	n_zheken@kbtu.kz	Nazerke	Zheken	\N	\N	t	f	t	\N
pbkdf2_sha256$1000000$tXprp9aQXNtIFiGcyt9uuN$gyGIT4RFvI+m3PE+SxL/jP+SS/YGHZl25ut0cBwhzXs=	\N	f	a0c40a97-e7ca-4a3a-89d6-52e9f6a1774f	nazerke@example.com	nazerke	nazerke	87023423043	\N	t	f	f	\N
pbkdf2_sha256$1000000$uOKHtZKDtSrFsTF97JjiU9$sUUme4pqmJexBSCiehk4H7l9BUL7lWJQwVl88WpHark=	\N	f	d1567ee6-72db-44fa-aa82-6925f775b601	y_yessenuly@kbtu.kz	Yerlan	Yessenuly	87777777777	\N	t	f	f	\N
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
1	admin
\.


--
-- Data for Name: api_customuser_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_customuser_groups (id, customuser_id, group_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	contenttypes	contenttype
5	sessions	session
6	api	role
7	api	customuser
8	news	news
9	clubs	club
10	events	event
11	tickets	ticket
12	reviews	review
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add content type	4	add_contenttype
14	Can change content type	4	change_contenttype
15	Can delete content type	4	delete_contenttype
16	Can view content type	4	view_contenttype
17	Can add session	5	add_session
18	Can change session	5	change_session
19	Can delete session	5	delete_session
20	Can view session	5	view_session
21	Can add role	6	add_role
22	Can change role	6	change_role
23	Can delete role	6	delete_role
24	Can view role	6	view_role
25	Can add custom user	7	add_customuser
26	Can change custom user	7	change_customuser
27	Can delete custom user	7	delete_customuser
28	Can view custom user	7	view_customuser
29	Can add news	8	add_news
30	Can change news	8	change_news
31	Can delete news	8	delete_news
32	Can view news	8	view_news
33	Can add club	9	add_club
34	Can change club	9	change_club
35	Can delete club	9	delete_club
36	Can view club	9	view_club
37	Can add event	10	add_event
38	Can change event	10	change_event
39	Can delete event	10	delete_event
40	Can view event	10	view_event
41	Can add ticket	11	add_ticket
42	Can change ticket	11	change_ticket
43	Can delete ticket	11	delete_ticket
44	Can view ticket	11	view_ticket
45	Can add review	12	add_review
46	Can change review	12	change_review
47	Can delete review	12	delete_review
48	Can view review	12	view_review
\.


--
-- Data for Name: api_customuser_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_customuser_user_permissions (id, customuser_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	1	5
6	1	6
7	1	7
8	1	8
9	1	9
10	1	10
11	1	11
12	1	12
13	1	13
14	1	14
15	1	15
16	1	16
17	1	17
18	1	18
19	1	19
20	1	20
21	1	21
22	1	22
23	1	23
24	1	24
25	1	25
26	1	26
27	1	27
28	1	28
29	1	29
30	1	30
31	1	31
32	1	32
33	1	33
34	1	34
35	1	35
36	1	36
37	1	37
38	1	38
39	1	39
40	1	40
41	1	41
42	1	42
43	1	43
44	1	44
45	1	45
46	1	46
47	1	47
48	1	48
\.


--
-- Data for Name: clubs_club; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clubs_club (id, name, name_kk, name_ru, name_en, description, description_kk, description_ru, description_en, instagram_link, telegram_link, manager_id) FROM stdin;
1	Faces	Faces	Faces	Faces	Faces KBTU is a student conglomerate focused on sparking interest in campus life and making it brighter and more engaging. Nothing lasts forever — except FACES.	Faces KBTU — студенттердің университеттегі ішкі өмірге деген қызығушылығын арттырып, оны бұрынғыдан да жарқын етуді мақсат ететін конгломерат. Ештеңе мәңгі емес, FACES мәңгі!	Faces KBTU — студенческий конгломерат, цель которого — развивать интерес студентов к внутренней жизни университета и делать её ярче. Ничто не вечно, FACES вечен!	Faces KBTU is a student conglomerate focused on sparking interest in campus life and making it brighter and more engaging. Nothing lasts forever — except FACES.	https://www.instagram.com/faces_kbtu/	\N	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
2	Big City Lights	Big City Lights	Big City Lights	Big City Lights	Big City Lights is a club that ignites passion in students’ hearts. Its mission is to enrich the cultural life of KBTU students, build an elite community, and enhance youth social and political engagement	Big City Lights — студенттердің жүрегіне от жағатын клуб. Мақсаты — КБТУ студенттерінің мәдени деңгейін көтеру, элитарлық қоғам құру және жастардың әлеуметтік-саяси белсенділігін арттыру.	Big City Lights — клуб, который зажигает огонь в сердцах студентов. Его цель — развивать культурный уровень студентов КБТУ, формировать элитарное сообщество и повышать социальную и политическую активность молодёжи.	Big City Lights is a club that ignites passion in students’ hearts. Its mission is to enrich the cultural life of KBTU students, build an elite community, and enhance youth social and political engagement	https://www.instagram.com/bigcitylightskbtu/	\N	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
3	KBTU Moments	KBTU Moments	KBTU Moments	KBTU Moments	KBTU Moments is a photography club capturing the most genuine and vibrant moments of university life. Say cheese — we’re already taking the shot!	KBTU Moments — университет өмірінің ең шынайы әрі жарқын сәттерін түсіретін фотоклуб. Say cheese — біз кадр түсіріп жатырмыз!	KBTU Moments — фотоклуб, который ловит самые живые и искренние моменты жизни университета. Say cheese — мы уже делаем кадр!	KBTU Moments is a photography club capturing the most genuine and vibrant moments of university life. Say cheese — we’re already taking the shot!	https://www.instagram.com/kbtu_moments/	\N	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
4	KBTU GDG	KBTU GDG	KBTU GDG	KBTU GDG	KBTU GDG is a student community for those interested in Google technologies and modern software development. A place to learn, grow, and build projects.	KBTU GDG — Google технологиялары мен заманауи IT саласына қызығатын студенттерге арналған қауымдастық. Мұнда даму, оқу және жобалар жасау мүмкіндігі бар.	KBTU GDG — студенческое сообщество для тех, кто интересуется технологиями Google и современным IT. Место для роста, обучения и создания проектов.	KBTU GDG is a student community for those interested in Google technologies and modern software development. A place to learn, grow, and build projects.	https://www.instagram.com/kbtu_gdg/	\N	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
5	Enactus KBTU	Enactus KBTU	Enactus KBTU	Enactus KBTU	Enactus KBTU is a student team developing IT products that improve people’s lives. We combine technology, entrepreneurship, and real social impact.	Enactus KBTU — адамдардың өмірін жақсартатын IT жобаларын жасайтын студенттер тобы. Біз технологияны, кәсіпкерлікті және әлеуметтік әсерді біріктіреміз.	Enactus KBTU — команда студентов, создающая IT-проекты, которые делают жизнь людей лучше. Мы соединяем технологии, предпринимательство и социальный эффект.	Enactus KBTU is a student team developing IT products that improve people’s lives. We combine technology, entrepreneurship, and real social impact.	https://www.instagram.com/kbtu_enaction/	\N	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
6	Student Government of KBTU	ҚБТУ Студенттік Өкілеттігі	Студенческое Правление КБТУ	Student Government of KBTU	The KBTU Student Government is the organization that represents student interests and fosters a space for growth, initiatives, and collaboration. We organize events, support student-led projects, and strive to make campus life engaging, comfortable, and inspiring.	ҚБТУ Студенттік Өкілеттігі — студенттердің мүдделерін қорғайтын және олардың бастамаларын қолдайтын ұйым. Біз түрлі іс-шаралар ұйымдастырып, жобаларды дамытуға көмектесеміз және университеттегі өмірді жайлы әрі белсенді етуге жұмыс істейміз.	Студенческое Правление КБТУ — это орган, представляющий интересы студентов и создающий пространство для инициатив, развития и сотрудничества. Мы организуем мероприятия, поддерживаем студенческие проекты и работаем над тем, чтобы сделать университетскую жизнь комфортной, активной и яркой.	The KBTU Student Government is the organization that represents student interests and fosters a space for growth, initiatives, and collaboration. We organize events, support student-led projects, and strive to make campus life engaging, comfortable, and inspiring.	https://www.instagram.com/kbtu_gov/	\N	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2025-12-09 18:18:36.487733+00	1	admin	1	[{"added": {}}]	3	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
2	2025-12-10 06:21:52.744372+00	1	Faces	1	[{"added": {}}]	9	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
3	2025-12-10 06:22:50.609702+00	2	Big City Lights	1	[{"added": {}}]	9	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
4	2025-12-10 06:24:01.791309+00	3	KBTU Moments	1	[{"added": {}}]	9	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
5	2025-12-10 06:24:55.169304+00	3	KBTU Moments	2	[{"changed": {"fields": ["Instagram link"]}}]	9	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
6	2025-12-10 06:25:58.2119+00	4	KBTU GDG	1	[{"added": {}}]	9	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
7	2025-12-10 06:26:52.354819+00	5	Enactus KBTU	1	[{"added": {}}]	9	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
8	2025-12-10 07:34:00.071537+00	6	Student Government of KBTU	1	[{"added": {}}]	9	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
9	2025-12-10 07:38:43.135162+00	1	Muertos Night	1	[{"added": {}}]	10	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
10	2025-12-10 08:06:01.787543+00	2	Google Gemini AI Workshop: Build Your First Web App	1	[{"added": {}}]	10	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
11	2025-12-10 08:09:45.821927+00	3	Vibe-Coding Blitz Hackathon @ GDG on Campus	1	[{"added": {}}]	10	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
12	2025-12-10 08:09:58.101926+00	3	Vibe-Coding Blitz Hackathon @ GDG on Campus	2	[{"changed": {"fields": ["Tickets available"]}}]	10	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
13	2025-12-10 08:16:39.741855+00	4	Guest Lecture by Azaliya Turgunova (Marketing)	1	[{"added": {}}]	10	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
14	2025-12-10 08:23:26.087463+00	5	IT FEST Robo Competition	1	[{"added": {}}]	10	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
15	2025-12-10 08:49:49.411703+00	6	LeetCode Workshop Series 💻🚀	1	[{"added": {}}]	10	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
16	2025-12-10 10:33:38.638745+00	1	Congratulations to the finalists of the IT FEST robo Competition!🏆	1	[{"added": {}}]	8	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
17	2025-12-10 10:35:58.402999+00	2	KBTU at a meeting with rectors of higher educational institutions	1	[{"added": {}}]	8	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
18	2025-12-10 10:39:16.79292+00	3	KBTU participated in the work of EMSA on the formation of seafarers' competencies for ships using alternative fuels	1	[{"added": {}}]	8	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
19	2025-12-10 10:46:38.142537+00	4	Проект KOZ AI КБТУ-победитель в номинации AI-Sana Leaders!	1	[{"added": {}}]	8	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
20	2025-12-10 10:50:13.037326+00	5	AVC Charitable Foundation Announces Scholarship Recipients for the 2025–2026 Academic Year	1	[{"added": {}}]	8	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
21	2025-12-10 10:52:32.712738+00	1	Review object (1)	1	[{"added": {}}]	12	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
22	2025-12-10 10:55:49.293618+00	2	Review object (2)	1	[{"added": {}}]	12	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
23	2025-12-10 10:57:58.333482+00	1	Ticket object (1)	1	[{"added": {}}]	11	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
24	2025-12-10 11:44:00.812171+00	5	AVC Charitable Foundation Announces Scholarship Recipients for the 2025–2026 Academic Year	2	[]	8	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2025-12-09 16:51:47.630401+00
2	contenttypes	0002_remove_content_type_name	2025-12-09 16:51:47.634875+00
3	auth	0001_initial	2025-12-09 16:51:47.653423+00
4	auth	0002_alter_permission_name_max_length	2025-12-09 16:51:47.655355+00
5	auth	0003_alter_user_email_max_length	2025-12-09 16:51:47.656971+00
6	auth	0004_alter_user_username_opts	2025-12-09 16:51:47.658519+00
7	auth	0005_alter_user_last_login_null	2025-12-09 16:51:47.659881+00
8	auth	0006_require_contenttypes_0002	2025-12-09 16:51:47.660278+00
9	auth	0007_alter_validators_add_error_messages	2025-12-09 16:51:47.661737+00
10	auth	0008_alter_user_username_max_length	2025-12-09 16:51:47.66313+00
11	auth	0009_alter_user_last_name_max_length	2025-12-09 16:51:47.664505+00
12	auth	0010_alter_group_name_max_length	2025-12-09 16:51:47.66637+00
13	auth	0011_update_proxy_permissions	2025-12-09 16:51:47.66786+00
14	auth	0012_alter_user_first_name_max_length	2025-12-09 16:51:47.669428+00
15	api	0001_initial	2025-12-09 16:51:47.686053+00
16	admin	0001_initial	2025-12-09 16:51:47.69315+00
17	admin	0002_logentry_remove_auto_add	2025-12-09 16:51:47.695311+00
18	admin	0003_logentry_add_action_flag_choices	2025-12-09 16:51:47.697305+00
19	sessions	0001_initial	2025-12-09 16:51:47.701504+00
20	clubs	0001_initial	2025-12-09 17:52:28.914657+00
21	events	0001_initial	2025-12-09 17:52:28.921252+00
22	news	0001_initial	2025-12-09 17:52:28.925025+00
23	reviews	0001_initial	2025-12-09 17:52:28.932845+00
24	tickets	0001_initial	2025-12-09 17:52:28.9414+00
25	events	0002_alter_event_category	2025-12-10 11:28:26.527917+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
7s3dkfxp0zh2wea1xiodwzmfz8h3468a	.eJxVjDsOwjAMQO-SmUT5OA1hZOcMlWM7tIBaqZ8JcXdaqQPM7_NWLa5L166zTG3P6qK8gwIcRHsC0mBL0OcQs6618RJEQAKr029WkJ4y7C0_cLiPhsZhmfpidsUcdDa3keV1Pdy_QYdzt9XbG4WgqRFjwgg5e65M4BJDrhLF2ZTEVhFMVGwmWzF5a0GKeFdBfb436EJh:1vT293:P6vSOhEtOwbdihddlUZelLU06530wqb7iUBOpStDrV8	2025-12-23 18:09:05.294738+00
\.


--
-- Data for Name: events_event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_event (id, name, name_kk, name_ru, name_en, description, description_kk, description_ru, description_en, location, location_kk, location_ru, location_en, date, price, category, is_free, media_urls, tickets_available, created_at, club_id) FROM stdin;
1	Muertos Night	Muertos Night	Muertos Night	Muertos Night	The mysteries and rhythms of Mexico come alive this night! 🇲🇽✨\r\nGet ready to dive into the vibrant atmosphere of Muertos Night — where life and celebration blend into a whirlwind of music, color, and emotion! 🔥\r\n\r\nWhat to expect:\r\n• Enchanting decor and vibe inspired by Día de los Muertos 🌺\r\n• DJ sets and live headliner performance that will keep you dancing all night 💃\r\n• Welcome drinks and surprises at the entrance 🍹\r\n• Interactive zones, dancing, and endless energy ⚡️\r\n• Professional photo and video team capturing every unforgettable moment 📸\r\n\r\nDon’t forget your look — the more striking, the better!\r\nMuertos Night — a night when life itself lights up. ❤️‍🔥	Мексика рухы мен ырғақтары осы түні оянады! 🇲🇽✨\r\nMuertos Night — музыка, түстер мен эмоциялар тоғысқан ерекше түн! 🔥\r\n\r\nСіздерді күтеді:\r\n• Día de los Muertos стиліндегі әсерлі атмосфера мен декор 🌺\r\n• DJ-сет және хэдлайнердің тірі орындауы 💃\r\n• Welcome drinks және тосын сыйлар 🍹\r\n• Интерактивтер, би және шексіз көңіл-күй ⚡️\r\n• Әр сәтті есте қалдыратын фото және видео командасы 📸\r\n\r\nКостюмыңды ұмытпа — неғұрлым жарқын болса, соғұрлым жақсы!\r\nMuertos Night — өмірдің өзі жанып тұрған түн. ❤️‍🔥\r\n\r\n📅 Күні: 8 қараша 2025\r\n📍 Dress code: мексикалық стильдегі жарқын бейне немесе Muertos vibes элементтері бар total black 🌹	Тайны и ритмы Мексики оживают этой ночью! 🇲🇽✨\r\nПриготовьтесь окунуться в атмосферу Muertos Night — вечера, где жизнь и праздник переплетаются в вихре музыки, красок и эмоций! 🔥\r\n\r\nЧто вас ждёт:\r\n• завораживающая атмосфера в стиле Día de los Muertos с огнями, свечами и цветами 🌺\r\n• диджеи и живое выступление хэдлайнера, от которых невозможно устоять 💃\r\n• welcome-drinks и сюрпризы на входе 🍹\r\n• интерактивы, танцы и энергия до самого утра ⚡️\r\n• профессиональные фото и видео, чтобы запомнить каждую секунду этой ночи 📸\r\n\r\nНе забудь свой образ — чем эффектнее, тем лучше!\r\nMuertos Night — ночь, когда вспыхивает сама жизнь. ❤️‍🔥\r\n\r\n📅 Дата: 8 ноября 2025\r\n📍 Dress code: яркий костюм в мексиканском стиле или total black с элементами Muertos vibes 🌹	The mysteries and rhythms of Mexico come alive this night! 🇲🇽✨\r\nGet ready to dive into the vibrant atmosphere of Muertos Night — where life and celebration blend into a whirlwind of music, color, and emotion! 🔥\r\n\r\nWhat to expect:\r\n• Enchanting decor and vibe inspired by Día de los Muertos 🌺\r\n• DJ sets and live headliner performance that will keep you dancing all night 💃\r\n• Welcome drinks and surprises at the entrance 🍹\r\n• Interactive zones, dancing, and endless energy ⚡️\r\n• Professional photo and video team capturing every unforgettable moment 📸\r\n\r\nDon’t forget your look — the more striking, the better!\r\nMuertos Night — a night when life itself lights up. ❤️‍🔥	Motor	Motor	Motor	Motor	2025-11-08 18:00:00+00	7000.00	parties	f	["https://scontent.cdninstagram.com/v/t51.82787-15/567393305_18532363057033909_4962026845142912314_n.jpg?stp=dst-jpg_e35_p640x640_sh0.08_tt6&_nc_cat=104&ig_cache_key=Mzc0NjY2MDg3OTg3OTE1OTcxNQ%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6InhwaWRzLjEzNTB4MTY4Ny5zZHIuQzMifQ%3D%3D&_nc_ohc=mdhaE6o_ySAQ7kNvwF6hS4p&_nc_oc=AdkLjxvMVXEgMUz366Z_gNxeJn9-3ySBwjveb9s90bv-Z77TZDWxK4P-HroeXF_xeLk&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.cdninstagram.com&_nc_gid=NqfBcXtco8CiVsnv6iDhLw&oh=00_AfnVcBlwJuDuWWFAb5y_iXTWtm51SIheHfMifI-3TPmSqQ&oe=693EED8F"]	200	2025-12-10 07:38:43.131775+00	2
2	Google Gemini AI Workshop: Build Your First Web App	Google Gemini AI Workshop: Алғашқы веб-қолданбаңды жаса	Google Gemini AI Workshop: Создай своё первое веб-приложение	Google Gemini AI Workshop: Build Your First Web App	Join our free workshop and learn how to build your first web application using Google’s Generative AI model Gemini.\r\nWe will cover Retrieval Augmented Generation (RAG), Gemini API usage, and system prompt engineering — perfect for future projects and hackathons!	Google Gemini генеративті AI моделін қолданып, алғашқы веб-қолданба жасауға арналған тегін воркшопқа қосылыңыз.\r\nRAG технологиясы, Gemini API және prompt engineering принциптері түсіндіріледі. Хакатондар мен жобаларға өте пайдалы!	Приходи на бесплатный воркшоп и узнай, как создать своё первое веб-приложение с использованием генеративной AI-модели Google Gemini.\r\nМы разберём RAG, работу с Gemini API и системный prompt engineering. Идеально для проектов и хакатонов!	Join our free workshop and learn how to build your first web application using Google’s Generative AI model Gemini.\r\nWe will cover Retrieval Augmented Generation (RAG), Gemini API usage, and system prompt engineering — perfect for future projects and hackathons!	Room 365, KBTU	ҚБТУ, аудитория 365	КБТУ, аудитория 365	Room 365, KBTU	2025-12-11 12:00:00+00	0.00	Workshops	t	["https://instagram.fala6-1.fna.fbcdn.net/v/t51.29350-15/464420943_520190934143871_3733296970405254482_n.heic?stp=dst-jpg_e35_tt6&efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQuaW1hZ2VfdXJsZ2VuLjE0NDB4MTQ0MC5zZHIuZjI5MzUwLmRlZmF1bHRfaW1hZ2UuYzIifQ&_nc_ht=instagram.fala6-1.fna.fbcdn.net&_nc_cat=103&_nc_oc=Q6cZ2QEo_VwYq_NZUKED88gUxhBvzGYr7yGdJ0Qj0QGkI1B79Ya0AAY47HYgBdsfB9diRsc&_nc_ohc=tp-OpOGNGPgQ7kNvwG9F2xE&_nc_gid=G_KoSY5d5XAlQfHn9Nd90w&edm=AOmX9WgBAAAA&ccb=7-5&ig_cache_key=MzQ4NTI1Mjc3MDMxNzIyNDA0MA%3D%3D.3-ccb7-5&oh=00_AfmCupph8xf-7kmkNleLRIpLBqAECtuJEyDyxFXH7Og_Mw&oe=693EF191&_nc_sid=bfaa47"]	25	2025-12-10 08:06:01.78542+00	\N
3	Vibe-Coding Blitz Hackathon @ GDG on Campus	Vibe-Coding Blitz Хакатоны @ GDG on Campus	Vibe-Coding Blitz Хакатон @ GDG on Campus	Vibe-Coding Blitz Hackathon @ GDG on Campus	Ready to vibe, code, and shine? Join us for an intense mini-hackathon where creativity meets speed!\r\nYou’ll have 1.5 hours to build a project, followed by presentations, judging, and an exciting award ceremony.\r\nAgenda:\r\n⏱️ 1.5 hours of vibe-coding + project submission\r\n🎤 40 minutes of presentations & judging\r\n🏆 Awards ceremony\r\nPrizes:\r\n🏅 9 winners — Top 3 teams will be awarded!\r\nTeam Requirements:\r\n• Teams of exactly 3 members\r\n• At least 1 freshman\r\n• Maximum 1 sophomore/junior/senior\r\nNote:\r\nBring your own laptops!\r\nEveryone is welcome — especially freshmen. Don’t hesitate to join — this is your moment to shine and make your first steps in tech!	Шабыттанып, код жазып, жарқырауға дайынсың ба? Жылдамдық пен креатив тоғысатын мини-хакатонға қосыл!\r\n1.5 сағат ішінде жоба жасап, кейін презентация мен марапаттау рәсімі өтеді.\r\nБағдарлама:\r\n⏱️ 1.5 сағат кодинг + жобаны жіберу\r\n🎤 40 минут презентациялар және сараптау\r\n🏆 Марапаттау рәсімі\r\nЖүлделер:\r\n🏅 9 жеңімпаз — үздік 3 команда марапатталады!\r\nКоманда талаптары:\r\n• 3 адамнан тұратын команда\r\n• Кемінде 1 бірінші курс студенті\r\n• Максимум 1 екінші/үшінші/төртінші курс студенті\r\nЕскерту:\r\nӨз ноутбуктарыңызды әкеліңіз!\r\nБарлық студенттер қатыса алады — әсіресе бірінші курс студенттері. Бұл — жарқырауға тамаша мүмкіндік!	Готов почувствовать вайб, писать код и сиять? Присоединяйся к интенсивному мини-хакатону, где скорость встречается с креативом!\r\nУ тебя будет 1.5 часа на проект, затем презентации, судейство и церемония награждения.\r\nПрограмма:\r\n⏱️ 1.5 часа кодинга и отправка проекта\r\n🎤 40 минут презентаций и судейства\r\n🏆 Церемония награждения\r\nПризы:\r\n🏅 9 победителей — награждаются лучшие 3 команды!\r\nТребования к командам:\r\n• Команда из 3 человек\r\n• Минимум 1 первокурсник\r\n• Максимум 1 студент 2/3/4 курса\r\nПримечание:\r\nПриносите свои ноутбуки!\r\nУчаствовать могут все — особенно первокурсники. Не бойтесь — это ваш шанс проявить себя!	Ready to vibe, code, and shine? Join us for an intense mini-hackathon where creativity meets speed!\r\nYou’ll have 1.5 hours to build a project, followed by presentations, judging, and an exciting award ceremony.\r\nAgenda:\r\n⏱️ 1.5 hours of vibe-coding + project submission\r\n🎤 40 minutes of presentations & judging\r\n🏆 Awards ceremony\r\nPrizes:\r\n🏅 9 winners — Top 3 teams will be awarded!\r\nTeam Requirements:\r\n• Teams of exactly 3 members\r\n• At least 1 freshman\r\n• Maximum 1 sophomore/junior/senior\r\nNote:\r\nBring your own laptops!\r\nEveryone is welcome — especially freshmen. Don’t hesitate to join — this is your moment to shine and make your first steps in tech!	KBTU (exact room will be shared in our Telegram channel)	КБТУ (нақты аудитория Telegram-арнада жарияланады)	КБТУ (точная аудитория будет в Telegram-канале)	KBTU (exact room will be shared in our Telegram channel)	2025-09-29 12:00:00+00	0.00	Hackathons	t	["https://scontent.cdninstagram.com/v/t51.82787-15/551521511_17997395027820682_3396295733306865393_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=109&ig_cache_key=MzcyNTYyOTA1NjM2NTYyODcxMg%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6InhwaWRzLjUwMHg1MDAuc2RyLkMzIn0%3D&_nc_ohc=Xm8AXCLs7_gQ7kNvwEnvCQp&_nc_oc=AdlXdUNNyAOo2hi6kqg7tToOITu_ri_At8WVfykYS3UuRtoJGpYsPzP92j05nsoYZqQ&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.cdninstagram.com&_nc_gid=og0BAtz09XGvGjsRdGNo7g&oh=00_AfmmGu7B2fcJ4j6-LXN90VDEgwl6kWpY1RkXmHCSOn-3OA&oe=693EFAC5"]	50	2025-12-10 08:09:45.820355+00	4
4	Guest Lecture by Azaliya Turgunova (Marketing)	Қонақ лекция: «Жалықтырмайтын маркетинг» — Азалия Тургунова	Гостевая лекция: «Маркетинг, который не бесит» от Азалии Тургуновой	Guest Lecture by Azaliya Turgunova (Marketing)	Join us for a live session with Azaliya Turgunova — an expert in brand marketing and the creator of several well-known brands.\r\nShe will share real cases, practical insights, and answer your questions about modern branding and marketing.\r\nFormat: Live lecture + Q&A	Бренд-маркетинг саласының маманы Азалия Тургуновамен өтетін тікелей лекцияға қатысыңыз.\r\nОл нақты кейстермен бөлісіп, практикалық кеңестер береді және сұрақтарыңызға жауап береді.	Приходите на живую лекцию от эксперта бренд-маркетинга Азалии Тургуновой — создательницы известных брендов и специалиста с опытом работы с ALPHA BANK, MAGNUM, HYUNDAI и другими компаниями.\r\nОна поделится практическим опытом, реальными кейсами и ответит на ваши вопросы.	Join us for a live session with Azaliya Turgunova — an expert in brand marketing and the creator of several well-known brands.\r\nShe will share real cases, practical insights, and answer your questions about modern branding and marketing.\r\nFormat: Live lecture + Q&A	Location: KBTU, Room 342	Қайда: КБТУ, 342-аудитория	Где: КБТУ, аудитория 342	Location: KBTU, Room 342	2025-11-10 16:00:00+00	0.00	lectures	t	["https://scontent.cdninstagram.com/v/t51.82787-15/575926454_17980488080919615_8951670126597041355_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=107&ig_cache_key=Mzc2MTQ1OTAxNjk3NjEzNDk0Nw%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6InhwaWRzLjEwODB4MTA4MC5zZHIuQzMifQ%3D%3D&_nc_ohc=RsFf3JCZ0PwQ7kNvwFRPqWk&_nc_oc=AdlJthSXne5XXefNEyOWyRgmojGvmT1gw3-Pk5y9rMZHiwPy-bwWsJebozlLq34WkXg&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.cdninstagram.com&_nc_gid=3ZOsXgqPqkbz3BzXIkJt2Q&oh=00_AflhMJ93TadEltpSUMTs8Esr63TrH-muQR3pCwZcrgoFxg&oe=693EDF2B"]	20	2025-12-10 08:16:39.739546+00	5
5	IT FEST Robo Competition	IT FEST Robo Competition	IT FEST Robo Competition	IT FEST Robo Competition	IT FEST Robo Competition is an exciting competition in robotics and microcontroller programming aimed at popularizing technical disciplines among students in grades 8-11.\r\nParticipants will have a unique opportunity to get acquainted with the work of ESP32, deepen their knowledge of electronics and programming, as well as try their hand at creating mobile robots.\r\n\r\n, Objectives of the event\r\n\r\nPopularization of robotics among schoolchildren\r\nLearning how to work with ESP32 and mobile robots\r\nPromoting networking and mentoring ideas\r\n\r\n, Nominations and prizes\r\n\r\nNominations:\r\n\r\nThe best engineering solution\r\nThe best web interface\r\nThe best presentation\r\n\r\nMain prizes:\r\n\r\n🥇 1st place-200,000 tenge\r\n, 2nd place-150,000 tenge\r\n🥉 3rd place-100,000 tenge\r\n\r\n, The format of the event\r\n\r\nThe event will be held offline and will consist of two eventful days.:\r\n\r\nDay 1: Assembling mobile robots under the guidance of experienced mentors\r\nDay 2: Competition between teams in which participants will demonstrate their skills in robotics and programming\r\n\r\n, Terms of participation\r\n\r\nAge of participants: students in grades 8-11\r\n\r\nKnowledge and skills: experience working with Arduino, ESP32, HTML, CSS, basic knowledge of electronics, experience working with mobile robots\r\n\r\nTeam: from 2 to 3 people (10 teams are selected in total)\r\n\r\n📝 Registration\r\n\r\nFill out the participation form by following the link in the BIO (Current ITFEST-2025)	IT FEST Robo Competition-бұл 8-11 сынып оқушыларына арналған қызықты робототехника және микроконтроллерлерді бағдарламалау бойынша байқау. Қатысушылар ESP32 құрылғысымен жұмыс істеуді үйреніп, электроника және бағдарламалау саласындағы білімдерін тереңдетіп, мобильді роботтарды құрастырып көреді.\r\n\r\n🎯 Іс-шараның мақсаттары\r\n\r\nМектеп оқушылары арасында робототехниканы насихаттау\r\n\r\nESP32 және мобильді роботтармен жұмыс істеу дағдыларын үйрету\r\n\r\nНетворкинг, тәлімгерлік, және топтық жұмыс мәдениетін дамыту\r\n\r\n🏆 Номинациялар мен жүлделер\r\n\r\nНоминациялар:\r\n\r\nҮздік инженерлік шешім\r\n\r\nҮздік web-интерфейс\r\n\r\nҮздік презентация\r\n\r\nБас жүлделер:\r\n\r\n🥇 1-орын-200 000 теңге\r\n\r\n🥈 2-орын-150 000 теңге\r\n\r\n🥉 3-орын-100 000 теңге\r\n\r\n📅 Өткізу форматы\r\n\r\nОфлайн форматта, екі күндік бағдарлама:\r\n\r\n1-күн: Тәжірибелі менторлардың көмегімен мобильді роботтарды жинау\r\n2-күн: Топтар арасындағы сайыс-робототехника мен бағдарламалау дағдыларын көрсету\r\n\r\n⚙️ Қатысу шарттары\r\n\r\nЖасы: 8-11 сынып оқушылары\r\n\r\nБілімі мен дағдылары: Arduino, ESP32, HTML, CSS, электроника негіздері, мобильді роботтармен жұмыс тәжірибесі\r\n\r\nТоп: 2-3 адамнан, барлығы 10 команда іріктеледі\r\n\r\n📝 Тіркелу\r\n\r\nҚатысу үшін BIO-дағы сілтеме арқылы (ITFEST-2025 бөлімінде) тіркеу формасын толтырыңыз.	IT FEST Robo Competition-это увлекательное соревнование по робототехнике и программированию микроконтроллеров, направленное на популяризацию технических дисциплин среди школьников 8-11 классов.\r\nУчастники получат уникальную возможность познакомиться с работой ESP32, углубить свои знания в электронике и программировании, а также попробовать себя в создании мобильных роботов.\r\n\r\n🎯 Цели мероприятия\r\n\r\nПопуляризация робототехники среди школьников\r\nОбучение навыкам работы с ESP32 и мобильными роботами\r\nСодействие нетворкингу и продвижению идей менторства\r\n\r\n🏆 Номинации и призы\r\n\r\nНоминации:\r\n\r\nЛучшее инженерное решение\r\nЛучший web interface\r\nЛучшая презентация\r\n\r\nГлавные призы:\r\n\r\n🥇 1 место-200 000 тенге\r\n🥈 2 место-150 000 тенге\r\n🥉 3 место-100 000 тенге\r\n\r\n📅 Формат проведения\r\n\r\nМероприятие пройдет в офлайн-формате и будет состоять из двух насыщенных дней:\r\n\r\nДень 1: Сборка мобильных роботов под руководством опытных менторов\r\nДень 2: Соревнование между командами, в котором участники продемонстрируют свои навыки в робототехнике и программировании\r\n\r\n⚙️ Условия участия\r\n\r\nВозраст участников: школьники 8-11 классов\r\n\r\nЗнания и навыки: опыт работы с Arduino, ESP32, HTML, CSS, базовые знания электроники, опыт работы с мобильными роботами\r\n\r\nКоманда: от 2 до 3 человек (всего отбирается 10 команд)\r\n\r\n📝 Регистрация\r\n\r\nЗаполните форму для участия по ссылке в БИО (Актуальные ITFEST-2025)	IT FEST Robo Competition is an exciting competition in robotics and microcontroller programming aimed at popularizing technical disciplines among students in grades 8-11.\r\nParticipants will have a unique opportunity to get acquainted with the work of ESP32, deepen their knowledge of electronics and programming, as well as try their hand at creating mobile robots.\r\n\r\n, Objectives of the event\r\n\r\nPopularization of robotics among schoolchildren\r\nLearning how to work with ESP32 and mobile robots\r\nPromoting networking and mentoring ideas\r\n\r\n, Nominations and prizes\r\n\r\nNominations:\r\n\r\nThe best engineering solution\r\nThe best web interface\r\nThe best presentation\r\n\r\nMain prizes:\r\n\r\n🥇 1st place-200,000 tenge\r\n, 2nd place-150,000 tenge\r\n🥉 3rd place-100,000 tenge\r\n\r\n, The format of the event\r\n\r\nThe event will be held offline and will consist of two eventful days.:\r\n\r\nDay 1: Assembling mobile robots under the guidance of experienced mentors\r\nDay 2: Competition between teams in which participants will demonstrate their skills in robotics and programming\r\n\r\n, Terms of participation\r\n\r\nAge of participants: students in grades 8-11\r\n\r\nKnowledge and skills: experience working with Arduino, ESP32, HTML, CSS, basic knowledge of electronics, experience working with mobile robots\r\n\r\nTeam: from 2 to 3 people (10 teams are selected in total)\r\n\r\n📝 Registration\r\n\r\nFill out the participation form by following the link in the BIO (Current ITFEST-2025)	IITU	ХАТУ	МУИТ	IITU	2025-12-17 08:00:00+00	2000.00	offsite	f	["https://scontent.cdninstagram.com/v/t51.82787-15/582972118_18539992690050735_4694878802836690976_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=100&ig_cache_key=Mzc2ODM5NjIzOTM3ODE2NTE3NA%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6InhwaWRzLjE0NDB4MTgwMC5zZHIuQzMifQ%3D%3D&_nc_ohc=96g68DFlV_IQ7kNvwF2MkaI&_nc_oc=Adkzo9Vzpg-s5shRJ2UQvlSgwFs9je789aclj242UV7o_IHaGOvpC5nU9-W-VC2aMHbtKfdZ88jnXHLkm7K3RaMy&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.cdninstagram.com&_nc_gid=9aR3K80cawWpmI2596585Q&oh=00_Afl0Zidr1KI7PgsL5qTcIJN-Ry_ezY_6EAt5rkIkbY9twQ&oe=693F0F2E"]	30	2025-12-10 08:23:26.085699+00	6
6	LeetCode Workshop Series 💻🚀	LeetCode Workshop Series 💻🚀	LeetCode Workshop Series 💻🚀	LeetCode Workshop Series 💻🚀	Join our hands-on workshop to master Python3 🐍, solve algorithmic challenges 🧠, and prepare for MAANG interviews (Meta, Apple, Amazon, Netflix, Google) 🎯.\r\n\r\nWhy join?\r\n• Learn Python3 from scratch 🐍\r\n• Solve real-world problems 🧠\r\n• Prepare for top tech interviews 🎯\r\n• Boost your coding skills 💪\r\n• Connect with a supportive developer community 🌟\r\n\r\nLimited spots available! 🎟️\r\nAge: 16+\r\n\r\nRegister now and take the first step toward your dream job!\r\n\r\nRegistration link in bio	Python3-ті меңгеру, алгоритмдік мәселелерді шешу және MAANG (Meta, Apple, Amazon, Netflix, Google) сұхбаттарына дайындалу үшін біздің практикалық семинарымызға қосылыңыз.\r\n\r\nНеге қосылу керек?\r\n* Python3-ті нөлден үйреніңіз 🐍\r\n• Нақты мәселелерді шешіңіз 🧠\r\n• Үздік техникалық сұхбаттарға дайындалыңыз 🎯\r\n* Кодтау дағдыларын жетілдіріңіз 💪\r\n• Қолдау көрсететін әзірлеушілер қауымдастығымен байланысыңыз 🌟\r\n\r\nШектеулі орындар бар! 🎟️\r\nЖасы: 16+\r\n\r\nҚазір тіркеліп, армандаған жұмысыңызға алғашқы қадам жасаңыз!\r\n\r\nБиодағы тіркеу сілтемесі	Присоединяйтесь к нашему практическому семинару, чтобы освоить Python3 🐍, решить алгоритмические задачи 🧠 и подготовиться к собеседованиям на MAANG (Meta, Apple, Amazon, Netflix, Google) 🎯.\r\n\r\nЗачем присоединяться?\r\n• Изучать Python3 с нуля 🐍\r\n• Решать реальные задачи 🧠\r\n• Подготовьтесь к собеседованиям с ведущими специалистами в области технологий 🎯\r\n• Совершенствуйте свои навыки программирования 💪\r\n• Общайтесь с поддерживающим сообществом разработчиков 🌟\r\n\r\nКоличество мест ограничено! 🎟️\r\nВозраст: 16+\r\n\r\nЗарегистрируйтесь сейчас и сделайте первый шаг к работе своей мечты!\r\n\r\nСсылка для регистрации в био	Join our hands-on workshop to master Python3 🐍, solve algorithmic challenges 🧠, and prepare for MAANG interviews (Meta, Apple, Amazon, Netflix, Google) 🎯.\r\n\r\nWhy join?\r\n• Learn Python3 from scratch 🐍\r\n• Solve real-world problems 🧠\r\n• Prepare for top tech interviews 🎯\r\n• Boost your coding skills 💪\r\n• Connect with a supportive developer community 🌟\r\n\r\nLimited spots available! 🎟️\r\nAge: 16+\r\n\r\nRegister now and take the first step toward your dream job!\r\n\r\nRegistration link in bio	Online	Онлайн	Онлайн	Online	2025-12-23 09:00:00+00	0.00	Workshops	t	["https://scontent.cdninstagram.com/v/t51.75761-15/474329656_17971144166820682_8882288392076489731_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=108&ig_cache_key=MzU1NDE0OTkzMTA3NTIyNzMzMw%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6InhwaWRzLjEyODB4MTI4MC5zZHIuQzMifQ%3D%3D&_nc_ohc=e1fJNt46es4Q7kNvwHeI7tS&_nc_oc=Admjw75PXj0Dc-0V4neULvHvsLAPIhAGX-fpCuLZDCI4m4TW-gNHAOUNJD2--rWSG-g1MC79o71s5SI2UlXU4brN&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.cdninstagram.com&_nc_gid=LvrKwkFJ4zst9VqM1aRLkQ&oh=00_Afk4-McrAZR28WV6oBtWvZ_GbW-jQtN14ARCO74e0tTpeg&oe=693F0E96"]	50	2025-12-10 08:49:49.409412+00	4
\.


--
-- Data for Name: news_news; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.news_news (id, title, title_kk, title_ru, title_en, content, content_kk, content_ru, content_en, media_url, created_at) FROM stdin;
1	Congratulations to the finalists of the IT FEST robo Competition!🏆	It FEST robo Competition финалистерін құттықтаймыз!🏆	Поздравляем финалистов IT FEST Robo Competition!🏆	Congratulations to the finalists of the IT FEST robo Competition!🏆	We are pleased to announce that after a thorough examination of all the submitted works and the results of the qualifying round, the following teams will advance to the final of the IT FEST Robo Competition:\r\n\r\n1) TKrobotics\r\n2) Abay Digital\r\n3) Sirius\r\n4) Atom Breakers\r\n5) Tumar\r\n6) L33 Tech Force\r\n7) GPT\r\n8) Tyndex\r\n9) Miras\r\n10) Erfinder\r\n\r\nThe finalists demonstrated a high level of training, original engineering solutions and strong skills in the development of mobile robots 👏 🤝  \r\n\r\nФин the final will be held on December 5-6\r\n📍Venue: Atakent, Almaty\r\n\r\nTeams can prove themselves in roboftball, ⚽ 🤖 offer their own engineering solutions and compete for prizes 🥇 🥈 🥉  \r\n\r\nWait-the most interesting is ahead!🚀✨	Барлық ұсынылған жұмыстар мен іріктеу кезеңінің нәтижелерін мұқият тексергеннен кейін келесі командалар it FEST Robo Competition финалына өтетінін хабарлауға қуаныштымыз:\r\n\r\n1) TKrobotics\r\n2) Abay Digital\r\n3) Sirius\r\n4) Atom Breakers\r\n5) Tumar\r\n6) L33 Tech Force\r\n7) ГПТ\r\n8) Тындекс\r\n9) Miras\r\n10) Erfinder\r\n\r\nФиналистер дайындықтың жоғары деңгейін, инженерлік шешімдердің түпнұсқасын және мобильді роботтарды дамытудың мықты дағдыларын көрсетті 👏 🤝 \r\n\r\n📅Финал 5-6 желтоқсанда өтеді\r\n📍Өтетін орны: Атакент, Алматы\r\n\r\nКомандалар робофтболда өздерін көрсете алады, ⚽ 🤖 өздерінің инженерлік шешімдерін ұсына алады және жүлделі орындар үшін жарыса алады 🥇 🥈 🥉 \r\n\r\nКүте тұрыңыз-ең қызықтысы алда!🚀✨	После тщательной проверки всех представленных работ и результатов отборочного этапа рады сообщить, что в финал IT FEST Robo Competition проходят следующие команды:\r\n\r\n1) TKrobotics\r\n2) Abay Digital\r\n3) Sirius\r\n4) Atom Breakers\r\n5) Tumar\r\n6) L33 Tech Force\r\n7) ГПТ\r\n8) Тындекс\r\n9) Miras\r\n10) Erfinder\r\n\r\nФиналисты продемонстрировали высокий уровень подготовки, оригинальные инженерные решения и сильные навыки разработки мобильных роботов👏🤝\r\n\r\n📅Финал состоится 5-6 декабря\r\n📍Место проведения: Атакент, Алматы\r\n\r\nКоманды смогут проявить себя в робофутболе,⚽🤖 представить свои инженерные решения 🧠🔧 и побороться за призовые местады🥇🥈🥉\r\n\r\nСледите за обновлениям-впереди самое интересное!🚀✨	We are pleased to announce that after a thorough examination of all the submitted works and the results of the qualifying round, the following teams will advance to the final of the IT FEST Robo Competition:\r\n\r\n1) TKrobotics\r\n2) Abay Digital\r\n3) Sirius\r\n4) Atom Breakers\r\n5) Tumar\r\n6) L33 Tech Force\r\n7) GPT\r\n8) Tyndex\r\n9) Miras\r\n10) Erfinder\r\n\r\nThe finalists demonstrated a high level of training, original engineering solutions and strong skills in the development of mobile robots 👏 🤝  \r\n\r\nФин the final will be held on December 5-6\r\n📍Venue: Atakent, Almaty\r\n\r\nTeams can prove themselves in roboftball, ⚽ 🤖 offer their own engineering solutions and compete for prizes 🥇 🥈 🥉  \r\n\r\nWait-the most interesting is ahead!🚀✨	https://scontent.cdninstagram.com/v/t51.82787-15/589101804_18542248270050735_73784129765207981_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=104&ig_cache_key=Mzc3OTI2OTc5NTkyNjMxMjc3NA%3D%3D.3-ccb7-5&ccb=7-5&	2025-12-10 10:33:38.635646+00
2	KBTU at a meeting with rectors of higher educational institutions	ҚБТУ жоғары оқу орындарының ректорларымен кездесуде	КБТУ на встрече с ректорами высших учебных заведений	KBTU at a meeting with rectors of higher educational institutions	KBTU took part in a meeting between the Deputy Akim of Almaty, Abzal Nukenov, and the rectors of the city’s leading universities. The discussion focused on the development of education and scientific research, as well as strengthening the role of youth in shaping the intellectual and innovative agenda of the metropolis.\r\n\r\nSpecial attention was given to supporting student initiatives, volunteering, and environmental projects within the framework of “Taza Kazakhstan,” as well as the activities of the Council for Science and Technology under the Akim of Almaty. Following the meeting, a decision was made to establish a working group to launch new joint initiatives and enhance the city’s scientific potential.	ҚБТУ Алматы қаласы әкімінің орынбасары Абзал Нүкеновтің қаладағы жетекші жоғары оқу орындарының ректорларымен өткен кездесуіне қатысты. Кездесуде білім беру мен ғылыми зерттеулерді дамыту, сондай-ақ мегаполистің интеллектуалды және инновациялық күн тәртібін қалыптастырудағы жастардың рөлін күшейту мәселелері талқыланды.\r\n\r\nЕрекше назар студенттік бастамаларды, волонтерлікті және «Таза Қазақстан» аясындағы экологиялық жобаларды қолдауға, сондай-ақ Алматы әкімі жанындағы Ғылым және технологиялар кеңесінің жұмысына аударылды. Кездесу қорытындысы бойынша жаңа бірлескен бастамаларды іске қосу және қаланың ғылыми әлеуетін нығайту үшін жұмыс тобы құрылатын болды.	КБТУ принял участие во встрече заместителя акима Алматы Абзала Нукенова с ректорами ведущих вузов города. В центре обсуждения-развитие образования и научных исследований, а также усиление роли молодежи в формировании интеллектуальной и инновационной повестки мегаполиса.\r\n\r\nОтдельное внимание уделили поддержке студенческих инициатив, волонтерства и экологических проектов в рамках «Таза Қазақстан», а также работе Совета по науке и технологиям при акиме Алматы. По итогам встречи принято решение создать рабочую группу для запуска новых совместных инициатив и укрепления научного потенциала города.	KBTU took part in a meeting between the Deputy Akim of Almaty, Abzal Nukenov, and the rectors of the city’s leading universities. The discussion focused on the development of education and scientific research, as well as strengthening the role of youth in shaping the intellectual and innovative agenda of the metropolis.\r\n\r\nSpecial attention was given to supporting student initiatives, volunteering, and environmental projects within the framework of “Taza Kazakhstan,” as well as the activities of the Council for Science and Technology under the Akim of Almaty. Following the meeting, a decision was made to establish a working group to launch new joint initiatives and enhance the city’s scientific potential.	https://scontent.cdninstagram.com/v/t51.82787-15/589348106_18542662027050735_5843514971407999043_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=104&ig_cache_key=Mzc4MDg4OTcxNjY3ODU1NDg4Mg%3D%3D.3-ccb7-5&ccb=7-5&_n	2025-12-10 10:35:58.401557+00
3	KBTU participated in the work of EMSA on the formation of seafarers' competencies for ships using alternative fuels	ҚБТУ БАЛАМАЛЫ отынды пайдаланатын кемелер үшін теңізшілердің құзыреттілігін қалыптастыру БОЙЫНША EMSA жұмысына қатысты	КБТУ приняло участие в работе EMSA по формированию компетенций моряков для судов на альтернативных видах топлива	KBTU participated in the work of EMSA on the formation of seafarers' competencies for ships using alternative fuels	On November 21-22, 2025, representatives of Kazakhstan took part in the EMSA sessions in Lisbon, dedicated to updating the training of sailors for working with methanol, hydrogen, ammonia, fuel cells and high-voltage batteries. Kazakhstan was represented by Asylbek Tengizbayev and Ramil Biktashev.\r\n\r\nKazakhstan's position: basic knowledge on alternative fuels should be included in the basic Marine qualification, and in-depth knowledge should be issued by individual certificates. KBtu KMA teaches the main aspects of safety in working with new energy systems.\r\n\r\nThe main international debate was about whether to include these competencies in the main chapters of the STCW (II/III) or in the specialized chapter V.\r\n\r\nFor kBtu KMA, participation in EMSA is to strengthen international recognition, introduce alternative fuels into the global agenda and prepare the fleet for the transition to new technologies.\r\n\r\nThe latest Imo decisions are expected at the nearest session in the UK. KBtu and the Maritime Administration of the Republic of Kazakhstan will continue to work on bringing national training to international requirements.	2025 жылғы 21-22 қарашада Қазақстан өкілдері метанол, сутегі, аммиак, отын элементтері және жоғары вольтты батареялармен жұмыс істеу үшін теңізшілерді даярлауды жаңартуға арналған Лиссабондағы EMSA сессияларына қатысты. Қазақстанды Асылбек Теңізбаев пен Рамиль Бикташев таныстырды.\r\n\r\nҚазақстандық ұстаным: баламалы отындар бойынша базалық білім негізгі теңіз біліктілігіне енуі тиіс, ал тереңдетілген білім-жеке сертификаттармен ресімделуі тиіс. ҚБТУ ҚМА жаңа энергетикалық жүйелермен жұмыс істеу қауіпсіздігінің негізгі аспектілерін үйретуде.\r\n\r\nБасты халықаралық пікірталас осы құзыреттерді STCW (II/III) негізгі тарауларына немесе мамандандырылған V тарауға қосу-қоспау туралы болды.\r\n\r\nҚБТУ ҚМА үшін EMSA-ға қатысу-бұл халықаралық тануды нығайту, жаһандық күн тәртібіне баламалы отындарды енгізу және флоттың жаңа технологияларға көшуіне дайындық.\r\n\r\nIMO-ның соңғы шешімдері Ұлыбританиядағы ең жақын сессияда күтіледі. ҚБТУ мен ҚР теңіз әкімшілігі ұлттық дайындықты халықаралық талаптарға келтіру жөніндегі жұмысты жалғастырады.	21-22 ноября 2025 г. представители Казахстана участвовали в сессиях EMSA в Лиссабоне, посвящённых обновлению подготовки моряков для работы с метанолом, водородом, аммиаком, топливными элементами и высоковольтными батареями. Казахстан представили Асылбек Тенизбаев и Рамиль Бикташев.\r\n\r\nКазахстанская позиция: базовые знания по альтернативным топливам должны входить в основную морскую квалификацию, а углублённые-оформляться отдельными сертификатами. КМА КБТУ уже обучает ключевым аспектам безопасности работы с новыми энергетическими системами.\r\n\r\nГлавная международная дискуссия касалась того, включать ли эти компетенции в основные главы STCW (II/III) или в специализированный Chapter V. Казахстан поддержал комбинированный подход: база-в II/III, специализация-в V.\r\n\r\nДля КМА КБТУ участие в EMSA-это укрепление международного признания, включение в глобальную повестку альтернативных топлив и подготовка к переходу флота на новые технологии.\r\n\r\nОкончательные решения IMO ожидаются на ближайшей сессии в Великобритании. КБТУ и Морская администрация РК продолжат работу по приведению национальной подготовки к международным требованиям.	On November 21-22, 2025, representatives of Kazakhstan took part in the EMSA sessions in Lisbon, dedicated to updating the training of sailors for working with methanol, hydrogen, ammonia, fuel cells and high-voltage batteries. Kazakhstan was represented by Asylbek Tengizbayev and Ramil Biktashev.\r\n\r\nKazakhstan's position: basic knowledge on alternative fuels should be included in the basic Marine qualification, and in-depth knowledge should be issued by individual certificates. KBtu KMA teaches the main aspects of safety in working with new energy systems.\r\n\r\nThe main international debate was about whether to include these competencies in the main chapters of the STCW (II/III) or in the specialized chapter V.\r\n\r\nFor kBtu KMA, participation in EMSA is to strengthen international recognition, introduce alternative fuels into the global agenda and prepare the fleet for the transition to new technologies.\r\n\r\nThe latest Imo decisions are expected at the nearest session in the UK. KBtu and the Maritime Administration of the Republic of Kazakhstan will continue to work on bringing national training to international requirements.	https://scontent.cdninstagram.com/v/t51.82787-15/588963923_18541951783050735_5699111332917575861_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=107&ig_cache_key=Mzc3NzkyNTc0ODk1OTg3MDM1MA%3D%3D.3-ccb7-5&ccb=7-5&_n	2025-12-10 10:39:16.791462+00
4	Проект KOZ AI КБТУ-победитель в номинации AI-Sana Leaders!	ҚБТУ-дың KOZ AI жобасы-AI-Sana Leaders номинациясының үздігі!	Проект KOZ AI КБТУ-победитель в номинации AI-Sana Leaders!	Проект KOZ AI КБТУ-победитель в номинации AI-Sana Leaders!	KBTU’s KOZ AI Project-Winner of the AI-Sana Leaders Nomination!\r\n\r\nAI-Sana is a strategic national project aimed at introducing artificial intelligence into higher education institutions. Its main goal is to train a new generation of AI specialists for the fields of energy, agro-industry, water management, and digital management.\r\n\r\nWithin the framework of this large-scale initiative, the Kazakhstan-British Technical University’s KOZ AI project was recognized as the best in the AI-Sana Leaders nomination! The award was presented by the Minister of Science and Higher Education of the Republic of Kazakhstan, Sayasat Nurbek.\r\n\r\nProject Authors:\r\nAmitov Al'mukhamed, Kuatov Yermukhamed, Zhaksylikov Rayimbek, Adilov Amir, Kakarov Damir, Kainazarov Zhasulan, Ushtaev Asanali, Yerlan Dias, Kazbek Zhibek.\r\n\r\nThis victory is the result of the collective efforts of the KBTU team, our partners, and colleagues. Your trust has become a true spark for new ideas and a genuine testament to the pursuit of science.\r\n\r\nWith knowledge-the nation rises, with technology -the future is shaped!	AI-Sana-жасанды интеллектті жоғары оқу орындарына енгізуге бағытталған стратегиялық ұлттық жоба. Негізгі мақсаты- еліміздің энергетика, агроөнеркәсіп, су шаруашылығы мен цифрлық менеджмент салаларына жаңа буын ЖИ мамандарын даярлау.\r\n\r\nОсы ауқымды бастама аясында Қазақстан-Британ техникалық университетінің KOZ AI жобасы AI-Sana Leaders номинациясында үздік деп танылды! Марапатты ҚР Ғылым және жоғары білім министрі Саясат Нұрбек табыстады.\r\n\r\nЖоба авторлары:\r\nАмитов Альмухамед, Куатов Ермухамед, Жаксиликов Райымбек, Адилов Амир, Какаров Дамир, Кайназаров Жасулан, Уштаев Асанали, Ерлан Диас, Казбек Жибек.\r\n\r\nБұл жеңіс-ҚБТУ ұжымының, серіктестеріміз бен әріптестеріміздің ортақ еңбегінің нәтижесі. Сіздердің сенімдеріңіз-жаңа идеялардың ұшқынына, ғылымға деген талпыныстың шынайы дәлеліне айналды.\r\n\r\nБіліммен-ұлт биіктейді, технологиямен-болашақ қалыптасады!	AI-Sana-это стратегический национальный проект, направленный на внедрение искусственного интеллекта в систему высшего образования. Его основная цель-подготовка нового поколения специалистов в области ИИ для энергетики, агропромышленного комплекса, водного хозяйства и цифрового менеджмента.\r\n\r\nВ рамках этой масштабной инициативы проект KOZ AI Казахстанско-Британского технического университета был признан лучшим в номинации AI-Sana Leaders! Награду вручил министр науки и высшего образования Республики Казахстан Саясат Нурбек.\r\n\r\nАвторы проекта:\r\nАмитов Альмухамед, Куатов Ермухамед, Жаксиликов Раимбек, Адилов Амир, Какаров Дамир, Кайназаров Жасулан, Уштаев Асанали, Ерлан Диас, Казбек Жибек.\r\n\r\nЭта победа-результат совместного труда коллектива КБТУ, наших партнеров и коллег. Ваше доверие стало настоящей искрой для новых идей и подлинным свидетельством стремления к науке.\r\n\r\nЗнания возвышают нацию, технологии формируют будущее!	KBTU’s KOZ AI Project-Winner of the AI-Sana Leaders Nomination!\r\n\r\nAI-Sana is a strategic national project aimed at introducing artificial intelligence into higher education institutions. Its main goal is to train a new generation of AI specialists for the fields of energy, agro-industry, water management, and digital management.\r\n\r\nWithin the framework of this large-scale initiative, the Kazakhstan-British Technical University’s KOZ AI project was recognized as the best in the AI-Sana Leaders nomination! The award was presented by the Minister of Science and Higher Education of the Republic of Kazakhstan, Sayasat Nurbek.\r\n\r\nProject Authors:\r\nAmitov Al'mukhamed, Kuatov Yermukhamed, Zhaksylikov Rayimbek, Adilov Amir, Kakarov Damir, Kainazarov Zhasulan, Ushtaev Asanali, Yerlan Dias, Kazbek Zhibek.\r\n\r\nThis victory is the result of the collective efforts of the KBTU team, our partners, and colleagues. Your trust has become a true spark for new ideas and a genuine testament to the pursuit of science.\r\n\r\nWith knowledge-the nation rises, with technology -the future is shaped!	https://scontent.cdninstagram.com/v/t51.82787-15/573712325_18536040100050735_4363657821204013691_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=105&ig_cache_key=Mzc1NDgxMDg2MTE0ODgxNTYzNg%3D%3D.3-ccb7-5&ccb=7-5&_n	2025-12-10 10:46:38.139967+00
5	AVC Charitable Foundation Announces Scholarship Recipients for the 2025–2026 Academic Year	AVC Қайырымдылық қорының 2025-2026 оқу жылына арналған атаулы стипендия иегерлері анықталды	Определены обладатели именных стипендий Благотворительного фонда AVC на 2025-2026 учебный год	AVC Charitable Foundation Announces Scholarship Recipients for the 2025–2026 Academic Year	The AVC Charitable Foundation continues to support talented students of the Kazakh-British Technical University.\r\nFollowing the results of a competitive selection, the recipients of the AVC Named Scholarship for the 2025–2026 academic year are outstanding students who have demonstrated high academic performance, active community involvement, and a strong commitment to professional growth.\r\n\r\nAVC Scholarship Recipients:\r\n\r\n1.Sagimgeldiev Bekzat Ruslanuly, 2nd year, School of Information Technology and Engineering, Automation and Control\r\n\r\n2.Karamysov Yernar Bolatovich, 4th year, School of Chemical Engineering, Chemical Technology of Organic Substances\r\n\r\n3.Nurmagambetov Damir Bauyrzhanovich, 3rd year, School of Information Technology and Engineering, Automation and Control\r\n\r\n4.Zhenis Eldos Ruslanuly, 3rd year, School of Information Technology and Engineering, Automation and Control\r\n\r\n5.Kashimova Nazerke Nurlybekovna, 3rd year, School of Chemical Engineering, Chemical Technology of Organic Substances\r\n\r\n6.Utebaliyeva Amanel Asylbekkyzy, 2nd year, School of Information Technology and Engineering, Automation and Control\r\n\r\n7.Akhmetolla Karakat Kambarkyzy, 2nd year, School of Chemical Engineering, Chemical Technology of Organic Substances\r\n\r\nThe AVC Scholarship Program is aimed at fostering human capital and supporting the development of future engineers, scientists, and leaders of Kazakhstan.\r\nEach year, the Foundation recognizes and invests in KBTU students, contributing to their education and professional growth.\r\n\r\nCongratulations to all scholarship recipients!\r\nWe wish them inspiration, perseverance, and continued success!	AVC қайырымдылық қоры Қазақстан-Британ техникалық университетінің дарынды студенттерін қолдауды жалғастыруда.\r\nБайқау іріктеуінің нәтижелері бойынша 2025–2026 оқу жылында қордың атаулы стипендиясына жоғары академиялық жетістіктерімен, белсенді өмірлік ұстанымымен және кәсіби өсуге ұмтылысымен ерекшеленген үздік студенттер ие болды.\r\nAVC қорының стипендиаттары:\r\n\r\n1.Сагимгелдиев Бекзат Русланұлы, 2 курс, Ақпараттық технологиялар және инженерия мектебі, Автоматтандыру және басқару\r\n\r\n2.Карамысов Ернар Болатович, 4 курс, Химиялық инженерия мектебі, Органикалық заттардың химиялық технологиясы\r\n\r\n3.Нурмагамбетов Дамир Бауыржанович, 3 курс, Ақпараттық технологиялар және инженерия мектебі, Автоматтандыру және басқару\r\n\r\n4.Жеңіс Елдос Русланұлы, 3 курс, Ақпараттық технологиялар және инженерия мектебі, Автоматтандыру және басқару\r\n\r\n5.Қашимова Назерке Нурлыбекқызы, 3 курс, Химиялық инженерия мектебі, Органикалық заттардың химиялық технологиясы\r\n\r\n6.Өтебалиева Аманель Асылбекқызы, 2 курс, Ақпараттық технологиялар және инженерия мектебі, Автоматтандыру және басқару\r\n\r\n7.Ахметолла Қарақат Қамбарқызы, 2 курс, Химиялық инженерия мектебі, Органикалық заттардың химиялық технологиясы\r\n\r\nAVC стипендиялық бағдарламасы адами капиталды дамытуға және Қазақстанның болашақ инженерлері, ғалымдары мен көшбасшыларын қолдауға бағытталған.\r\nҚор жыл сайын КБТУ студенттерін марапаттап, олардың білім алуына және кәсіби дамуына үлес қосады.\r\nСтипендиаттарды шын жүректен құттықтаймыз!\r\nОларға шабыт, табандылық және жаңа жетістіктер тілейміз!	Благотворительный фонд AVC продолжает поддерживать талантливых студентов Казахстанско-Британского технического университета.\r\nПо итогам конкурсного отбора в 2025-2026 учебном году обладателями именной стипендии фонда стали лучшие студенты, продемонстрировавшие высокую академическую успеваемость, активную жизненную позицию и стремление к профессиональному росту.\r\n\r\nСтипендиаты фонда AVC:\r\n1. Сагимгелдиев Бекзат Русланулы, 2 курс, Школа информационных технологий и инженерии, Автоматизация и управление\r\n2. Карамысов Ернар Болатович, 4 курс, Школа химической инженерии, Химическая технология органических веществ\r\n3. Нурмагамбетов Дамир Бауыржанович, 3 курс, Школа информационных технологий и инженерии, Автоматизация и управление\r\n4. Жеңіс Елдос Русланұлы, 3 курс, Школа информационных технологий и инженерии, Автоматизация и управление\r\n5. Кашимова Назерке Нурлыбековна, 3 курс, Школа химической инженерии, Химическая технология органических веществ\r\n6. Утебалиева Аманель Асылбеккызы, 2 курс, Школа информационных технологий и инженерии, Автоматизация и управление\r\n7. Ахметолла Қарақат Қамбарқызы, 2 курс, Школа химической инженерии, Химическая технология органических веществ\r\n\r\nСтипендиальная программа AVC направлена на развитие человеческого капитала и поддержку будущих инженеров, учёных и лидеров Казахстана.\r\nФонд ежегодно поощряет студентов КБТУ, вкладываясь в их образование и профессиональное становление.\r\n\r\nПоздравляем стипендиатов и желаем им вдохновения, настойчивости и новых достижений!	The AVC Charitable Foundation continues to support talented students of the Kazakh-British Technical University.\r\nFollowing the results of a competitive selection, the recipients of the AVC Named Scholarship for the 2025–2026 academic year are outstanding students who have demonstrated high academic performance, active community involvement, and a strong commitment to professional growth.\r\n\r\nAVC Scholarship Recipients:\r\n\r\n1.Sagimgeldiev Bekzat Ruslanuly, 2nd year, School of Information Technology and Engineering, Automation and Control\r\n\r\n2.Karamysov Yernar Bolatovich, 4th year, School of Chemical Engineering, Chemical Technology of Organic Substances\r\n\r\n3.Nurmagambetov Damir Bauyrzhanovich, 3rd year, School of Information Technology and Engineering, Automation and Control\r\n\r\n4.Zhenis Eldos Ruslanuly, 3rd year, School of Information Technology and Engineering, Automation and Control\r\n\r\n5.Kashimova Nazerke Nurlybekovna, 3rd year, School of Chemical Engineering, Chemical Technology of Organic Substances\r\n\r\n6.Utebaliyeva Amanel Asylbekkyzy, 2nd year, School of Information Technology and Engineering, Automation and Control\r\n\r\n7.Akhmetolla Karakat Kambarkyzy, 2nd year, School of Chemical Engineering, Chemical Technology of Organic Substances\r\n\r\nThe AVC Scholarship Program is aimed at fostering human capital and supporting the development of future engineers, scientists, and leaders of Kazakhstan.\r\nEach year, the Foundation recognizes and invests in KBTU students, contributing to their education and professional growth.\r\n\r\nCongratulations to all scholarship recipients!\r\nWe wish them inspiration, perseverance, and continued success!	https://scontent.cdninstagram.com/v/t51.82787-15/573292450_18537333004050735_6382535524775981414_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=105&ig_cache_key=Mzc1OTg1NTI5NzI5MzU1NTE2Mg%3D%3D.3-ccb7-5&ccb=7-5&_n	2025-12-10 10:50:13.035625+00
\.


--
-- Data for Name: reviews_review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews_review (id, rating, comment, created_at, event_id, user_id) FROM stdin;
1	5	Я очень довольна своим опытом в Gemini Workshop! Атмосфера здесь невероятно дружелюбная и мотивирующая. Преподаватели отлично объясняют материал, всегда готовы помочь и ответить на любые вопросы. Особенно мне понравился практический подход — после каждого занятия можно сразу применять знания на практике. Благодаря этому я реально почувствовала прогресс и уверенность в своих навыках. Рекомендую всем, кто хочет эффективно учиться и развиваться	2025-12-10 10:52:32.711564+00	2	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
2	5	это просто находка для тех, кто хочет прокачать свои навыки алгоритмов и структур данных! Занятия построены очень логично: сначала объясняют концепции, затем разбирают реальные задачи, похожие на те, что встречаются на собеседованиях в топовые IT-компании. Особенно ценю возможность решать задачи вместе с наставниками — они дают ценные подсказки и объясняют оптимальные решения. После этих занятий я стал(а) увереннее в решении сложных задач и готов(а) к интервью. Настоятельно рекомендую всем, кто хочет серьёзно прокачать свои навыки программирования!	2025-12-10 10:55:49.292555+00	6	d1567ee6-72db-44fa-aa82-6925f775b601
\.


--
-- Data for Name: tickets_ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tickets_ticket (id, qrcode, paid, used, created_at, event_id, user_id) FROM stdin;
1	a219e9e9-c468-420b-ae00-7386d8f7311a	t	t	2025-12-10 10:57:58.331963+00	1	214b4d3e-2c4c-40b3-8359-ff62e3ee4e3d
\.


--
-- Name: api_customuser_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_customuser_groups_id_seq', 1, false);


--
-- Name: api_customuser_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_customuser_user_permissions_id_seq', 1, false);


--
-- Name: api_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_role_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 48, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 48, true);


--
-- Name: clubs_club_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clubs_club_id_seq', 6, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 24, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 12, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 25, true);


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_event_id_seq', 6, true);


--
-- Name: news_news_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.news_news_id_seq', 5, true);


--
-- Name: reviews_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_review_id_seq', 2, true);


--
-- Name: tickets_ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tickets_ticket_id_seq', 6, true);


--
-- PostgreSQL database dump complete
--

\unrestrict GjS3ABUgOlColtO1M2pb3b2Mzro5oKbFpLm9I7xAnsY4B845AUV1nTPJn4oY66S

