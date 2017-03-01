<?php
require ("connect.php");

date_default_timezone_set('America/New_York');
list($usec, $sec) = explode(' ', microtime());
error_reporting(error_reporting() & ~E_NOTICE);


function escapeStringPost($postVar)
{
	$escapedPostVar = pg_escape_string(stripslashes(escapeshellcmd(htmlentities(trim($postVar)))));
	return $escapedPostVar;
}

// Post Variables

$username = escapeStringPost($_POST['usernames']);
$password = escapeStringPost($_POST['passwords']);
$browserInfo = escapeStringPost($_POST['browser']);
$ports = escapeStringPost($_POST['port']);
$osVer = escapeStringPost($_POST['os']);
$usec = str_replace("0.", ".", $usec);
$ip = $_SERVER['REMOTE_ADDR'];
$port = $_SERVER['REMOTE_PORT'];
$HPID = getenv('HPID');

$timestamp = date('Y-m-d');
$timestamp2 = date('H:i:s', $sec) . $usec . date('P');
$offset = date('P');
$timestamps = $timestamp . "T" . $timestamp2;

$hostname = gethostbyaddr($_SERVER['REMOTE_ADDR']);
$storedUsername;
$storedPassword;
$storedAttempts;
$storedUID;
$grabUserinfo = pg_query($dbconn, "SELECT * FROM userinfo WHERE username='$username' AND password='$password'");


while ($row = pg_fetch_assoc($grabUserinfo))
{
	$storedUsername = $row['username'];
	$storedPassword = $row['password'];
	$storedAttempts = $row['infoattempts'];
	$storedUID = $row['uid'];
}

if ($username != $storedUsername && $password != $storedPassword)
{
	$insertUser = pg_query($dbconn, "INSERT INTO userinfo (username, password, infoattempts) VALUES ('$username','$password',1)");
	$grabUID = pg_query($dbconn, "SELECT uid FROM userinfo ORDER BY uid DESC LIMIT 1");

	while ($row = pg_fetch_assoc($grabUID))
	{
		$lastUID = $row['uid'];
	}

	$insertAttempts = pg_query($dbconn, "INSERT INTO loginattempts (uid,ip_address) VALUES ('$lastUID', '$ip')");
}
else
{
	$storedAttempts++;
	$insertNewUser = pg_query($dbconn, "UPDATE userinfo SET infoattempts='$storedAttempts' WHERE username='$username' AND password='$password'");
	$insertAttempts = pg_query($dbconn, "INSERT INTO loginattempts (uid,ip_address) VALUES ('$storedUID', '$ip')");
}


//error_log("$timestamps dolos SDN-22[0000]: IP: $ip SDNLog: Username: $username Password: $password ; Client protocol version $browserInfo; client software version $osVer;Remote port: $port; Local port: $ports; \n", 3, "/var/log/dolos_messages");

openlog('SDN', LOG_PID, LOG_AUTH);
syslog(LOG_INFO, "HPID: $HPID IP: $ip Local Port: $ports Username: $username Password: $password \n");
syslog(LOG_INFO, "Attack From: $ip; Client protocol version $browserInfo; client software version $osVer; Remote port: $port; Local port: $ports \n");
?>
