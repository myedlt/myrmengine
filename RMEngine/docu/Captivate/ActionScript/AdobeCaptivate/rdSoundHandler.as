//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import AdobeCaptivate.rdSound;

class AdobeCaptivate.rdSoundHandler extends Object
{
	var m_sounds:Object;
	var m_movieSound:rdSound;
		
	function rdSoundHandler()
	{
		m_sounds = new Object();
		m_movieSound = null;
	}
	
	function attachSound(key:Number, id:String):rdSound
	{
		var sound:rdSound;
		if(m_sounds[key] == undefined || m_sounds[key] == null)
		{	//attach new sound to the handler
			var newSound:rdSound = new rdSound();
			newSound.attachSound(id);
			sound = m_sounds[key] = newSound;
		}
		else
		{
			sound = m_sounds[key];
			sound.stopSound();
		}
		
		return sound;
	}
	
	function detachSound(key:Number)
	{	//remove the sound object from the handler
		if(m_sounds[key] != undefined && m_sounds[key] != null)
		{
			var sound:rdSound = m_sounds[key];
			sound.stopSound();
			m_sounds[key] = undefined;
		}
	}
	
	function playAllSounds(bPause:Boolean)
	{
		if(bPause == true)
		{	//pause all sounds
			if(m_movieSound != null)
				m_movieSound.pause();
			for(var key in m_sounds)
			{
				m_sounds[key].pause();	
			}
		}
		else
		{	//resume all sounds
			if(m_movieSound != null)
				m_movieSound.play();
			for(var key in m_sounds)
			{
				m_sounds[key].play();	
			}
		}
	}
	
	
}