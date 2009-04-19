package info.osmatrix.rmframework.player.event
{
	import flash.events.Event;
	
	/**
	 *	附加信息为节的ID 
	 * @author huhj
	 * 
	 */
	public class PlayerViewEvent extends Event
	{
		/* UI 自定义事件	*/
		public static const CE_PLAY_START:String 	= "onPlayStart";
		public static const CE_PLAY_END:String 		= "onPlayEnd";
		public static const CE_PLAY_PAUSED:String 	= "onPlayPaused";
		public static const CE_PLAY_CONTINUE:String = "onPlayContinue";
				
      	public var body:Object; //自定义的事件信息

      	public function PlayerViewEvent(strType:String, msg:Object){

             super(strType, true); //如果在构造时不设bubbles，默认是false，也就是不能传递的。

             body = msg;

      	}		
		
	}
}