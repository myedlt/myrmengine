package info.osmatrix.rmframework.app.model
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class DataDBProxy extends Proxy implements IProxy
	{
		public function DataDBProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
	}
}