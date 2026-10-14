<?php

use INTERMediator\DB\UseSharedObjects;
use INTERMediator\DB\Extending\AfterRead;
use INTERMediator\Params;
use PragmaRX\Google2FA\Google2FA;

class RegisterAddURL extends UseSharedObjects implements AfterRead
{
    public function doAfterReadFromDB($result): ?array
    {
        $qrCodeUrl = '';
        $secret = $result[0]['secret'] ?? '';
        if($secret) {
            $serverName = Params::getParameterValue("authRealm", $_SERVER["SERVER_NAME"]);
            $google2fa = new Google2FA();
            $qrCodeUrl = $google2fa->getQRCodeUrl($serverName, $result[0]['username'], $secret);
        }
        $result[0]['qrcodeurl'] = $qrCodeUrl;
        return $result;
    }
}