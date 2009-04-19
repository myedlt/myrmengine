package info.osmatrix.rmframework.app.view
{
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	import info.osmatrix.rmframework.app.model.vo.*;
	import info.osmatrix.rmframework.app.view.event.MainViewEvent;
	import info.osmatrix.rmframework.app.view.IMainView;
		
	public class PBankFlashViewHelper implements IMainView
	{
		private var viewComponent:Object;

		public function PBankFlashViewHelper(app:Object):void
		{
			viewComponent = app as Object;

			viewComponent.prev_btn.addEventListener(MouseEvent.CLICK, onPrevSection);
			viewComponent.next_btn.addEventListener(MouseEvent.CLICK, onNextSection);

			viewComponent.sec0101_btn.addEventListener(MouseEvent.CLICK, onSectionChanged);			
			viewComponent.sec0102_btn.addEventListener(MouseEvent.CLICK, onSectionChanged);			
			viewComponent.sec0201_btn.addEventListener(MouseEvent.CLICK, onSectionChanged);			
			viewComponent.sec0202_btn.addEventListener(MouseEvent.CLICK, onSectionChanged);			
					
			//viewComponent.exit_btn.addEventListener(MouseEvent.CLICK,	onExitApp);					

		}

		public function onChapterChanged(evt:Event):void
		{
		}
		
		public function onSectionChanged(evt:Event):void
		{
			var btn:SimpleButton = evt.target as SimpleButton;
			var sec:Object = new Object();
			sec.id = btn.name.substr(3,4);
			viewComponent.dispatchEvent(new MainViewEvent("onSectionChanged", sec));
		}
		
		public function onPrevSection(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_PREVSECTION, "") );
		}
		
		public function onNextSection(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_NEXTSECTION, "") );
		}

		public function onExitApp(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_EXITAPP, "") );
		}
				
		public function initContent(content:ContentVO):void
		{
			//treeContents.dataProvider=facade.retrieveProxy(CourseProxy.NAME).getData().Chapter as XMLList;
			//treeContents.callLater(expandAllNode);//初始展开所有节点
			// 1. 目录树

			// 2. 功能按钮条

			// 3. 导航条与前进后退控制按钮条、学习历史进度

	        	
	        	// 2. 功能按钮条
	        	
	        	// 3. 导航条与前进后退控制按钮条、学习历史进度
	        	updateLocator(content.getChapterFirst(),content.getSectionFirst());
		}
				
		public function refreshUI():void
		{
			//txtChapter,arrowFlag,txtSection
		}
		
		public function updateLocator(chapter:ChapterVO, section:SectionVO):void
		{
			// 位置显示文本更新
			
			viewComponent.locator_txt.text = "当前学习位置：".concat(chapter.name, "->", section.name);
			viewComponent.curpage.txtcur.text = "01";
			viewComponent.curpage.txttol.text = "18";
			
			// 目录树光标位置更新	
			
			// 上下节按钮可用性更新：当前播放第一节时，【上一节】按钮不可用；当前播放最后一节时，【下一节】按钮不可用
			
		}
		
		public function getPlayerRect():DisplayObject
		{
			return viewComponent.contentMovieClip;
		}
		
	}
}