//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

class AdobeCaptivate.rdSound extends Sound
{
	var m_linkageID:String;
		
	function rdSound()
	{
		m_linkageID = "";
	}
	
	function attachSound(id:String)
	{
		m_linkageID = id;
		super.attachSound(id);
	}
	
	function pause()
	{
		stopSound();
	}
	
	function play()
	{
		super.start(position / 1000);
	}
	
	function stopSound()
	{
		super.stop(m_linkageID);
	}
	
	function startSound()
	{
		stopSound();
		super.start();
	}
	
}