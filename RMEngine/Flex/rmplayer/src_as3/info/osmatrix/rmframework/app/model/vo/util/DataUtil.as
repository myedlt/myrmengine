package info.osmatrix.rmframework.app.model.vo.util
{
	import info.osmatrix.rmframework.app.model.vo.ChapterVO;
	import info.osmatrix.rmframework.app.model.vo.ContentVO;
	import info.osmatrix.rmframework.app.model.vo.LectureVO;
	import info.osmatrix.rmframework.app.model.vo.SectionVO;
	
	/**
	 * 
	 * @author huhj
	 * 	1、xml转换为值对象，用于前端界面使用；
	 * 	2、值对象转换为xml，用于保存xml文件；
	 * 
	 *  注：数据库取值也许可以先转换为xml文件。
	 * 
	 */
	public class DataUtil
	{
		// 通过传入的XML(即content.xml)获得CourseVO
		static public function parseCourse(coXml:XML):ContentVO
		{

			var co:ContentVO = new ContentVO();						

			// 1、课程概要信息
			var course:XML = XML(coXml.courseList.course);
			co.data		= course;

			co.id	 	= course.hasOwnProperty("@id")?course.@id:"";
			co.name 	= course.hasOwnProperty("@name")?course.@name:"";
			co.title 	= course.hasOwnProperty("@title")?course.@title:"";
			co.startSWF = course.hasOwnProperty("@startSWF")?course.@startSWF:"";
			co.endSWF 	= course.hasOwnProperty("@endSWF")?course.@endSWF:"";
			
			// 2、讲师
			var lecture:XML = XML(coXml.courseList.course.lecture);			
			if(lecture)
			{	
				co.lecture=parseLecture(lecture);
			}
			
			// 3、功能链接
			
			// 4、章
			var chapters:Array = new Array();
			var chapterList:XMLList = XMLList(coXml..chapter);
			for each(var chapterXml:XML in chapterList)
			{								
				chapters.push(parseChapter(chapterXml));
			}
			co.chapters=chapters;
						
			// 5、节	(章数组中已有节的数据，此处单独保存所有的节，方便节的查询)
			var sections:Array = new Array();			
			var sectionList:XMLList = XMLList(coXml..section);
			for each(var sectionXml:XML in sectionList)
			{								
				sections.push(parseSection(sectionXml));
			}
			co.sections = sections;
			
			
			return co;
		}
		
		// 节	
		static public function parseSection(section:XML):SectionVO
		{
			
			var sec:SectionVO=new SectionVO();
			
			sec.id 		= section.hasOwnProperty("@id")?section.@id:"";
			sec.name 	= section.hasOwnProperty("@name")?section.@name:"";
			sec.path 	= section.hasOwnProperty("@path")?section.@path:"";
			sec.type 	= section.hasOwnProperty("@type")?section.@type:"flash"; // 默认类型 Flash
			sec.title 	= section.hasOwnProperty("@title")?section.@title:"";
			sec.xml 	= section.hasOwnProperty("@xml")?section.@title:"";
			
			return sec;
		}
		
		/**
		 * 	章:
		 * @param chapter
		 * @return 
		 * 
		 */
		static public function parseChapter(chapter:XML):ChapterVO
		{
			var cha:ChapterVO=new ChapterVO();	
			
			cha.id 		= chapter.hasOwnProperty("@id")?chapter.@id:"";
			cha.name 	= chapter.hasOwnProperty("@name")?chapter.@name:"";
			cha.title 	= chapter.hasOwnProperty("@title")?chapter.@title:"";
				
			if(chapter.section!=undefined)
			{
				var sections:Array=new Array();
				for each(var section:XML in chapter.section)
				{						
					sections.push(parseSection(section));
				}
				cha.sections=sections;
			}
			else
			{
				cha.type 	= chapter.hasOwnProperty("@type")?chapter.@type:"flash";
				cha.xml 	= chapter.hasOwnProperty("@xml")?chapter.@xml:"";
				cha.path 	= chapter.hasOwnProperty("@path")?chapter.@type:"";
			}	
			return cha;			
		}
		

		
		static public function parseLecture(lecture:XML):LectureVO
		{
			//讲师:
			var lec:LectureVO=new LectureVO();
			if(lecture.name!=undefined)
			{
				lec.name=lecture.name;
			}
			if(lecture.sex!=undefined)
			{
				lec.sex=lecture.sex;
			}
			if(lecture.age!=undefined)
			{
				lec.age=lecture.age;
			}
			if(lecture.position!=undefined)
			{
				lec.position=lecture.position;
			}
			if(lecture.photo!=undefined)
			{
				lec.photo=lecture.photo;
			}
			if(lecture.introduction!=undefined)
			{
				lec.introduction=lecture.introduction;
			}	
			return lec;
		}
	}
}
