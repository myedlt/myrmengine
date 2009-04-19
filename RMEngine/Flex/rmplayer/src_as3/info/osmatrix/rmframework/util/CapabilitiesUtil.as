package info.osmatrix.rmframework.util {
	
	import flash.system.Capabilities;
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;

	public class CapabilitiesUtil {
		public static function getCapabilities():Array {
			var capDP:Array = new Array();
			capDP.push({label:"访问用户的摄像头和麦克风", name:"Capabilities.avHardwareDisable", value:Capabilities.avHardwareDisable}); 
			capDP.push({label:"支持辅助功能", name:"Capabilities.hasAccessibility", value:Capabilities.hasAccessibility}); 
			capDP.push({label:"具有音频功能", name:"Capabilities.hasAudio", value:Capabilities.hasAudio}); 
			capDP.push({label:"音频流编码", name:"Capabilities.hasAudioEncoder", value:Capabilities.hasAudioEncoder}); 
			capDP.push({label:"支持嵌入视频", name:"Capabilities.hasEmbeddedVideo", value:Capabilities.hasEmbeddedVideo}); 
			capDP.push({label:"安装有输入法编辑器", name:"Capabilities.hasIME", value:Capabilities.hasIME}); 
			capDP.push({label:"具有解码器", name:"Capabilities.hasMP3", value:Capabilities.hasMP3}); 
			capDP.push({label:"支持打印", name:"Capabilities.hasPrinting", value:Capabilities.hasPrinting}); 
			capDP.push({label:"开发通过FMS运行的屏幕广播应用", name:"Capabilities.hasScreenBroadcast", value:Capabilities.hasScreenBroadcast}); 
			capDP.push({label:"支持通过FMS运行的屏幕广播应用的回放", name:"Capabilities.hasScreenPlayback", value:Capabilities.hasScreenPlayback}); 
			capDP.push({label:"能播放音频流", name:"Capabilities.hasStreamingAudio", value:Capabilities.hasStreamingAudio}); 
			capDP.push({label:"能播放视频流", name:"Capabilities.hasStreamingVideo", value:Capabilities.hasStreamingVideo}); 
			capDP.push({label:"通过NetConnection支持本机SSL套接字", name:"Capabilities.hasTLS", value:Capabilities.hasTLS});
			capDP.push({label:"对视频流进行编码", name:"Capabilities.hasVideoEncoder", value:Capabilities.hasVideoEncoder});
			capDP.push({label:"特殊的调试版本", name:"Capabilities.isDebugger", value:Capabilities.isDebugger});
			capDP.push({label:"系统的语言代码", name:"Capabilities.language", value:Capabilities.language});
			capDP.push({label:"对用户硬盘的读取权限", name:"Capabilities.localFileReadDisable", value:Capabilities.localFileReadDisable});
			capDP.push({label:"Flash Player的制造商", name:"Capabilities.manufacturer", value:Capabilities.manufacturer});
			capDP.push({label:"当前的操作系统", name:"Capabilities.os", value:Capabilities.os});
			capDP.push({label:"屏幕的像素高宽比", name:"Capabilities.pixelAspectRatio", value:Capabilities.pixelAspectRatio});
			capDP.push({label:"播放器的类型", name:"Capabilities.playerType", value:Capabilities.playerType});
			capDP.push({label:"屏幕的颜色", name:"Capabilities.screenColor", value:Capabilities.screenColor});
			capDP.push({label:"屏幕的DPI,以像素为单位", name:"Capabilities.screenDPI", value:Capabilities.screenDPI});
			capDP.push({label:"屏幕的最大水平分辨率", name:"Capabilities.screenResolutionX", value:Capabilities.screenResolutionX});
			capDP.push({label:"屏幕的最大垂直分辨率", name:"Capabilities.screenResolutionY", value:Capabilities.screenResolutionY});
			capDP.push({label:"Flash Player平台和版本信息", name:"Capabilities.version", value:Capabilities.version});
			var navArr:Array = CapabilitiesUtil.getBrowserObjects();
			if (navArr.length > 0) {
				capDP = capDP.concat(navArr);
			}
			capDP.sortOn("name", Array.CASEINSENSITIVE);
			return capDP;
		}
		private static function getBrowserObjects():Array {
			var itemArr:Array = new Array();
			var itemVars:URLVariables;
			if (ExternalInterface.available) {
				try {
					var tempStr:String = ExternalInterface.call("JS_getBrowserObjects");
					itemVars = new URLVariables(tempStr);
					for (var i:String in itemVars) {
						itemArr.push({label:"浏览器对象", name:i, value:itemVars[i]});
					}
				} catch (error:SecurityError) {
					// ignore
				}
			}
			return itemArr;
		}
	}
}