--
-- PostgreSQL database cluster dump
--

-- Started on 2014-01-09 17:11:02 MSK

\connect postgres

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE mercator;
ALTER ROLE mercator WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md5028783a1817e48ba1bb7a8c47f24aaf3' VALID UNTIL 'infinity';






--
-- Database creation
--

CREATE DATABASE mercator WITH TEMPLATE = template0 OWNER = mercator;

\connect mercator

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.9
-- Dumped by pg_dump version 9.1.11
-- Started on 2014-01-09 17:11:05 MSK

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 22990)
-- Name: mercator; Type: SCHEMA; Schema: -; Owner: mercator
--

CREATE SCHEMA mercator;


ALTER SCHEMA mercator OWNER TO mercator;

--
-- TOC entry 163 (class 3079 OID 11677)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 1899 (class 0 OID 0)
-- Dependencies: 163
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = mercator, pg_catalog;

--
-- TOC entry 161 (class 1259 OID 16387)
-- Dependencies: 5
-- Name: maps_seq; Type: SEQUENCE; Schema: mercator; Owner: mercator
--

CREATE SEQUENCE maps_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mercator.maps_seq OWNER TO mercator;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 162 (class 1259 OID 16392)
-- Dependencies: 1783 1784 1785 1786 5
-- Name: maps; Type: TABLE; Schema: mercator; Owner: mercator; Tablespace: 
--

CREATE TABLE maps (
    id integer DEFAULT nextval('maps_seq'::regclass) NOT NULL,
    table_name character varying(15) NOT NULL,
    name character varying(15) NOT NULL,
    center point DEFAULT point((25)::double precision, ((-25))::double precision) NOT NULL,
    default_position point DEFAULT point((25)::double precision, ((-25))::double precision) NOT NULL,
    zoom integer DEFAULT 2 NOT NULL
);


ALTER TABLE mercator.maps OWNER TO mercator;

--
-- TOC entry 1891 (class 0 OID 16392)
-- Dependencies: 162 1892
-- Data for Name: maps; Type: TABLE DATA; Schema: mercator; Owner: mercator
--

COPY maps (id, table_name, name, center, default_position, zoom) FROM stdin;
\.


--
-- TOC entry 1900 (class 0 OID 0)
-- Dependencies: 161
-- Name: maps_seq; Type: SEQUENCE SET; Schema: mercator; Owner: mercator
--

SELECT pg_catalog.setval('maps_seq', 1, false);


--
-- TOC entry 1788 (class 2606 OID 16396)
-- Dependencies: 162 162 1893
-- Name: maps_pk; Type: CONSTRAINT; Schema: mercator; Owner: mercator; Tablespace: 
--

ALTER TABLE ONLY maps
    ADD CONSTRAINT maps_pk PRIMARY KEY (id);


--
-- TOC entry 1898 (class 0 OID 0)
-- Dependencies: 5
-- Name: mercator; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA mercator FROM mercator;
REVOKE ALL ON SCHEMA mercator FROM postgres;
GRANT ALL ON SCHEMA mercator TO postgres;
GRANT ALL ON SCHEMA mercator TO mercator;


-- Completed on 2014-01-09 17:11:22 MSK

--
-- PostgreSQL database cluster dump complete
--

