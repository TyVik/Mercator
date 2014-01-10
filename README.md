Mercator is a puzzle of countries.

Requires:
 - yaws;
 - ruby;
 - PostgreSQL.

Prepare data:<br/>

1. Create database with script data/mercator.sql<br/>

2. Import kml files with data/kmlImporter.rb

3. Check which regions available for each table map_*.

4. Run "make" in root directory. YAWS "ebin_dir" should include "ebin" directory.
