package info.osmatrix.rmframework.app.model.vo
{
	import info.osmatrix.rmframework.app.model.vo.LectureVO;
	
	public class ContentVO
	{	
		// 基本信息
		public var id:String;	// 唯一标志		
		public var name:String;			
		public var title:String;
		public var startSWF:String;
		public var endSWF:String;
		public var data:XML;
		
		// 包含数据对象
		public var lecture:LectureVO;

		private var links:Array;	// push LinkVO
		public var chapters:Array;	// push ChapterVO
		public var sections:Array;
		
		// 实时数据
		public var curSection:SectionVO;
		private var curTime:int;	// 本次学习时长,单位秒
		private var totalTime:int;	// 累计学习时长，单位秒
		
		public function ContentVO():void
		{
			// 填充所有数据
		}
		
		public function getChapterAll():Array
		{
			return chapters;
		}
		public function getChapterById(id:String):ChapterVO
		{
			var chapter:ChapterVO = new ChapterVO();
			// 轮询
			return chapter;
		}
		public function getChapterBySectionId(id:String):ChapterVO
		{
			var chapter:ChapterVO = null;
			
			// 轮询
			for each(var ch:ChapterVO in chapters)
			{
				for each(var sec:SectionVO in ch.sections)
				{
					if(sec.id == id)
					{
						return ch;
					}
				}
			}
			
			return chapter;
		}
		public function getChapterFirst():ChapterVO
		{
			return chapters[0];
		}		
		public function getChapterNext(id:String):ChapterVO
		{
			var chapter:ChapterVO = new ChapterVO();
			// 轮询
			
			return chapter;
		}		
		public function getSectionAll():Array
		{
			return sections;
		}
		
		public function getSectionById(id:String):SectionVO
		{
			var sec:Object; 
			// 轮询
			for each(sec in this.sections)
			{
				if(id.localeCompare(sec.id) == 0){ break;}
			}
			return sec as SectionVO;			
		}
		public function getSectionFirst():SectionVO
		{
			return sections[0];
		}		
		public function getSectionNext(id:String):SectionVO
		{
			var section:SectionVO = null;
			// 轮询
			var index:int = 0;
			for each(var sec:SectionVO in sections)
			{
				if( sec.id == id)
				{
					if( index == sections.length - 1 )
					{
						return null;
					}
					else
					{
						return sections[index + 1];						
					}
				}	
				index = index + 1;
			}
			
			return section;			
		}
		public function getSectionPrev(id:String):SectionVO
		{
			var section:SectionVO = null;
			// 轮询
			var index:int = 0;
			for each(var sec:SectionVO in sections)
			{
				if( sec.id == id)
				{
					if( index == 0 )
					{
						return null;
					}
					else
					{
						return sections[index -1];						
					}
				}
				
				index = index + 1;
			}
			
			return section;			
		}
		
		public function getCurrentChapter():ChapterVO
		{
			// 由当前节结算出当前章
			var chapter:ChapterVO = new ChapterVO();
			return chapter;
		}
		public function getCurrentSection():SectionVO
		{
			return this.curSection;
		}
		public function goToNextSection():void
		{
			// 设置当前节到下一节
		}
	}
}