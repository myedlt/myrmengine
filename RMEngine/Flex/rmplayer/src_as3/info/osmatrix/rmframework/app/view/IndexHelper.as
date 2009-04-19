package info.osmatrix.rmframework.app.view
{

	import flash.display.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.SoundMixer;
	import flash.system.fscommand;
	
	import info.osmatrix.rmframework.app.model.vo.*;
	import info.osmatrix.rmframework.note.*;
	
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;

	/*
	 * 	主程序标准接口定义
	 */
	 
	public class IndexHelper
	{
		private var viewComponent:Index;
		
		private var playerType:String;
		private var playerUrl:String;
		private var rootUrl:String = "";
		
		private var playState:int = 0; 			// 当前播放状态：0-尚未开始或已停止；1-正在播放；2-暂停
		private var playScreenState:int = 0;	// 内容播放控件全屏界面 - 默认：非全屏
		
		public function IndexHelper(vo:Index)
		{
			viewComponent = vo;
			rootUrl = viewComponent.url.substring(0, viewComponent.url.lastIndexOf("Index"));
			
		}
				 
		public function initContent(content:ContentVO):void
		 {
			// main.swf 主界面数据初始化
		 	getRefMainViewHelper().initContent(content);
			getRefMainViewHelper().setContextMenu(viewComponent.contextMenu);

			// index.swf 根据界面插件的占位符矩形位置设置播放器，使之完全重叠
			var rect:DisplayObject = getRefMainViewHelper().getPlayerRect();
			
			viewComponent.contentSWFLoader.x = rect.x;
			viewComponent.contentSWFLoader.y = rect.y;
			viewComponent.contentSWFLoader.width = rect.width;
			viewComponent.contentSWFLoader.height = rect.height;				
		 }
		 
		public function loadSection(chapter:ChapterVO,section:SectionVO):void
		{
				playSection(chapter, section);
		}

		// 加载播放器：Flex SWF加载swf是以自己为基准来识别相对路径的
		private function playSection(chapter:ChapterVO,section:SectionVO):void
		{
			// 根据节指定的播放器类型；从配置文件根据节的url播放内容
			playerUrl = section.path;	// 待播放内容的url
			
			var playerlist:XMLList = XMLList(viewComponent.configXML..player);
			for each(var player:XML in playerlist)
			{
				if(player.@name == section.type)
				{
					playerType = player.@url;		// 播放器的url
					break;
				}
			}
						
			// 解决切换播放内容后，遗留的背景声音
			flash.media.SoundMixer.stopAll();
					
			viewComponent.contentSWFLoader.addEventListener(Event.COMPLETE ,onSectionLoaded);
			viewComponent.contentSWFLoader.load(playerType);
        	
			getRefMainViewHelper().updateLocator(chapter,section);
		}
		

		
		public function exitApp():void
		{
			//一些浏览器不支持通过 navigateToURL() 方法使用 javascript 协议。而应考虑使用 ExternalInterface API 的 call() 方法在包含该内容的 HTML 页中调用 JavaScript 方法。
			//navigateToURL(new URLRequest("javascript:window.close()"),"_self");//"window.opener=null"使关闭窗口时不弹出确认信息窗口
			
			fscommand("quit");
		}
		
		// player 都是Flex应用
		private function onSectionLoaded(evt:Event):void
		{
			viewComponent.contentSWFLoader.removeEventListener(Event.COMPLETE, onSectionLoaded);
			var sysMgr:SystemManager = viewComponent.contentSWFLoader.content as SystemManager;
			sysMgr.addEventListener(FlexEvent.APPLICATION_COMPLETE, onSectionAppComplete);
			
		}
		
		private function onSectionAppComplete(evt:FlexEvent):void
		{
			var sysMgr:SystemManager = viewComponent.contentSWFLoader.content as SystemManager;

			Object(sysMgr.application).loadXML(playerUrl, rootUrl);
		}

		public function getRefMainViewHelper():IMainView
		{
			// 获得主界面swf的应用
			var mainViewer:Object;
			var obj:Object = viewComponent.mainSWFLoader.content;
			
			if(obj is SystemManager)	// Flex 应用
			{
				mainViewer = Object(viewComponent.mainSWFLoader.content).application;
			}
			else if (obj is MovieClip)	// Flash 
			{
				mainViewer = MovieClip(viewComponent.mainSWFLoader.content);
			}
			
			return mainViewer.viewHelper as IMainView;				
		}
		
		public function switchMode(index:int):void
		{
			viewComponent.mainViewStack.selectedIndex = index;
		}

		public function switchFullScreen():void
		{
			if(this.playScreenState == 0)
			{
				viewComponent.contentSWFLoader.x = viewComponent.mainSWFLoader.x;
				viewComponent.contentSWFLoader.y = viewComponent.mainSWFLoader.x;
				viewComponent.contentSWFLoader.width = viewComponent.mainSWFLoader.width;
				viewComponent.contentSWFLoader.height = viewComponent.mainSWFLoader.height;
				
				playScreenState = 1;		
			}
			else
			{
				// index.swf 根据界面插件的占位符矩形位置设置播放器，使之完全重叠
				var rect:DisplayObject = getRefMainViewHelper().getPlayerRect();
				
				viewComponent.contentSWFLoader.x = rect.x;
				viewComponent.contentSWFLoader.y = rect.y;
				viewComponent.contentSWFLoader.width = rect.width;
				viewComponent.contentSWFLoader.height = rect.height;
				
				playScreenState = 0;					
			}
		}
		
		public function openNoteWindow():void
		{
  			var note:NoteBook = new NoteBook();
  			
  			note.x = 50; note.y = 50;
  			note.init("rmdemo"); 
  			PopUpManager.addPopUp(note, this.viewComponent, true); 			
		}		
	}						
		
}