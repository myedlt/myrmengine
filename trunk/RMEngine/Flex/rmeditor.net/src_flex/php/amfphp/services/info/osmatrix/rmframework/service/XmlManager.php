<?php

class XmlManager {

    /**
     * Class contains methods for getting data about teams and players
     * it contains database connection
     */
	

	
	public function __construct()
	{
		// 
	}

    /**
     * function gets data about the teams, sorted by title
     * @returns array with Team objects
     */
	
	public function getXml($xmlUrl)
	{
	
		$xml = simplexml_load_file( "D:/xampp/htdocs/rmeditor/" . $xmlUrl );
	
		return $xml->asXML();
		
	}
    
    /**
     * function updates selected team, input parameter is an array 
     * that contains team data received from actionscript Team class
     */  
  
  public function setXml( $xmlUrl, $xmlStr )
    {
		return file_put_contents( "D:/xampp/htdocs/rmeditor/" .  $xmlUrl ,  $xmlStr );
    }
}
?>