Mercator is a puzzle of countries.

Requires:
 - yaws;
 - ruby;
 - PostgreSQL.

Prepare data:<br/>

1. Create user "mercator":<br/>
<code>
  CREATE ROLE mercator LOGIN NOSUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION;
</code>

2. Create db "mercator":<br/>
<code>
  CREATE SCHEMA mercator AUTHORIZATION mercator;
</code>

3. Create table "Countries":<br/>
<code>
  CREATE TABLE "Countries"(
    "ID" integer NOT NULL DEFAULT nextval('countries_seq'::regclass),
    "Name" character varying(50) NOT NULL,
    "Level" character varying,
    "Polygon" character varying[],
    "Available" boolean,
    CONSTRAINT "CountriesID" PRIMARY KEY ("ID" )
  ) WITH (
    OIDS=FALSE
  );
  ALTER TABLE "Countries" OWNER TO mercator;
</code>

4. Run script fillDatabase.rb<

5. Check which country available.
