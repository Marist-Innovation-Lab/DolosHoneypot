<?php

$dbconn = pg_connect("host=localhost port=5432 dbname=doloshp user=root")
    or die('Could not connect: ' . pg_last_error());

?>
