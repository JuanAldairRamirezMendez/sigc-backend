# Script para migrar la base de datos a PostgreSQL en Render

# Credenciales (reemplaza con las tuyas si cambian)
$PGPASSWORD = "F7glLTxW9XTufov5U8KBchPDlHGWSRPb"
$PGHOST = "dpg-d4opfder433s73d12t7g-a.oregon-postgres.render.com"
$USER = "sigc_postgres_user"
$DB = "sigc_postgres"

# Ejecutar el script SQL
psql -h $PGHOST -U $USER -d $DB -f database/schema_postgres.sql

# Si psql no está instalado, instala PostgreSQL o usa Docker:
# docker run --rm -e PGPASSWORD=$PGPASSWORD -v ${PWD}/database/schema_postgres.sql:/schema.sql postgres psql -h $PGHOST -U $USER -d $DB -f /schema.sql