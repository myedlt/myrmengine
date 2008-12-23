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

package com.gaiaframework.assets
{
	import com.gaiaframework.api.ISprite;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import flash.media.SoundTransform;
	
	import flash.ui.ContextMenu;
	
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class SpriteAsset extends DisplayObjectAsset implements ISprite
	{
		protected var _container:DisplayObject;
		
		function SpriteAsset()
		{
			super();
		}
		public function get container():DisplayObject
		{
			return _container;
		}
		public function set container(value:DisplayObject):void
		{
			if (_container == null) _container = value;
		}
		public function get domain():String
		{
			return _domain;
		}
		public function set domain(value:String):void
		{
			_domain = value;
		}
		// PROXY SPRITE PROPERTIES
		public function get buttonMode():Boolean
		{
			return Sprite(_container).buttonMode;
		}
		public function set buttonMode(value:Boolean):void
		{
			Sprite(_container).buttonMode = value;
		}
		public function get dropTarget():DisplayObject
		{
			return Sprite(_container).dropTarget;
		}
		public function get graphics():Graphics
		{
			return Sprite(_container).graphics;
		}
		public function get hitArea():Sprite
		{
			return Sprite(_container).hitArea;
		}
		public function set hitArea(value:Sprite):void
		{
			Sprite(_container).hitArea = value;
		}
		public function get soundTransform():SoundTransform
		{
			return Sprite(_container).soundTransform;
		}
		public function set soundTransform(value:SoundTransform):void
		{
			Sprite(_container).soundTransform = value;
		}
		public function get useHandCursor():Boolean
		{
			return Sprite(_container).useHandCursor;
		}
		public function set useHandCursor(value:Boolean):void
		{
			Sprite(_container).useHandCursor = value;
		}
		// PROXY SPRITE FUNCTIONS
		public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void
		{
			Sprite(_container).startDrag(lockCenter, bounds);
		}
		public function stopDrag():void
		{
			Sprite(_container).stopDrag();
		}		
		// PROXY DISPLAY OBJECT _container PROPERTIES
		public function get mouseChildren():Boolean
		{
			return Sprite(_container).mouseChildren;
		}
		public function set mouseChildren(value:Boolean):void
		{
			Sprite(_container).mouseChildren = value;
		}
		public function get numChildren():int
		{
			return Sprite(_container).numChildren;
		}
		public function get tabChildren():Boolean
		{
			return Sprite(_container).tabChildren;
		}
		public function set tabChildren(value:Boolean):void
		{
			Sprite(_container).tabChildren = value;
		}
		// PROXY DISPLAY OBJECT _container FUNCTIONS
		public function addChild(child:DisplayObject):DisplayObject
		{
			return Sprite(_container).addChild(child);
		}
		public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return Sprite(_container).addChildAt(child, index);
		}
		public function areInaccessibleObjectsUnderPoint(point:Point):Boolean
		{
			return Sprite(_container).areInaccessibleObjectsUnderPoint(point);
		}
		public function contains(child:DisplayObject):Boolean
		{
			return Sprite(_container).contains(child);
		}
		public function getChildAt(index:int):DisplayObject
		{
			return Sprite(_container).getChildAt(index);
		}
		public function getChildByName(name:String):DisplayObject
		{
			return Sprite(_container).getChildByName(name);
		}
		public function getChildIndex(child:DisplayObject):int
		{
			return Sprite(_container).getChildIndex(child);
		}
		public function getObjectsUnderPoint(point:Point):Array
		{
			return Sprite(_container).getObjectsUnderPoint(point);
		}
		public function removeChild(child:DisplayObject):DisplayObject
		{
			return Sprite(_container).removeChild(child);
		}
		public function removeChildAt(index:int):DisplayObject
		{
			return Sprite(_container).removeChildAt(index);
		}
		public function setChildIndex(child:DisplayObject, index:int):void
		{
			Sprite(_container).setChildIndex(child, index);
		}
		public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			Sprite(_container).swapChildren(child1, child2);
		}
		public function swapChildrenAt(index1:int, index2:int):void
		{
			Sprite(_container).swapChildrenAt(index1, index2);
		}
		// PROXY INTERACTIVE OBJECT PROPERTIES
		public function get contextMenu():ContextMenu
		{
			return Sprite(_container).contextMenu;
		}
		public function set contextMenu(value:ContextMenu):void
		{
			Sprite(_container).contextMenu = value;
		}
		public function get doubleClickEnabled():Boolean
		{
			return Sprite(_container).doubleClickEnabled;
		}
		public function set doubleClickEnabled(value:Boolean):void
		{
			Sprite(_container).doubleClickEnabled = value;
		}
		public function get focusRect():Object
		{
			return Sprite(_container).focusRect;
		}
		public function set focusRect(value:Object):void
		{
			Sprite(_container).focusRect = value;
		}
		public function get mouseEnabled():Boolean
		{
			return Sprite(_container).mouseEnabled;
		}
		public function set mouseEnabled(value:Boolean):void
		{
			Sprite(_container).mouseEnabled = value;
		}
		public function get tabEnabled():Boolean
		{
			return Sprite(_container).tabEnabled;
		}
		public function set tabEnabled(value:Boolean):void
		{
			Sprite(_container).tabEnabled = value;
		}
		public function get tabIndex():int
		{
			return Sprite(_container).tabIndex;
		}
		public function set tabIndex(value:int):void
		{
			Sprite(_container).tabIndex = value;
		}
		override public function toString():String
		{
			return "[SpriteAsset] " + _id;
		}
	}
}