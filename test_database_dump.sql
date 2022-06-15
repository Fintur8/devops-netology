--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Debian 13.7-1.pgdg110+1)
-- Dumped by pg_dump version 13.7 (Debian 13.7-1.pgdg110+1)

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

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer
)
PARTITION BY RANGE (price);


ALTER TABLE public.orders OWNER TO postgres;

SET default_table_access_method = heap;

--
-- Name: orders_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_1 (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer
);
ALTER TABLE ONLY public.orders ATTACH PARTITION public.orders_1 FOR VALUES FROM (499) TO (9999999);


ALTER TABLE public.orders_1 OWNER TO postgres;

--
-- Name: orders_2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_2 (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer
);
ALTER TABLE ONLY public.orders ATTACH PARTITION public.orders_2 FOR VALUES FROM (0) TO (499);


ALTER TABLE public.orders_2 OWNER TO postgres;

--
-- Name: orders_inh; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_inh (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer
);


ALTER TABLE public.orders_inh OWNER TO postgres;

--
-- Name: orders_inh_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_inh_1 (
    CONSTRAINT orders_inh_1_price_check CHECK ((price > 499))
)
INHERITS (public.orders_inh);


ALTER TABLE public.orders_inh_1 OWNER TO postgres;

--
-- Name: orders_inh_2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_inh_2 (
    CONSTRAINT orders_inh_2_price_check CHECK ((price <= 499))
)
INHERITS (public.orders_inh);


ALTER TABLE public.orders_inh_2 OWNER TO postgres;

--
-- Data for Name: orders_1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_1 (id, title, price) FROM stdin;
2	My little database	500
6	WAL never lies	900
7	Me and my bash-pet	499
8	Dbiezdmin	501
\.


--
-- Data for Name: orders_2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_2 (id, title, price) FROM stdin;
1	War and peace	100
3	Adventure psql time	300
4	Server gravity falls	300
5	Log gossips	123
\.


--
-- Data for Name: orders_inh; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_inh (id, title, price) FROM stdin;
\.


--
-- Data for Name: orders_inh_1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_inh_1 (id, title, price) FROM stdin;
2	My little database	500
6	WAL never lies	900
8	Dbiezdmin	501
\.


--
-- Data for Name: orders_inh_2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_inh_2 (id, title, price) FROM stdin;
1	War and peace	100
3	Adventure psql time	300
4	Server gravity falls	300
5	Log gossips	123
7	Me and my bash-pet	499
\.


--
-- Name: orders_inh insr_1; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE insr_1 AS
    ON INSERT TO public.orders_inh
   WHERE (new.price > 499) DO INSTEAD  INSERT INTO public.orders_inh_1 (id, title, price)
  VALUES (new.id, new.title, new.price);


--
-- Name: orders_inh insr_2; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE insr_2 AS
    ON INSERT TO public.orders_inh
   WHERE (new.price <= 499) DO INSTEAD  INSERT INTO public.orders_inh_2 (id, title, price)
  VALUES (new.id, new.title, new.price);


--
-- PostgreSQL database dump complete
--

