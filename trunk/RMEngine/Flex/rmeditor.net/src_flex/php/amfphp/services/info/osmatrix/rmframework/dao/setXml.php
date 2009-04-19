<?php
	$xmlStr = '
	<?xml version="1.0" encoding="utf-8"?>
		<config>
			<mainviews default="flex">
				<view id="flex" type="flex" url="MainFlex.swf" skin="css/OSX/OSX.swf"/>
				<view id="flash" type="flash" url="MainFlash.swf" skin=""/>
				<view id="pbank" type="flash" url="PBank.swf" skin=""/>	
			</mainviews>
			<editors>
				<editor name="XMLEditor" url="editor/XMLEditor.swf"/>
			</editors>
		</config>';

	file_put_contents( 'config1.xml' ,  $xmlStr );
	
	// echo "huhj";
	// echo $xml->asXML();
	
?>