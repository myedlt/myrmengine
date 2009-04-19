/**
 *	监听事件：
 * 		CE_ITEMCLICK
 * 		CE_NEXTSECTION
 * 		CE_PREVSECTION
 * 	接口函数：
 * 		setContentXML(content:XML):void
 * 		setLocator():void
 * 		set
 *
 */
package info.osmatrix.rmframework.app.view
{
	import flash.net.SharedObject;
	
	import info.osmatrix.rmframework.app.ApplicationFacade;
	import info.osmatrix.rmframework.app.model.*;
	import info.osmatrix.rmframework.app.model.vo.*;
	import info.osmatrix.rmframework.app.view.event.MainViewEvent;
	
	import mx.collections.*;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AppMediator extends Mediator implements IMediator
	{
		public static const NAME:String="AppMediator";

		private var contentVO:ContentVO;
		private var cmiArrayCollection:ArrayCollection ;
		private var configXML:XML;
 		
		private static const CMIXML:XML = 
			<cmi _version="3.4" 
				suspend_data="" 
				launch_data="">
				<core _children="" 
					student_id="" 
					student_name="" 
					lesson_location="" 
					credit="" 
					lesson_status="not attempted" 
					entry=""
					total_time="0000:00:00:00" 
					lesson_mode="normal"
					exit=""
					session_time="00:00:00">
					<score _children="raw,min,max">
						<raw label="" name="" value=""/>
						<min name="" value=""/>
						<max name="" value=""/>
					</score>
				</core>
				<comments_from_learner _count="0">
				
				</comments_from_learner>
				<comments_from_lms _count="0">
				
				</comments_from_lms>
				
				<objectives _children="id,score,status" _count="2">
					<object id="01" score="" status=""/>
					<object id="02" score="" status=""/>
					
				</objectives>
				<student_data _children="mastery_score,maxt_time_allowed,time_limit_action">
					<mastery_score/>
					<max_time_allowed/>
					<time_limit_action/>
				</student_data>
				<student_preference _children="">
					<audio/>
					<language/>
					<speed/>
					<text/>
				</student_preference>
				<interactions _children="" _count="0">
				
				</interactions>
			</cmi>;
			
		public function AppMediator(viewComponent:Object)
		{
			// viewComponennt - 加载的Flex或Flash界面
			super(NAME, viewComponent);

			// 章节播放
			viewComponent.addEventListener(MainViewEvent.CE_CHAPTERCHANGED, handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_SECTIONCHANGED, handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_NEXTSECTION, handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_PREVSECTION, handleEvent);

			viewComponent.addEventListener(MainViewEvent.CE_FULLSCREEN, handleEvent);

			// 扩展功能
			viewComponent.addEventListener(MainViewEvent.CE_SYSCONFIG, handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_HELP, handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_GLOSSARY, handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_NOTEBOOK, handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_ATTACHMENT, handleEvent);
			// 系统控制
			viewComponent.addEventListener(MainViewEvent.CE_EXITAPP, handleEvent);

		// AppMediator和DataXMLProxy一起注册，此时不能保证数据已准备好
		}

		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.LOAD_FILE_FAILED, ApplicationFacade.DATAPREPARED];
		}

		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case ApplicationFacade.LOAD_FILE_FAILED:
					Alert.show(note.getBody().toString());
					break;
				case ApplicationFacade.DATAPREPARED:
					initData();
					viewComponent.viewHelper.initContent(contentVO);
					refreshUI();

					break;
				default:
					break;

			}
		}

		private function handleEvent(evt:MainViewEvent):void
		{
			switch (evt.type)
			{
				case MainViewEvent.CE_CHAPTERCHANGED:

					break;
				case MainViewEvent.CE_SECTIONCHANGED:
					var sec:SectionVO=contentVO.getSectionById(evt.body.id);

					contentVO.curSection=sec;
					viewComponent.viewHelper.loadSection(contentVO.getChapterBySectionId(sec.id), sec);

					break;
				case MainViewEvent.CE_NEXTSECTION:

					contentVO.curSection=contentVO.getSectionNext(contentVO.curSection.id);
					viewComponent.viewHelper.loadSection(contentVO.getChapterBySectionId(contentVO.curSection.id), contentVO.curSection);

					break;
				case MainViewEvent.CE_PREVSECTION:

					contentVO.curSection=contentVO.getSectionPrev(contentVO.curSection.id);
					viewComponent.viewHelper.loadSection(contentVO.getChapterBySectionId(contentVO.curSection.id), contentVO.curSection);

					break;
				case MainViewEvent.CE_FULLSCREEN:

					viewComponent.viewHelper.switchFullScreen();

					break;
				case MainViewEvent.CE_SYSCONFIG:

					viewComponent.viewHelper.switchMode(1);

					break;
				case MainViewEvent.CE_HELP:

					viewComponent.viewHelper.switchMode(1);

					break;
				case MainViewEvent.CE_GLOSSARY:

					viewComponent.viewHelper.switchMode(1);

					break;
				case MainViewEvent.CE_NOTEBOOK:

					viewComponent.viewHelper.openNoteWindow();

					break;
				case MainViewEvent.CE_EXITAPP:
					// 发通知给AppExitCmd保存数据，数据保存成功后发回消息给AppMediator执行注应用推出函数
					viewComponent.viewHelper.exitApp();
					break;
				default:
					break;

			}
		}

		private function initData():void
		{
			// 此时数据已准备好，在initui之前必须获得VO数据格式
			var dataObject:Object = facade.retrieveProxy(ContentProxy.NAME).getData();
			contentVO = ContentVO(dataObject.content);
			
			// lso数据：cmiArrayCollection，configXML
			var lso:SharedObject = SharedObject.getLocal(contentVO.id,"/");
			if(lso.data.cmiArrayCollection != null )
			{
				cmiArrayCollection = lso.data.cmiArrayCollection;
				configXML = lso.data.configXML;
				
			}else
			{
				cmiArrayCollection = new ArrayCollection();
				
				var sectionList:Array = contentVO.getSectionAll();
				for each(var sectionVO:SectionVO in sectionList)
				{
					var cmi:Object = new Object();
					cmi.sectionid = sectionVO.id;
					cmi.xml = CMIXML;
					
					cmiArrayCollection.addItem(cmi);
				}
				
				// 配置默认值
				configXML = <config mode="cont"/>;
				
				//lso.data.configXML = configXML;
				lso.data.cmiArrayCollection = cmiArrayCollection;
				lso.flush();
			}
			
			// @TODO: 将lso内容追加到contentVO中
           

		// 当前位置: Navigator
		// 学习进度：History
		// 统一在一个CourseProxy中

		}

		private function refreshUI():void
		{
			// 更新界面显示，如目录的当前选中项、当前位置、进度显示和按钮可用性控制
			viewComponent.viewHelper.refreshUI(cmiArrayCollection);
		}

	}
}