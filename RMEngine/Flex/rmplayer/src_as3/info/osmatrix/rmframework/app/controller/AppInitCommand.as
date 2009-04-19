package info.osmatrix.rmframework.app.controller
{
	import info.osmatrix.rmframework.app.ApplicationFacade;
	import info.osmatrix.rmframework.app.model.*;
	import info.osmatrix.rmframework.app.view.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class AppInitCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void    
		{
			/* 
			 *	数据准备：先将xml文件读入DataProxy,数据加载成功后发STARTUP消息
			 *		CourseProxy和NavigatorProxy都从DataProxy获得数据
			 * 
			 */
			facade.registerProxy(new DataXMLProxy("content.xml"));
			facade.registerMediator( new AppMediator(ApplicationFacade.getInstance().app) );
        }
	}
}