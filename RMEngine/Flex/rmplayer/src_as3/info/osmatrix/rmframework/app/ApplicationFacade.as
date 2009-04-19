package info.osmatrix.rmframework.app
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import info.osmatrix.rmframework.app.controller.*;

	public class ApplicationFacade extends Facade
	{
		public var app:Object;
		
		// Notification name constants
		//AppMediator，数据准备好后发INITUI给AppMediator
		public static const LOAD_FILE_FAILED:String = "loadFileFailed";				
		public static const DATAPREPARED:String="dataPrepared";
						
		//command - 系统启动消息组
		public static const INIT:String = "initialize";
		public static const STARTUP:String="startup";
		
		//common messages
		public static const ERROR_LOAD_FILE:String	= "加载文件失败!";
		
		public static function getInstance():ApplicationFacade
		{
			if(instance==null)instance=new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		// 注册Command，建立Command与 Notification之间的映射 
		override protected function initializeController():void
		{
			super.initializeController();
			
			/* 	创建DataXMLProxy和AppMediator对象，
			 * 	并异步加载content.xml文件，加载完成后发STARTUP消息
			 */
			registerCommand(INIT,AppInitCommand);
			
			// 将content.xml裸数据转换到ContentProxy；
			// ContentProxy调用DataLSOProxy获得cmi.xml
			registerCommand(STARTUP,AppStartupCommand);
			
		}
		
		// 启动 PureMVC，在应用程序中调用此方法，并传递应用程序本身的引用 
	   	public function startup( viewComponent:Object ) : void  
	   	{   
	   		this.app = viewComponent;
			sendNotification( INIT, app ); 
	   	} 
		
	}
}