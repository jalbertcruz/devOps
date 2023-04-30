--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5 (Ubuntu 17.5-1.pgdg24.04+1)

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

DROP TABLE public.a;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: a; Type: TABLE; Schema: public; Owner: duser
--

CREATE TABLE public.a (
    a character varying
);


ALTER TABLE public.a OWNER TO duser;

--
-- Data for Name: a; Type: TABLE DATA; Schema: public; Owner: duser
--

INSERT INTO public.a VALUES ('eoueou');


--
-- PostgreSQL database dump complete
--

