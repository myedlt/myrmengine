package info.osmatrix.rmframework.app.view.event
{
	import flash.events.Event;
	
	/**
	 *	附加信息为节的ID 
	 * @author huhj
	 * 
	 */
	public class MainViewEvent extends Event
	{
		/* UI 自定义事件	*/
		public static const CE_CHAPTERCHANGED:String 	= "onChapterChanged";
		public static const CE_SECTIONCHANGED:String 	= "onSectionChanged";
		public static const CE_NEXTSECTION:String 		= "onNextSection";
		public static const CE_PREVSECTION:String 		= "onPrevSection";
		
		public static const CE_EXITAPP:String 			= "onEXITAPP";		
		
       public var body:Object; //自定义的事件信息

       public function MainViewEvent(strType:String, msg:Object){

             super(strType, true); //如果在构造时不设bubbles，默认是false，也就是不能传递的。

             body = msg;

       }		
		
	}
}