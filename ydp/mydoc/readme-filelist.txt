minipublisher
	build.xml
	local.properties
	/editor
		/branches
		/tags
		/trunk
			/editor.online
				=>editor
			/ext_scorm
				=>lib,ext_scorm
			/fbEditor.online
				=>fbEditor.online
			/miniPublisher
				=>AirEditor
				build.xml
					=>air分发程序需要数字签名；FlexBuilder中export release build可以生成air包
					=》{FLEX_HOME}/bin/adt -certificate -cn selfsign -ou test -o test -c CN 1024-RSA testcert.pfx hhj123
			/miniPublisherLib
				=>lib,miniPublisherLib
			/nexl
				=>...
			/nexlFlex
				=>lib,nexlFlex
			/nexlViews
				=>lib,nexlViews
			/utopia.edit.lib
				=>lib,utopia.edit.lib
			/utopia.lib
				=>lib,utopia.lib.flex3
			/utopia_calendar
				=>lib,utopia_calendar
			/utopia_puzzle
				=>lib,utopia_puzzle
	/incubator
	/player
		/branches
		/tags
		/trunk
			build.xml
				默认任务package=》dist+prepare.flash.extension
					打包（运行程序和源码、Adobe扩展）
				dist=》运行分发程序
				prepare.flash.extension=》将mxi文件打包为mxp,看来有部分代码是Flash组件;
					需手动安装这个组件(直接双击mxp安装不成功，提示需Flash Player 9=>因为启动的是旧版的em；手动启动extension manager安装ok)；用于在Flash应用中嵌入utPlayer；
				avm1.proxy=》？
				install=》将utPlayer.swf拷贝到安装目录，可用于Web服务器的发布测试
				install.packages=》拷贝打包文件到安装目录
				docs=》
				clean=》
			defaults.properties
			flex.xml
			local.properties
			utopia4flash.mxi
			/nexl		=》Flex library project,生成swc供其他flex项目作为lib使用，就像Flex SDK的swc一样
				build.xml	=>最主要任务生成nexl.swc
				/bin
				/jsfl	=>似乎这个swc FlashCS3也能使用
			/utopia.demo.player	=》Flex project，演示播放器应用
			/utopia.lib	=》Flex 3 library project，共用组件库
			/utopia.players	=》Flex project，多个播放器
			/utopia.test.temp=》Flex project，2.0版程序，需改造
			/utopia.test.unit	=》Flex project，自动化单元测试，可在Eclipse中执行
	/tools
		/trunk