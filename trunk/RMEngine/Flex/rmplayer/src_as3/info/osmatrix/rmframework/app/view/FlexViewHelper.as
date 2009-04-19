package info.osmatrix.rmframework.app.view
{
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.ui.ContextMenu;
	import flash.ui.Keyboard;
	
	import info.osmatrix.rmframework.app.model.vo.*;
	import info.osmatrix.rmframework.app.view.event.MainViewEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.ListEvent;
	import mx.styles.StyleManager;
			
	public class FlexViewHelper implements IMainView
	{
		private var viewComponent:MainFlex;
		private var curStyleUrl:String;

		public function FlexViewHelper(app:Object):void
		{
			viewComponent = app as MainFlex;
			
			// 章节播放
			viewComponent.btnPrevSection.addEventListener(MouseEvent.CLICK,	onPrevSection);
			viewComponent.btnNextSection.addEventListener(MouseEvent.CLICK,	onNextSection);					
			viewComponent.treeContents.addEventListener(ListEvent.ITEM_CLICK,	onSectionChanged);

			// 全屏/一般状态切换
			viewComponent.btnFullScreen.addEventListener(MouseEvent.CLICK,	onFullScreen);
			viewComponent.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			// 扩展功能
			viewComponent.sysConfigLinkButton.addEventListener(MouseEvent.CLICK, onSysConfig);			
			viewComponent.helpLinkButton.addEventListener(MouseEvent.CLICK, onHelp);			
			viewComponent.glossaryLinkButton.addEventListener(MouseEvent.CLICK, onGlossary);			
			viewComponent.noteLinkButton.addEventListener(MouseEvent.CLICK, onNote);			
			viewComponent.attachmentLinkButton.addEventListener(MouseEvent.CLICK, onAttachment);			

			// 系统操作
			viewComponent.btnExit.addEventListener(MouseEvent.CLICK,	onExitApp);					

		}

		public function onChapterChanged(evt:Event):void
		{
		}
		
		public function onSectionChanged(evt:Event):void
		{
 			if(!viewComponent.treeContents.dataDescriptor.isBranch(evt.target.selectedItem))
			{	
				// MainView 传送参数为节的ID
				// var itemManual:Object = new Object(); itemManual.id = "0101";
				var item:Object = evt.target.selectedItem as Object;						
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_SECTIONCHANGED, item) );				
				//trace("itemClick:"+evt.target.selectedItem.toXMLString());
			}
		}
		
		public function onPrevSection(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_PREVSECTION, "") );
		}
		public function onNextSection(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_NEXTSECTION, "") );
		}
		public function onFullScreen(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_FULLSCREEN, "") );
		}

		public function onKeyDown(evt:KeyboardEvent):void
		{
			if( evt.keyCode == Keyboard.ESCAPE)
			{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_FULLSCREEN, "") );				
			}
		}

		public function onSysConfig(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_SYSCONFIG, "") );
		}
		public function onHelp(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_HELP, "") );
		}
		public function onGlossary(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_GLOSSARY, "") );
		}
		public function onAttachment(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_ATTACHMENT, "") );
		}
		public function onNote(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_NOTEBOOK, "") );
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
				var chapters:Array = content.getChapterAll();
	        	viewComponent.treeContents.labelField="name";

	        	for each(var chapter:ChapterVO in chapters) {
	        		// DataProvider 添加章时需要的子项目数组集合
	        		var childrenSections:ArrayCollection = new ArrayCollection();
	        		
	        		// 提取当前操作章的节列表，填入children备用
					for each(var section:SectionVO in chapter.sections) {
						childrenSections.addItem({"id":section.id,"name":section.name,"type":section.type,"url":section.path});
					}
	        		
					viewComponent.treeContents.dataProvider.addItem(
						{ "id":chapter.id, "name":chapter.name, "children":childrenSections });
					
	        	}
	        	
	        	// 2. 功能按钮条
	        	
	        	// 3. 导航条与前进后退控制按钮条、学习历史进度
	        	updateLocator(content.getChapterFirst(),content.getSectionFirst());
		}
				
		public function refreshUI(cmiArrayCollection:ArrayCollection):void
		{
			// txtChapter,arrowFlag,txtSection 数据变化时刷新，如进度、播放内容变化等
			// 轮询树目录，首先刷新节的进度状态，接着根据节刷新章的状态
			// viewComponent.treeContents.
		}
		
		public function updateLocator(chapter:ChapterVO, section:SectionVO):void
		{
			// 位置显示文本更新
			viewComponent.txtChapter.text = chapter.name;
			viewComponent.txtSection.text = section.name;
			
			// 目录树光标位置更新	
			
			// 上下节按钮可用性更新：当前播放第一节时，【上一节】按钮不可用；当前播放最后一节时，【下一节】按钮不可用
			
		}
		
		public function getPlayerRect():DisplayObject
		{
			return viewComponent.contentSWFLoader;
		}
		
		public function setStyle(url:String):void
		{
			//
			StyleManager.unloadStyleDeclarations(curStyleUrl,true);
			StyleManager.loadStyleDeclarations(url,true);
			curStyleUrl = url;			 
		}
		
		public function setContextMenu(cm:ContextMenu):void
		{
			viewComponent.contextMenu = cm;
		}
		
		public function scrollToItem():void
		{
/*                  var team:String = ComboBox(evt.currentTarget).selectedItem.@label;
                 var node:XMLList = mlb.league.division.team.(@label == team);                 expandParents(node[0]);
  
                 tree.selectedItem = node[0];
                 var idx:int = tree.getItemIndex(node[0]);
                 tree.scrollToIndex(idx);
   */
	
		}
		 private function expandParents(node:XML):void 
		 {
/* 			 if (node && !tree.isItemOpen(node)) {
			     tree.expandItem(node, true);
			     expandParents(node.parent());
		 	}	
 */		 }
	}
}