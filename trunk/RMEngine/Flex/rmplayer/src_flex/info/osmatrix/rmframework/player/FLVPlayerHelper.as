package info.osmatrix.rmframework.player
{
	import mx.core.Application;
	
	public class FLVPlayerHelper implements IPlayer
	{
		private var viewComponent:Object;
	
		public function FLVPlayerHelper(app:Application)
		{
			viewComponent = app;
		}

		public function loadXML(url:String):void
		{
			viewComponent.loadXML(url);
		}
		
		public function getTime():int
		{
			return 0;
		}
		
		public function getLocation():String
		{
			return null;
		}
		
	}
}