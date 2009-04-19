package info.osmatrix.rmframework.player
{
	import info.osmatrix.rmframework.util.scorm.ScormHelper;
	
	public class SWFPlayerHelper implements IPlayer
	{
		private var lessonStatus:String;
		private	var lmsConnected:Boolean;
		private	var success:Boolean;
		private	var scorm:SCORM = new ScormHelper();
					
		public function SWFPlayerHelper()
		{
		}

		public function loadXML(url:String):void
		{
		}
		
		public function getTime():int
		{
			return 0;
		}
		
		public function getLocation():String
		{
			return null;
		}
		
		public function start():String
		{
			// scorm 初始化操作
			
			lmsConnected = scorm.connect();
			
			if(lmsConnected){
			
				lessonStatus = scorm.get("cmi.core.lesson_status");
			
				if(lessonStatus == "completed" || lessonStatus == "passed"){
			
					//Course has already been completed.
					scorm.disconnect();
				
				} else {
					
					//Must tell LMS course has not been completed yet.
					success = scorm.set("cmi.core.lesson_status", "incomplete");
				
				}
				
			} else {
				
				trace("Could not connect to LMS.");
			
			}			
			// 由loadxml调用
			// 根据进度调用gotoAndPlay
		}
		
		public function stop():String
		{
			// 检查是否学完，完成scorm数据传送
			if(true){
				
				success = scorm.set("cmi.core.lesson_status", "completed");
				scorm.disconnect();
				lmsConnected = false;
				
			}			
		}
		
	}
}