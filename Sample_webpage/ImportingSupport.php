<?php

use INTERMediator\DB\Extending\AfterCreate;
use INTERMediator\DB\Extending\AfterImport;
use INTERMediator\DB\Extending\BeforeCreate;
use INTERMediator\DB\Extending\BeforeImport;
use INTERMediator\DB\Logger;
use INTERMediator\DB\UseSharedObjects;

class ImportingSupport extends UseSharedObjects implements BeforeImport, BeforeCreate, AfterImport, AfterCreate
{

    public function doBeforeImportToDB(): mixed
    {
        Logger::getInstance()->setDebugMessage("Calling ImportingSupport::doBeforeImportToDB");
    }

    public function doBeforeCreateToDB(): mixed
    {
        Logger::getInstance()->setDebugMessage("Calling ImportingSupport::doBeforeCreateToDB");
    }

    public function doAfterCreateToDB($result): ?array
    {
        Logger::getInstance()->setDebugMessage("Calling ImportingSupport::doAfterCreateToDB:" . var_export($result, true));
        return $result;
    }

    public function doAfterImportToDB($result): ?array
    {
        Logger::getInstance()->setDebugMessage("Calling ImportingSupport::doAfterImportToDB:" . var_export($result, true));
        return $result;
    }
}