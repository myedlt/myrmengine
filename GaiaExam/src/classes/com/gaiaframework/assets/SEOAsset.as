﻿/*****************************************************************************************************
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

package com.gaiaframework.assets
{
	import flash.events.Event;

	public class SEOAsset extends XMLAsset
	{	
		private var _copy:Object;
		
		function SEOAsset()
		{
			super();
		}
		public function get copy():Object
		{
			return _copy;
		}
		override protected function onComplete(event:Event):void
		{
			super.onComplete(event);
			parseCopy();
		}
		private function parseCopy():void
		{
			_copy = {}; 
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			default xml namespace = new Namespace("http://www.w3.org/1999/xhtml");
			var html:XML = XML(_data);
			var copyTags:XMLList = html..div.(hasOwnProperty("@id") && @id == "copy")..p;
			var copyTag:XML;
			
			_copy.innerHTML = html..div.(hasOwnProperty("@id") && @id == "copy").toXMLString().replace(/\s+xmlns(:[^=]+)?=\"[^=]*?\"/g, "");
			
			for each (copyTag in copyTags)
			{
				var str:String = "";
				var len:int = copyTag.children().length();
				for (var i:int = 0; i < len; i++)
				{
					str += copyTag.children()[i].toXMLString();
				}
				_copy[copyTag.@id] = str.replace(/\s+xmlns(:[^=]+)?=\"[^=]*?\"/g, "");
			}
		}
		override public function toString():String
		{
			return "[SEOAsset] " + _id;
		}
	}
}