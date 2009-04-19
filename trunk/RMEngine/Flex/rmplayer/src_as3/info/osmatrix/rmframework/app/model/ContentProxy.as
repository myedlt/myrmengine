package info.osmatrix.rmframework.app.model
{		
	import info.osmatrix.rmframework.app.model.vo.*;
	import info.osmatrix.rmframework.app.model.vo.util.DataUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ContentProxy extends Proxy implements IProxy
	{			
		public static const NAME:String = "ContentProxy";
		
		// @TODO: 保存的数据不应只是ContentVO，还有LinkButton、FAQ、Glossary
		private var courses:Array = new Array();
		private var links:Array = new Array();
		
		public function ContentProxy ( dataXML:Object):void 
        {        	
            super ( NAME, dataXML );

            parseData(dataXML);            
        }
        
        /**
         * 	data参量接收content.xml裸数据,其中课程章节信息转换为ValueObject
         * 
         */
        private function parseData(dataXML:Object):void
        {
        	data = new Object();
        	try
        	{
				data.content = DataUtil.parseCourse(XML(dataXML));
				// this.data.faq = ;
				// this.data.glossary = ;
        	}
        	catch(e:TypeError)
        	{
        		trace("ContentProxy：" + e.message);
        	}
        }
        
	}
}