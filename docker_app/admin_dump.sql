--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Debian 17.4-1.pgdg120+2)
-- Dumped by pg_dump version 17.4 (Debian 17.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: email_address; Type: TABLE; Schema: public; Owner: forgejo
--

CREATE TABLE public.email_address (
    id bigint NOT NULL,
    uid bigint NOT NULL,
    email character varying(255) NOT NULL,
    lower_email character varying(255) NOT NULL,
    is_activated boolean,
    is_primary boolean DEFAULT false NOT NULL
);


ALTER TABLE public.email_address OWNER TO forgejo;

--
-- Name: email_address_id_seq; Type: SEQUENCE; Schema: public; Owner: forgejo
--

CREATE SEQUENCE public.email_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.email_address_id_seq OWNER TO forgejo;

--
-- Name: email_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: forgejo
--

ALTER SEQUENCE public.email_address_id_seq OWNED BY public.email_address.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: forgejo
--

CREATE TABLE public."user" (
    id bigint NOT NULL,
    lower_name character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    full_name character varying(255),
    email character varying(255) NOT NULL,
    keep_email_private boolean,
    email_notifications_preference character varying(20) DEFAULT 'enabled'::character varying NOT NULL,
    passwd character varying(255) NOT NULL,
    passwd_hash_algo character varying(255) DEFAULT 'argon2'::character varying NOT NULL,
    must_change_password boolean DEFAULT false NOT NULL,
    login_type integer,
    login_source bigint DEFAULT 0 NOT NULL,
    login_name character varying(255),
    type integer,
    location character varying(255),
    website character varying(255),
    pronouns character varying(255),
    rands character varying(32),
    salt character varying(32),
    language character varying(5),
    description character varying(255),
    created_unix bigint,
    updated_unix bigint,
    last_login_unix bigint,
    last_repo_visibility boolean,
    max_repo_creation integer DEFAULT '-1'::integer NOT NULL,
    is_active boolean,
    is_admin boolean,
    is_restricted boolean DEFAULT false NOT NULL,
    allow_git_hook boolean,
    allow_import_local boolean,
    allow_create_organization boolean DEFAULT true,
    prohibit_login boolean DEFAULT false NOT NULL,
    avatar character varying(2048) NOT NULL,
    avatar_email character varying(255) NOT NULL,
    use_custom_avatar boolean,
    normalized_federated_uri character varying(255),
    num_followers integer,
    num_following integer DEFAULT 0 NOT NULL,
    num_stars integer,
    num_repos integer,
    num_teams integer,
    num_members integer,
    visibility integer DEFAULT 0 NOT NULL,
    repo_admin_change_team_access boolean DEFAULT false NOT NULL,
    diff_view_style character varying(255) DEFAULT ''::character varying NOT NULL,
    theme character varying(255) DEFAULT ''::character varying NOT NULL,
    keep_activity_private boolean DEFAULT false NOT NULL,
    keep_pronouns_private boolean DEFAULT false NOT NULL,
    enable_repo_unit_hints boolean DEFAULT true NOT NULL
);


ALTER TABLE public."user" OWNER TO forgejo;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: forgejo
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO forgejo;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: forgejo
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: email_address id; Type: DEFAULT; Schema: public; Owner: forgejo
--

ALTER TABLE ONLY public.email_address ALTER COLUMN id SET DEFAULT nextval('public.email_address_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: forgejo
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: email_address; Type: TABLE DATA; Schema: public; Owner: forgejo
--

COPY public.email_address (id, uid, email, lower_email, is_activated, is_primary) FROM stdin;
1	1	root@gmail.com	root@gmail.com	t	t
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: forgejo
--

COPY public."user" (id, lower_name, name, full_name, email, keep_email_private, email_notifications_preference, passwd, passwd_hash_algo, must_change_password, login_type, login_source, login_name, type, location, website, pronouns, rands, salt, language, description, created_unix, updated_unix, last_login_unix, last_repo_visibility, max_repo_creation, is_active, is_admin, is_restricted, allow_git_hook, allow_import_local, allow_create_organization, prohibit_login, avatar, avatar_email, use_custom_avatar, normalized_federated_uri, num_followers, num_following, num_stars, num_repos, num_teams, num_members, visibility, repo_admin_change_team_access, diff_view_style, theme, keep_activity_private, keep_pronouns_private, enable_repo_unit_hints) FROM stdin;
1	root	root		root@gmail.com	f	enabled	3d97d6ee41272a472612a18b157bb932e6c9aef20577b4058e6590e0782cc2d9067c7f3f9aa3562ac703bdda2e49357eb280	pbkdf2$320000$50	f	0	0		0				c74d7647e355af0369cfd52665849a6d	9cc5b2064ce6513818aff82e1d77e9f8	uk-UA		1742233512	1742908462	1742908462	f	-1	t	t	f	f	f	t	f	c2525a7f58ae3776070e44c106c48e15	root@gmail.com	f		0	0	0	0	0	0	0	f		forgejo-auto	f	f	f
\.


--
-- Name: email_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: forgejo
--

SELECT pg_catalog.setval('public.email_address_id_seq', 1, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: forgejo
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: email_address email_address_pkey; Type: CONSTRAINT; Schema: public; Owner: forgejo
--

ALTER TABLE ONLY public.email_address
    ADD CONSTRAINT email_address_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: forgejo
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: IDX_email_address_uid; Type: INDEX; Schema: public; Owner: forgejo
--

CREATE INDEX "IDX_email_address_uid" ON public.email_address USING btree (uid);


--
-- Name: IDX_user_created_unix; Type: INDEX; Schema: public; Owner: forgejo
--

CREATE INDEX "IDX_user_created_unix" ON public."user" USING btree (created_unix);


--
-- Name: IDX_user_is_active; Type: INDEX; Schema: public; Owner: forgejo
--

CREATE INDEX "IDX_user_is_active" ON public."user" USING btree (is_active);


--
-- Name: IDX_user_last_login_unix; Type: INDEX; Schema: public; Owner: forgejo
--

CREATE INDEX "IDX_user_last_login_unix" ON public."user" USING btree (last_login_unix);


--
-- Name: IDX_user_updated_unix; Type: INDEX; Schema: public; Owner: forgejo
--

CREATE INDEX "IDX_user_updated_unix" ON public."user" USING btree (updated_unix);


--
-- Name: UQE_email_address_email; Type: INDEX; Schema: public; Owner: forgejo
--

CREATE UNIQUE INDEX "UQE_email_address_email" ON public.email_address USING btree (email);


--
-- Name: UQE_email_address_lower_email; Type: INDEX; Schema: public; Owner: forgejo
--

CREATE UNIQUE INDEX "UQE_email_address_lower_email" ON public.email_address USING btree (lower_email);


--
-- Name: UQE_user_lower_name; Type: INDEX; Schema: public; Owner: forgejo
--

CREATE UNIQUE INDEX "UQE_user_lower_name" ON public."user" USING btree (lower_name);


--
-- Name: UQE_user_name; Type: INDEX; Schema: public; Owner: forgejo
--

CREATE UNIQUE INDEX "UQE_user_name" ON public."user" USING btree (name);


--
-- PostgreSQL database dump complete
--

