TODO
	更新问题 403 forbidden
		minipublisher\player\branches\1.1.x\utopia.lib\avm1Proxy\ant.lib\flashAntTask 
			=》external另一个库，无法访问request for 'http://svn.ydp.com.pl/oss/trunk/flash/support/flashAntTask/flashAntTask/dist'
		minipublisher\player\branches\1.2.x\utopia.lib\src\pl\ydp\p2\modules\speechrecognition
		minipublisher\editor\trunk\utopia.edit.lib\src\pl\ydp\editor\module
	解决办法：
		单独checkout有问题的目录，然后并入主干目录		

Ant 调试记录:
	关键是配置ant执行目录下的local.properties
	minipublisher
		1) 进入Java开发Dev CMD；
		2）执行ant
		
		成功D:\ATemp\ydp\minipublisher\editor\trunk\nexl
		tags/0.10 sucess, ${product_version}
	qtiplayer
	
Eclipse 开发环境
	WS:
============================================
minipublisher
	build.xml
		=>编译player/editor的trunk目录
			第一句通过文件定路径属性变量base.dir，默认当前路径
			在本机目录和子模块目录下分别生成包
			各文件有自己的base.dir
		=>read local.properties
			调用子模块build.xml时传入本文件的定义
	local.properties
	/editor
		/branches
		/tags
			build.xml
			defaults.properties	=》版本号定义
			flex.xml
			local.properties
			/ant.lib
			/utopia.lib
				Flex library: utopia.lib.flex3
			/editor.online
				build.xml=>build.properties,上一级的flex.xml和export.xml
				build.properties
	
		/trunk
补充：
	trunk似乎是ydp的整理公开版，能完全update，branches中似乎有内部svn库代码的链接

2009/02/17 
	拷贝一份local.porperties后，ant编译temp下新checkout的editor/trunk目录，编译源码出错
	拷贝一份local.porperties后，ant编译temp下新checkout的player/trunk目录，成功只是package目录下的${product_version}变量未能有效替换
	bett2009 编译出错

如何建立编译环境
	1、安装Flex SDK 3.0
	2、安装Java环境
	3、安装Ant

	4、checkout源代码http://svn.ydp.com.pl/oss/projects/minipublisher
	5、参考local.properties.sample新建local.properties文件
	   编译目录：[有build.xml和local.properties的目录]=>进入目录执行devCMD;ant即可
		editor/trunk
