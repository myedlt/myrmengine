//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

class AdobeCaptivate.rdZoomItemFla extends AdobeCaptivate.rdZoomItem
{
	var soundID:String = "";
	var m_sound:Sound = null;
	
	function rdZoomItemFla()
	{
	 	
	}

	function playSound()
	{
		if(m_sound == null)
		{
			m_sound = new Sound();
			m_sound.attachSound(soundID);
			m_sound.start();
		}
	}

	function stopSound()
	{
		if(m_sound != null)
		{
			//trace("stopSound");
			m_sound.stop();
		}
	}	
}