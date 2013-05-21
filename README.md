Mercator is a puzzle of countries.

Requires:
 - yaws;
 - ruby;
 - PostgreSQL.

Prepare data:<br/>
<ol>
<li>Create user "mercator":<br/>
  CREATE ROLE mercator LOGIN NOSUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION;</li>
<li>Create db "mercator":<br/>
  CREATE SCHEMA mercator AUTHORIZATION mercator;</li>
<li>Create table "Countries":<br/>
  CREATE TABLE "Countries"(
    "ID" integer NOT NULL DEFAULT nextval('countries_seq'::regclass),
    "Name" character varying(50) NOT NULL,
    "Level" character varying,
    "Polygon" character varying[],
    CONSTRAINT "CountriesID" PRIMARY KEY ("ID" )
  ) WITH (
    OIDS=FALSE
  );
  ALTER TABLE "Countries" OWNER TO mercator;</li>
<li>Run script fillDatabase.rb</li>
</ol>
