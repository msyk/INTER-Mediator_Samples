$DB_ENGINE = "mysql" # mysql or postgresql
$DB_NAME = "test_db"

$myDir = $PSScriptRoot
$appRootDir = Split-Path -Parent $myDir

$choice = Read-Host "Do you want to update database, type 'YES'. -->"
if ($choice -eq "YES") {
    if ($DB_ENGINE -match "mysql") {
        $schemaDir = Join-Path (Join-Path $appRootDir "lib") "MySQL_Schema"
        Push-Location $schemaDir
        try {
            cmd /c "mysql -uroot $DB_NAME < schema_update.sql"
            cmd /c "mysql -uroot $DB_NAME < schema_views.sql"
        } finally {
            Pop-Location
        }
    } elseif ($DB_ENGINE -match "postgresql") {
        $schemaDir = Join-Path (Join-Path $appRootDir "lib") "PostgreSQL_Schema"
        Push-Location $schemaDir
        try {
            psql -f schema_update.sql -h localhost $DB_NAME
            psql -f schema_views.sql -h localhost $DB_NAME
        } finally {
            Pop-Location
        }
    }
}
