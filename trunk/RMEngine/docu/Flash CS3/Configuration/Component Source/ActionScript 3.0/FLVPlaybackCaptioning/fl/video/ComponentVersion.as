// Copyright © 2004-2007. Adobe Systems Incorporated. All Rights Reserved.

	// version info for mx.video classes
	// this file is included by several classes in that package so that
	// this static is a member of each of those classes.
	
   /**
	* State variable indicating the long version number of the component.  
	* The version number is useful when you have a FLA file and need to know the component version.
	* To determine the component version, type the following trace into the FLA file:
	* 
	* <listing>trace (FLVPlaybackCaptioning.VERSION);</listing>
	* 
	* <p>The <code>VERSION</code> variable includes 
	* the major and minor version numbers as well as the revision and build numbers, 
	* for example, 2.0.0.xx. The <code>SHORT_VERSION</code> variable includes only the major 
	* and minor version numbers, for example, 2.0.</p>
	* 
    * @see #SHORT_VERSION SHORT_VERSION variable
    * @langversion 3.0
    * @playerversion Flash 9.0.28.0
 	*/ 
	public static const VERSION:String = "2.0.0.34";
	
	/**
	* State variable indicating the short version number of the component.  
	* The version number is useful when you have a FLA file and need to know the component version.
	* To determine the component version, type the following trace into the FLA file:
	* 
	* <listing>trace (FLVPlaybackCaptioning.SHORT_VERSION);</listing>
	* 
	* <p>The <code>SHORT_VERSION</code> variable includes only the major 
	* and minor version numbers, for example, 2.0. The <code>version</code> variable includes 
	* the major and minor version numbers as well as the revision and build numbers, 
	* for example, 2.0.0.xx.</p>
	* 
    * @see #VERSION VERSION variable
    *
    * @langversion 3.0
    * @playerversion Flash 9.0.28.0
	*/
	public static const SHORT_VERSION:String = "2.0";
