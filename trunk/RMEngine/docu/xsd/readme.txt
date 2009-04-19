	<!--
		页面头部导航区 "label"属性是按钮在页面的显示名称,"url"是点击按钮后跳转的页面路径;
		"退出"按钮的显示名如果不叫"退出",那么其位置一定要位于最后即Navigator标签的最后一个元素;
	-->

	<!--
		课程列表 CourseList标签下可有多个Course(课程)；
		Course标签下有0或1个Lecture(讲师)和多个Chapter（章,Course下最少有一个章节点）；Course标签的属性有：name、title、startSWF（开篇动画即片头）、endSWF。
		Chapter标签下有0个或多个Section（节）,当Chapter无子节点时为单章动画；Chapter标签的属性有：name（必填）、title、path(单章动画路径)、type（"flash"/"flex"/"image"/"flv"默认为"flash"）、xml(对应的xml配置文件)。
		Section标签的属性有:name（必填）、title、path(必填)、type（"flash"/"flex"/"image"/"flv"默认为"flash"）、xml(对应的xml配置文件)。
		Lecture标签没有属性,只有子节点:name、sex、age、position、introduction。其值以标签对形式出现，如：<name>讲师名</name>
	-->