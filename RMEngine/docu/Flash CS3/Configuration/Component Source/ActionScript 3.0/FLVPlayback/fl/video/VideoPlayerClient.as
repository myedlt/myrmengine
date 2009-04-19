// Copyright © 2004-2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.video {

	use namespace flvplayback_internal;
	
	/**
     * @private
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	public dynamic class VideoPlayerClient {

		private var _owner:VideoPlayer;

		public function VideoPlayerClient(vp:VideoPlayer) {
			_owner = vp;
		}

		public function get owner():VideoPlayer {
			return _owner;
		}
		
		/**
		 * handles NetStream.onMetaData callback
		 *
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function onMetaData(info:Object, ...rest):void {
			_owner.onMetaData(info);
		}

		/**
		 * handles NetStream.onCuePoint callback
		 *
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function onCuePoint(info:Object, ...rest):void {
			_owner.onCuePoint(info);
		}
		
	} // class VideoPlayerClient

} // package fl.video
