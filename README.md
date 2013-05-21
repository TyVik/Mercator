Mercator is a puzzle of countries.

Requires:
 - yaws;
 - ruby;
 - PostgreSQL.

Prepare data:
1. Create user "mercator":
  CREATE ROLE mercator LOGIN NOSUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION;
2. Create db "mercator":
  CREATE SCHEMA mercator AUTHORIZATION mercator;
3. Create table "Countries":
  CREATE TABLE "Countries"(
    "ID" integer NOT NULL DEFAULT nextval('countries_seq'::regclass),
    "Name" character varying(50) NOT NULL,
    "Level" character varying,
    "Polygon" character varying[],
    CONSTRAINT "CountriesID" PRIMARY KEY ("ID" )
  ) WITH (
    OIDS=FALSE
  );
  ALTER TABLE "Countries" OWNER TO mercator;
4. Run script fillDatabase.rb
