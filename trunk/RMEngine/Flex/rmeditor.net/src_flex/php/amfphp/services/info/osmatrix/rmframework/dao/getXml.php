<?php
	$xml = simplexml_load_file('config.xml');
	
	// echo "huhj";
	echo $xml->asXML();
	
?>