$DB_ENGINE = "mysql" # mysql or postgresql
$DB_NAME = "test_db"

$myDir = $PSScriptRoot
$appRootDir = Split-Path -Parent $myDir

$choice = Read-Host "Do you want to create database (initializing database), type 'YES'. -->"
if ($choice -eq "YES") {
    if ($DB_ENGINE -match "mysql") {
        $schemaDir = Join-Path (Join-Path $appRootDir "lib") "MySQL_Schema"
        Push-Location $schemaDir
        try {
            cmd /c 'mysql -uroot -p < schema_basic.sql'
            cmd /c "mysql -uroot -p $DB_NAME < schema_views.sql"
            cmd /c "mysql -uroot -p $DB_NAME < schema_initial_data.sql"
        } finally {
            Pop-Location
        }
    } elseif ($DB_ENGINE -match "postgresql") {
        $schemaDir = Join-Path (Join-Path $appRootDir "lib") "PostgreSQL_Schema"
        Push-Location $schemaDir
        try {
            psql --quiet -c "create database $DB_NAME;" -h localhost postgres
            psql --quiet -f schema_basic.sql -h localhost $DB_NAME
            psql --quiet -f schema_views.sql -h localhost $DB_NAME
            psql --quiet -f schema_initial_data.sql -h localhost $DB_NAME
        } finally {
            Pop-Location
        }
    }
}
