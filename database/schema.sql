--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: diplomacy; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA diplomacy;


ALTER SCHEMA diplomacy OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = diplomacy, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: faction; Type: TABLE; Schema: diplomacy; Owner: postgres; Tablespace:
--

CREATE TABLE faction (
    id integer NOT NULL,
    name character varying,
    gameid integer,
    color character varying,
    player integer
);


ALTER TABLE diplomacy.faction OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: faction_equal_procedure(diplomacy.faction, diplomacy.faction); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION faction_equal_procedure(diplomacy.faction, diplomacy.faction) RETURNS boolean
LANGUAGE sql
AS $_$SELECT $1.id = $2.id;$_$;


ALTER FUNCTION public.faction_equal_procedure(diplomacy.faction, diplomacy.faction) OWNER TO postgres;

--
-- Name: get_order_of_type(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_order_of_type(gameid integer, type integer) RETURNS TABLE(orderid integer)
LANGUAGE sql
AS $$SELECT unitorder.id FROM diplomacy.unit, diplomacy.unitorder, diplomacy.ordertype, diplomacy.faction WHERE faction.gameid = gameId AND unit.factionid = faction.id AND unit.curorder = unitorder.id AND unitorder.type = type$$;


ALTER FUNCTION public.get_order_of_type(gameid integer, type integer) OWNER TO postgres;

--
-- Name: get_orders_on(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_orders_on(locationid integer, type integer) RETURNS TABLE(orderid integer)
LANGUAGE sql
AS $$SELECT unitorder.id AS orderid FROM diplomacy.unitorder WHERE unitorder.target = locationid AND unitorder.type = type;$$;


ALTER FUNCTION public.get_orders_on(locationid integer, type integer) OWNER TO postgres;

--
-- Name: get_origin(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_origin(unitid integer) RETURNS TABLE(unitlocation integer)
LANGUAGE sql
AS $$SELECT unit.location AS unitlocation FROM diplomacy.unit WHERE unit.id = unitid;$$;


ALTER FUNCTION public.get_origin(unitid integer) OWNER TO postgres;

--
-- Name: get_unit_at(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_unit_at(locationid integer) RETURNS TABLE(unitid integer)
LANGUAGE sql
AS $$SELECT unit.id FROM diplomacy.unit WHERE unit.location = locationId$$;


ALTER FUNCTION public.get_unit_at(locationid integer) OWNER TO postgres;

--
-- Name: get_units(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_units(gameid integer) RETURNS TABLE(faction_id integer, unit_id integer)
LANGUAGE sql
AS $$SELECT unit.factionid AS faction_id, unit.id AS unit_id FROM diplomacy.unit, diplomacy.faction WHERE faction.id = unit.factionid AND faction.gameid = gameId;$$;


ALTER FUNCTION public.get_units(gameid integer) OWNER TO postgres;

--
-- Name: loc_is_empty(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION loc_is_empty(locationid integer) RETURNS boolean
LANGUAGE plpgsql
AS $$BEGIN IF locationid = ANY(SELECT unit.location FROM diplomacy.unit) THEN RETURN false; ELSE RETURN true; END IF; end;$$;


ALTER FUNCTION public.loc_is_empty(locationid integer) OWNER TO postgres;

SET search_path = diplomacy, pg_catalog;

--
-- Name: color; Type: TABLE; Schema: diplomacy; Owner: postgres; Tablespace:
--

CREATE TABLE color (
    name character varying NOT NULL,
    r integer NOT NULL,
    g integer NOT NULL,
    b integer NOT NULL
);


ALTER TABLE diplomacy.color OWNER TO postgres;

--
-- Name: faction_id_seq; Type: SEQUENCE; Schema: diplomacy; Owner: postgres
--

CREATE SEQUENCE faction_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE diplomacy.faction_id_seq OWNER TO postgres;

--
-- Name: faction_id_seq; Type: SEQUENCE OWNED BY; Schema: diplomacy; Owner: postgres
--

ALTER SEQUENCE faction_id_seq OWNED BY faction.id;


--
-- Name: game; Type: TABLE; Schema: diplomacy; Owner: postgres; Tablespace:
--

CREATE TABLE game (
    gameid integer NOT NULL
);


ALTER TABLE diplomacy.game OWNER TO postgres;

--
-- Name: game_gameid_seq; Type: SEQUENCE; Schema: diplomacy; Owner: postgres
--

CREATE SEQUENCE game_gameid_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE diplomacy.game_gameid_seq OWNER TO postgres;

--
-- Name: game_gameid_seq; Type: SEQUENCE OWNED BY; Schema: diplomacy; Owner: postgres
--

ALTER SEQUENCE game_gameid_seq OWNED BY game.gameid;


--
-- Name: location; Type: TABLE; Schema: diplomacy; Owner: postgres; Tablespace:
--

CREATE TABLE location (
    xpos integer NOT NULL,
    ypos integer NOT NULL,
    ispoi boolean NOT NULL,
    id integer NOT NULL,
    type integer,
    factionid integer
);


ALTER TABLE diplomacy.location OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: diplomacy; Owner: postgres
--

CREATE SEQUENCE location_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE diplomacy.location_id_seq OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: diplomacy; Owner: postgres
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


--
-- Name: loctype; Type: TABLE; Schema: diplomacy; Owner: postgres; Tablespace:
--

CREATE TABLE loctype (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE diplomacy.loctype OWNER TO postgres;

--
-- Name: ordertype; Type: TABLE; Schema: diplomacy; Owner: postgres; Tablespace:
--

CREATE TABLE ordertype (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE diplomacy.ordertype OWNER TO postgres;

--
-- Name: player; Type: TABLE; Schema: diplomacy; Owner: postgres; Tablespace:
--

CREATE TABLE player (
    firstname character varying,
    lastname character varying,
    id integer NOT NULL
);


ALTER TABLE diplomacy.player OWNER TO postgres;

--
-- Name: player_id_seq; Type: SEQUENCE; Schema: diplomacy; Owner: postgres
--

CREATE SEQUENCE player_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE diplomacy.player_id_seq OWNER TO postgres;

--
-- Name: player_id_seq; Type: SEQUENCE OWNED BY; Schema: diplomacy; Owner: postgres
--

ALTER SEQUENCE player_id_seq OWNED BY player.id;


--
-- Name: testunit; Type: TABLE; Schema: diplomacy; Owner: postgres; Tablespace:
--

CREATE TABLE testunit (
    id integer NOT NULL,
    faction_id integer
);


ALTER TABLE diplomacy.testunit OWNER TO postgres;

--
-- Name: testunit_id_seq; Type: SEQUENCE; Schema: diplomacy; Owner: postgres
--

CREATE SEQUENCE testunit_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE diplomacy.testunit_id_seq OWNER TO postgres;

--
-- Name: testunit_id_seq; Type: SEQUENCE OWNED BY; Schema: diplomacy; Owner: postgres
--

ALTER SEQUENCE testunit_id_seq OWNED BY testunit.id;


--
-- Name: unit; Type: TABLE; Schema: diplomacy; Owner: postgres; Tablespace:
--

CREATE TABLE unit (
    id integer NOT NULL,
    isnaval boolean,
    location integer,
    curorder integer,
    factionid integer
);


ALTER TABLE diplomacy.unit OWNER TO postgres;

--
-- Name: unit_id_seq; Type: SEQUENCE; Schema: diplomacy; Owner: postgres
--

CREATE SEQUENCE unit_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE diplomacy.unit_id_seq OWNER TO postgres;

--
-- Name: unit_id_seq; Type: SEQUENCE OWNED BY; Schema: diplomacy; Owner: postgres
--

ALTER SEQUENCE unit_id_seq OWNED BY unit.id;


--
-- Name: unitorder; Type: TABLE; Schema: diplomacy; Owner: postgres; Tablespace:
--

CREATE TABLE unitorder (
    id integer NOT NULL,
    type integer,
    target integer,
    secondarytarget integer
);


ALTER TABLE diplomacy.unitorder OWNER TO postgres;

--
-- Name: unitorder_id_seq; Type: SEQUENCE; Schema: diplomacy; Owner: postgres
--

CREATE SEQUENCE unitorder_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE diplomacy.unitorder_id_seq OWNER TO postgres;

--
-- Name: unitorder_id_seq; Type: SEQUENCE OWNED BY; Schema: diplomacy; Owner: postgres
--

ALTER SEQUENCE unitorder_id_seq OWNED BY unitorder.id;


--
-- Name: neighbor; Type: TABLE; Schema: diplomacy; Owner: postgres
--

CREATE TABLE neighbor(
    locida INTEGER NOT NULL,
    locidb INTEGER NOT NULL,
    UNIQUE (locida, locidb),
    PRIMARY KEY(locida, locidb)
);

ALTER TABLE diplomacy.neighbor OWNER TO postgres;


--
-- Name: id; Type: DEFAULT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY faction ALTER COLUMN id SET DEFAULT nextval('faction_id_seq'::regclass);


--
-- Name: gameid; Type: DEFAULT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY game ALTER COLUMN gameid SET DEFAULT nextval('game_gameid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY player ALTER COLUMN id SET DEFAULT nextval('player_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY testunit ALTER COLUMN id SET DEFAULT nextval('testunit_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY unit ALTER COLUMN id SET DEFAULT nextval('unit_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY unitorder ALTER COLUMN id SET DEFAULT nextval('unitorder_id_seq'::regclass);


--
-- Data for Name: color; Type: TABLE DATA; Schema: diplomacy; Owner: postgres
--

COPY color (name, r, g, b) FROM stdin;
red	255	0	0
green	0	255	0
blue	0	0	255
white	255	255	255
\.


-- --
-- -- Data for Name: faction; Type: TABLE DATA; Schema: diplomacy; Owner: postgres
-- --
--
-- COPY faction (id, name, gameid, color, player) FROM stdin;
-- 2	Germany	2	red	1
-- 3	United States	2	green	3
-- \.
--
--
-- --
-- -- Name: faction_id_seq; Type: SEQUENCE SET; Schema: diplomacy; Owner: postgres
-- --
--
-- SELECT pg_catalog.setval('faction_id_seq', 3, true);
--
--
-- --
-- -- Data for Name: game; Type: TABLE DATA; Schema: diplomacy; Owner: postgres
-- --
--
-- COPY game (gameid) FROM stdin;
-- 1
-- 2
-- 3
-- \.
--
--
-- --
-- -- Name: game_gameid_seq; Type: SEQUENCE SET; Schema: diplomacy; Owner: postgres
-- --
--
-- SELECT pg_catalog.setval('game_gameid_seq', 4, true);
--
--
-- --
-- -- Data for Name: location; Type: TABLE DATA; Schema: diplomacy; Owner: postgres
-- --
--
-- COPY location (xpos, ypos, ispoi, id, type, facitonid) FROM stdin;
-- 0	0	f	10	1	2
-- \.
--
--
-- --
-- -- Name: location_id_seq; Type: SEQUENCE SET; Schema: diplomacy; Owner: postgres
-- --
--
-- SELECT pg_catalog.setval('location_id_seq', 10, true);
--
--
-- --
-- -- Data for Name: loctype; Type: TABLE DATA; Schema: diplomacy; Owner: postgres
-- --

COPY loctype (id, name) FROM stdin;
1	landlocked
2	coast
3	ocean
\.

--
-- Data for Name: ordertype; Type: TABLE DATA; Schema: diplomacy; Owner: postgres
--

COPY ordertype (id, name) FROM stdin;
1	Attack
2	Support
3	Defend
4	MoveOrder
5	Stay
\.


--
-- Data for Name: player; Type: TABLE DATA; Schema: diplomacy; Owner: postgres
--

COPY player (firstname, lastname, id) FROM stdin;
Joe	Schmoe	1
Charles	Winston	2
Calamity	Janet	3
\.


--
-- Name: player_id_seq; Type: SEQUENCE SET; Schema: diplomacy; Owner: postgres
--

SELECT pg_catalog.setval('player_id_seq', 3, true);


-- --
-- -- Data for Name: testunit; Type: TABLE DATA; Schema: diplomacy; Owner: postgres
-- --
--
-- COPY testunit (id, faction_id) FROM stdin;
-- 1	\N
-- \.
--
--
-- --
-- -- Name: testunit_id_seq; Type: SEQUENCE SET; Schema: diplomacy; Owner: postgres
-- --
--
-- SELECT pg_catalog.setval('testunit_id_seq', 1, false);
--
--
-- --
-- -- Data for Name: unit; Type: TABLE DATA; Schema: diplomacy; Owner: postgres
-- --
--
-- COPY unit (id, isnaval, location, curorder, factionid) FROM stdin;
-- 8	f	10	\N	2
-- \.
--
--
-- --
-- -- Name: unit_id_seq; Type: SEQUENCE SET; Schema: diplomacy; Owner: postgres
-- --
--
-- SELECT pg_catalog.setval('unit_id_seq', 8, true);
--
--
-- --
-- -- Data for Name: unitorder; Type: TABLE DATA; Schema: diplomacy; Owner: postgres
-- --
--
-- COPY unitorder (id, type, target) FROM stdin;
-- 3	1	10
-- \.
--
--
-- --
-- -- Name: unitorder_id_seq; Type: SEQUENCE SET; Schema: diplomacy; Owner: postgres
-- --
--
-- SELECT pg_catalog.setval('unitorder_id_seq', 3, true);


--
-- Name: color_pkey; Type: CONSTRAINT; Schema: diplomacy; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY color
    ADD CONSTRAINT color_pkey PRIMARY KEY (name);


--
-- Name: faction_pkey; Type: CONSTRAINT; Schema: diplomacy; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY faction
    ADD CONSTRAINT faction_pkey PRIMARY KEY (id);


--
-- Name: game_pkey; Type: CONSTRAINT; Schema: diplomacy; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY game
    ADD CONSTRAINT game_pkey PRIMARY KEY (gameid);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: diplomacy; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: loctype_pkey; Type: CONSTRAINT; Schema: diplomacy; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY loctype
    ADD CONSTRAINT loctype_pkey PRIMARY KEY (id);


--
-- Name: ordertype_pkey; Type: CONSTRAINT; Schema: diplomacy; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY ordertype
    ADD CONSTRAINT ordertype_pkey PRIMARY KEY (id);


--
-- Name: player_pkey; Type: CONSTRAINT; Schema: diplomacy; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY player
    ADD CONSTRAINT player_pkey PRIMARY KEY (id);


--
-- Name: testunit_pkey; Type: CONSTRAINT; Schema: diplomacy; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY testunit
    ADD CONSTRAINT testunit_pkey PRIMARY KEY (id);


--
-- Name: unit_pkey; Type: CONSTRAINT; Schema: diplomacy; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (id);


--
-- Name: unitorder_pkey; Type: CONSTRAINT; Schema: diplomacy; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY unitorder
    ADD CONSTRAINT unitorder_pkey PRIMARY KEY (id);


--
-- Name: curorder; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY unit
    ADD CONSTRAINT curorder FOREIGN KEY (curorder) REFERENCES unitorder(id);


--
-- Name: faction_color_fkey; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY faction
    ADD CONSTRAINT faction_color_fkey FOREIGN KEY (color) REFERENCES color(name);


--
-- Name: faction_player_fkey; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY faction
    ADD CONSTRAINT faction_player_fkey FOREIGN KEY (player) REFERENCES player(id);


--
-- Name: factionid; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY unit
    ADD CONSTRAINT factionid FOREIGN KEY (factionid) REFERENCES faction(id);


--
-- Name: gameid; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY faction
    ADD CONSTRAINT gameid FOREIGN KEY (gameid) REFERENCES game(gameid);


--
-- Name: location; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY unit
    ADD CONSTRAINT location FOREIGN KEY (location) REFERENCES location(id);


--
-- Name: owner; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY location
    ADD CONSTRAINT factionid FOREIGN KEY (factionid) REFERENCES faction(id);


--
-- Name: target; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY unitorder
    ADD CONSTRAINT target FOREIGN KEY (target) REFERENCES location(id);


--
-- Name: testunit_faction_id_fkey; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY testunit
    ADD CONSTRAINT testunit_faction_id_fkey FOREIGN KEY (faction_id) REFERENCES faction(id);


--
-- Name: type; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY location
    ADD CONSTRAINT type FOREIGN KEY (type) REFERENCES loctype(id) MATCH FULL;


--
-- Name: type; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY unitorder
    ADD CONSTRAINT type FOREIGN KEY (type) REFERENCES ordertype(id);


--
-- Name: neighbor; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY neighbor
    ADD CONSTRAINT locida FOREIGN KEY (locida) REFERENCES location(id);

--
-- Name: neighbor; Type: FK CONSTRAINT; Schema: diplomacy; Owner: postgres
--

ALTER TABLE ONLY neighbor
    ADD CONSTRAINT locidb FOREIGN KEY (locidb) REFERENCES location(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
