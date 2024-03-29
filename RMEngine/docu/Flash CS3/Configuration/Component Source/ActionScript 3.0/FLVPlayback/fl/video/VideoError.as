// Copyright � 2004-2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.video {

	use namespace flvplayback_internal;

    /**
     * The VideoError exception is the primary mechanism for reporting runtime errors from the 
     * FLVPlayback and VideoPlayer classes.
     *
     * @tiptext VideoError class
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	public class VideoError extends Error {

		include "ComponentVersion.as"

	/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		flvplayback_internal static const BASE_ERROR_CODE:uint = 1000;

	/**
         * State variable indicating that Flash Player is unable to make a connection to the server 
         * or to find the FLV file on the server.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const NO_CONNECTION:uint = 1000;

	/**
         * State variable indicating the illegal cue point.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const ILLEGAL_CUE_POINT:uint = 1002;

	/**
         * State variable indicating an invalid seek.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const INVALID_SEEK:uint = 1003;

	/**
         * State variable indicating an invalid source.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const INVALID_SOURCE:uint = 1004;

	/**
         * State variable indicating invalid XML.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const INVALID_XML:uint = 1005;

	/**
         * State variable indicating that there is no bitrate match.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const NO_BITRATE_MATCH:uint = 1006;

	/**
         * State variable indicating that the user cannot delete the default VideoPlayer object.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const DELETE_DEFAULT_PLAYER:uint = 1007;

	/**
         * State variable indicating that the INCManager class is not set.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const INCMANAGER_CLASS_UNSET:uint = 1008;

	/**
         * State variable indicating that a <code>null</code> URL was sent to the 
         * <code>load()</code> method.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const NULL_URL_LOAD:uint = 1009;

	/**
         * State variable indicating a missing skin style.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const MISSING_SKIN_STYLE:uint = 1010;

	/**
         * State variable indicating that an unsupported property was passed to the 
         * INCManager class, or the <code>getProperty</code> or <code>setProperty</code> 
         * methods.
	 *
	 * @see INCManager#getProperty()
	 * @see INCManager#setProperty()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public static const UNSUPPORTED_PROPERTY:uint = 1011;

		// code property
		private var _code:uint;

	/**
         * Creates a new VideoError object.
         *
         * @param errCode The code that corresponds to the error.
         *
         * @param msg The error message.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public function VideoError(errCode:uint, msg:String=null) {
			super( "" + errCode + ": " + ERROR_MSG[errCode - BASE_ERROR_CODE] +
			       ((msg == null) ? "" : (": " + msg)) );
			name = "VideoError";
			_code = errCode;
		}

	/**
         * The code that corresponds to the error. The error code is passed into the constructor.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public function get code():uint { return _code; }

	/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		flvplayback_internal static const ERROR_MSG:Array = [
			"Unable to make connection to server or to find FLV on server",
			"No matching cue point found",
			"Illegal cue point",
			"Invalid seek",
			"Invalid source",
			"Invalid xml",
			"No bitrate match, must be no default flv",
			"Cannot delete default VideoPlayer",
			"VideoPlayer.iNCManagerClass has not been set or its value is invalid",
			"Null url parameter sent to load()",
			"Skin is missing a required style definition or its value is invalid",
			"Unsupported property"
		];

	} // class VideoError

} // package fl.video
