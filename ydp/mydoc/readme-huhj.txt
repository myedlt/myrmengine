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
		
