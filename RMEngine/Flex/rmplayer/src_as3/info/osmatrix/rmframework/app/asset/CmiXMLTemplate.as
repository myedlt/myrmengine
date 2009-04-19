package info.osmatrix.rmframework.app.asset
{
	import mx.core.ByteArrayAsset;

	public class CmiXMLTemplate
	{
		[Embed("cmi_1.2.xml", mimeType="application/octet-stream")]
		private static const CmiXMLTemplate:Class;

		public static function getConfig():XML
		{
			var ba:ByteArrayAsset=ByteArrayAsset(new CmiXMLTemplate());
			var xml:XML=new XML(ba.readUTFBytes(ba.length));

			return xml;
		}
	}
}