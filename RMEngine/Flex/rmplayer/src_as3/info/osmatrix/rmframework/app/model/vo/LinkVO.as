package info.osmatrix.rmframework.app.model.vo
{
	public class LinkVO
	{
		public var id:String;
		public var label:String;
		public var url:String;		
		
		public function LinkVO(label:String=null,url:String=null)
		{
			this.label=label;
			this.url=url;
		}
	}
}