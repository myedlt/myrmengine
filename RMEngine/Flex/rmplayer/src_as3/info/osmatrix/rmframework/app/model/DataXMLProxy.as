package info.osmatrix.rmframework.app.model
{	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;		
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import info.osmatrix.rmframework.app.ApplicationFacade;

	//数据初始化(加载xml数据文件),数据加载完毕发送INITIALIZE通知
	public class DataXMLProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DataXMLProxy";		
		
		public function DataXMLProxy(url:String = "content.xml") 
		{
			super( NAME );
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,result);
			loader.addEventListener(IOErrorEvent.IO_ERROR,fault);

			loader.load(new URLRequest(url));	
		}			
		
		public function result(evt:Event):void
		{
			try 
			{
            	this.data = new XML(evt.target.data);
            	sendNotification(ApplicationFacade.STARTUP);
            }
            catch (e:TypeError) 
            {
            	trace("DataXMLProxy：" + e.message);
            }				         				
		}
		
		public function fault(evt:IOErrorEvent):void
		{		
			sendNotification(ApplicationFacade.LOAD_FILE_FAILED,ApplicationFacade.ERROR_LOAD_FILE);			
		}
	}
}