<?php
/**
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt
 *
 * @copyright     Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * @link          https://inter-mediator.com/
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 */
//namespace INTERMediator;

setlocale(LC_ALL, 'ja_JP', 'ja');
date_default_timezone_set('Asia/Tokyo');
// The variable pathToIM has to point the INTER-Mediator directory.
$pathToIM = "../vendor/inter-mediator/inter-mediator";   // Modify this to match your directories.
//---------------------------------------------

require_once("{$pathToIM}/INTER-Mediator.php"); // Loading INTER-Mediator and relevant libraries.

use INTERMediator\Auth\OAuthAuth;

$authObj = new OAuthAuth($_GET["state"] ?? "");
//$authObj->debugMode = true; // or comment here
//$authObj->setDoRedirect(true);
$jsCode = "";
if (!$authObj->isActive) {
    header("Content-Type: text/html; charset=UTF-8");
    echo "Missing parameters for OAuth authentication. "
        . htmlspecialchars(($_GET['error_description'] ?? "") . $authObj->errorMessages(), ENT_QUOTES, 'UTF-8');
    exit;
}
$err = "No Error";
if ($authObj->afterAuth()) { // Checking whether the authentication is successful.
    $authObj->userInfoToLogin(); // Set up user and automatic login.
    $jsCode = $authObj->javaScriptCode(); // jsCode value has to be set on the script tag element.
    if ($authObj->debugMode || strlen($authObj->errorMessages()) > 0) {
        $err = $authObj->errorMessages();
    }
    if ($authObj->isCreate()) {
        // In the case of newly logged-in, you can add any code for sending email or others.
    }
} else {
    $err = $authObj->errorMessages();
}
header("Content-Type: text/html; charset=UTF-8");
?>
<html lang="ja">
<head>
    <title>OAuth Redirected Page</title>
    <script type="text/javascript" src="../../vendor/inter-mediator/inter-mediator/INTER-Mediator.php"></script>
    <script type="text/javascript"><?php echo $jsCode; ?></script>
</head>
<body>
Provider: <?php echo htmlspecialchars($authObj->oAuthProvider(), ENT_QUOTES, 'UTF-8'); ?><br>
Status: <?php echo htmlspecialchars($err, ENT_QUOTES, 'UTF-8'); ?>
<hr/>
<p>Any other messages...</p>
</body>
</html>
