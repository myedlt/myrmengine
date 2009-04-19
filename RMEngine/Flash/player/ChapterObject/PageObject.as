package {
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.xml.XMLDocument;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	public class PageObject extends MovieClip {

		public function PageObject() {
			var word:String="0";
			var myXML:XML;
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest("code.xml");
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, onComplete);

			function onComplete(event:Event):void {
				var loader:URLLoader = event.target as URLLoader;
				if (loader != null) {
					myXML = new XML(loader.data);
					point_mc.mubiao_txt.text = myXML.part[0].pagetext.toString();
					object01.mubiao_txt.text = myXML.part[1].pagetext.toString();
					object02.mubiao_txt.text = myXML.part[2].pagetext.toString();
				} else {
					trace("loader is not a URLLoader!");
				}
			}
			var object01:MyPoint = new MyPoint();
			object01.x = 20;
			object01.y = 150;


			addChild(object01);

			var object02:MyPoint = new MyPoint();
			object02.x = 20;
			object02.y = 250;


			addChild(object02);

		}
	}
}