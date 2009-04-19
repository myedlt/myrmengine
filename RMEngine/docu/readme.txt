/********************************************
 *	$Id: readme.txt 371 2009-02-27 10:57:00Z huhongjun@gmail.com $
 ********************************************/
项目名称：CourseWare Framework

SVN设置：
	CWFW项目添加Tortoise属性logminsize=12，限定在TortoiseSVN中提交时必须填写注释
	
bin-debug和html-template目录删除，不纳入版本管理，在FlexBuilder中导入项目后，需在项目上按右键重新生成html-template

puremvc源码通过svn externals方式获得，http://svn.puremvc.org/PureMVC_AS3/trunk/src

	
2009/02/26
	用MXML Application的形式实现三种播放器，可以同时在main.swf和html中使用
	三个播放器可以通过scorm.as类实现sco功能，需要检测外部是否html环境和SCORM适配器来决定是否调用外部的javascript函数
	播放器传入参数为xml文件；
	=》html中使用时通过Application的参数传入；
	=》flash中加载swf时如何传入参数
	
	QTIPlayer设计
		每种题型一个UI组件
	FLVPlayer设计
		支持xml打点文件
项目
	播放器			=》Flex项目
	课件主框架		=》Flex项目
	MainFlex.mxml	=》Flex项目
	MainFlash.fla	=》Flash项目
	
content.swf 接收xml文件参数，根据xml的参数选择对应的播放器，content属Flex应用，可在swf和html中使用。


笔记和学习记录可以考虑module方式开发
2009/03/16 index.swf若无-service编译，调用xmlEditor出错

2009/03/26	rmeditor的php代码硬编码路径为D://xampp//htdocs//rmeditor//