/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2008
* Written by: Steven Sacks
* email: stevensacks@gmail.com
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is (c) 2007-2008 Steven Sacks and is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package info.osmatrix.flash
{
	import com.gaiaframework.templates.AbstractPage;
	import com.gaiaframework.events.*;
	import com.gaiaframework.debug.*;
	import com.gaiaframework.api.*;
	import flash.display.*;
	import flash.events.*;
	
	public class TreePage extends AbstractPage
	{	
		public function TreePage()
		{
			super();
			new Scaffold(this);
		}
		override public function transitionIn():void 
		{
			super.transitionIn();
            gotoAndPlay("in");
		}
		override public function transitionOut():void 
		{
			super.transitionOut();
            gotoAndPlay("out");
		}
	}
}