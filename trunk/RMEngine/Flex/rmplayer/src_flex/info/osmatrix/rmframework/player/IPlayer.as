package info.osmatrix.rmframework.player
{
	public interface IPlayer
	{
		// 页面模板初始化
		function initPlayer():void;
		
		// 加载页面: xml文件地址、资源文件根路径、上次播放位置
		function loadXML(url:String, root:String ):void;	
		function showXML():void;
		
		// 已用学习时间
		// function getTime():int;
		
		// 本次学习进度位置，视频：时间点；swf：幀；图片：第几张；		
		// function getLocation():String;	
		
		// function start():String;		// 开始播放，由loadXML调用
		// function stop():String;		// 停止播放
		// function resume():Boolean;	// 继续播放
		// function pause():Boolean;	// 暂停播放
	}
}