package info.osmatrix.rmframework.app.view
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import mx.collections.ArrayCollection;
		
	import info.osmatrix.rmframework.app.model.vo.*;
	
	public interface IMainView
	{

		function onChapterChanged(evt:Event):void;
		function onSectionChanged(evt:Event):void;

		function onPrevSection(evt:Event):void;
		function onNextSection(evt:Event):void;

		function onExitApp(evt:Event):void;
		
		function initContent(content:ContentVO):void;
		function refreshUI(cmiArrayCollection:ArrayCollection):void;
		function updateLocator(chapter:ChapterVO, section:SectionVO):void;
		function getPlayerRect():DisplayObject;
		function setStyle(url:String):void;
		function setContextMenu(cm:ContextMenu):void;		
		
	}
}