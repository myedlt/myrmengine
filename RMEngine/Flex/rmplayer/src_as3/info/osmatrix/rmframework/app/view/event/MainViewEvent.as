package info.osmatrix.rmframework.app.view.event
{
	import flash.events.Event;
	
	/**
	 *	附加信息用途：
	 * 		1）节的ID； 
	 * @author huhj
	 * 
	 * 	播放视图界面与主程序框架间的事件，界面皮肤可能是Flash CS3和FlexBuilder开发。
	 * 
	 */
	public class MainViewEvent extends Event
	{
		/* UI 自定义事件	*/
		public static const CE_CHAPTERCHANGED:String 	= "onChapterChanged";
		public static const CE_SECTIONCHANGED:String 	= "onSectionChanged";
		public static const CE_NEXTSECTION:String 		= "onNextSection";
		public static const CE_PREVSECTION:String 		= "onPrevSection";
		public static const CE_FULLSCREEN:String 		= "onFullScreen";

		public static const CE_SYSCONFIG:String 		= "onSysConfig";
		public static const CE_HELP:String 				= "onHelp";
		public static const CE_GLOSSARY:String 			= "onGlossary";
		public static const CE_NOTEBOOK:String 			= "onNoteBook";
		public static const CE_ATTACHMENT:String 		= "onAttachment";
		
		public static const CE_EXITAPP:String 			= "onEXITAPP";		
		
       public var body:Object; //自定义的事件信息

       public function MainViewEvent(strType:String, msg:Object){

             super(strType, true); //如果在构造时不设bubbles，默认是false，也就是不能传递的。

             body = msg;

       }		
		
	}
}