// Copyright © 2004-2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.video {

	import flash.accessibility.Accessibility;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.utils.*;

	use namespace flvplayback_internal;

	/**
	 * Dispatched when a caption is added or removed from the caption target
	 * text field.  
	 * 
	 * <p>The event is also dispatched when the following conditions are true:</p>
	 * <ul>
	 * <li>the <code>captionTargetName</code> property is not set</li>
	 * <li>the <code>captionTarget</code> property is not set</li>
	 * <li>the FLVPlaybackCaptioning instance creates a TextField object automatically for captioning.</li>
	 * </ul>
	 * 
	 * <p>The <code>captionChange</code> event has the constant
	 * <code>CaptionChangeEvent.CAPTION_CHANGE</code>.</p>
	 * 
	 * 
	 * @see #captionTargetName 
	 * @see #captionTarget 
	 * @tiptext captionChange event
	 * @eventType fl.video.CaptionChangeEvent.CAPTION_CHANGE
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Event("captionChange", type="fl.video.CaptionChangeEvent")]

	/**
	 * Dispatched after the <code>captionTarget</code> property is created, 
	 * but before any captions are added (the <code>captionTarget</code> property
	 * is empty). 
	 * 
	 * <p>If the <code>captionTarget</code> property is set with a custom
	 * DisplayObject, or if the <code>captionTargetName</code> property is
	 * set, this event does not dispatch.</p>
	 *
	 * <p>Listen for this event if you are customizing the
	 * properties of the TextField object, for example, the <code>defaultTextFormat</code> property.</p>
	 * 
	 * <p>The <code>captionTargetCreated</code> event has the constant
	 * <code>CaptionTargetEvent.CAPTION_TARGET_CREATED</code>.</p>
	 *
	 * 
	 * @see #captionTargetName 
	 * @see #captionTarget 
	 * @see flash.display.DisplayObject 
	 * @tiptext captionTargetCreated event
	 * @eventType fl.video.CaptionTargetEvent.CAPTION_TARGET_CREATED
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */

	[Event("captionTargetCreated", type="fl.video.CaptionTargetEvent")]

	/**
	 * Dispatched after all of the Timed Text XML data is loaded. 
	 * 
	 * @see flash.net.URLLoader#event:complete URLLoader.complete event
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Event("complete", type="flash.events.Event")]

	/**
	 * Dispatched if a call to the <code>URLLoader.load()</code> event attempts to access a Timed Text XML file
	 * over HTTP and the current Flash Player environment is able to detect
	 * and return the status code for the request.
	 * 
	 * @see flash.net.URLLoader#event:httpStatus URLLoader.httpStatus event
	 * @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Event("httpStatus", type="flash.events.HTTPStatusEvent")]

	/**
	 * Dispatched if a call to the <code>URLLoader.load()</code> event results in a fatal error
	 * that terminates the download of the Timed Text XML file.
	 * 
	 * <p>If this event is not handled, it will throw an error.</p>
	 *
	 * @see flash.net.URLLoader#event:ioError URLLoader.ioError event
	 * @eventType flash.events.IOErrorEvent.IO_ERROR 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Event("ioError", type="flash.events.IOErrorEvent")]

	/**
	 * Dispatched when the download operation to load the Timed Text XML file
	 * begins, following a call to the <code>URLLoader.load()</code> method.
	 * 
	 * @see flash.net.URLLoader#event:open URLLoader.open event
	 * @eventType flash.events.Event.OPEN 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Event("open", type="flash.events.Event")]

	/**
	 * Dispatched when data is received as the download of the 
	 * Timed Text XML file progresses. 
	 * 
	 * @see flash.net.URLLoader#event:progress URLLoader.progress event
	 * @eventType flash.events.ProgressEvent.PROGRESS 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Event("progress", type="flash.events.ProgressEvent")]

	/**
	 * Dispatched if a call to the <code>URLLoader.load()</code> event attempts to load a 
	 * Timed Text XML file from a server outside the security sandbox. 
	 * 
	 * <p>If this event is not handled, it will throw an error.</p>
	 * 
	 * @see flash.net.URLLoader#event:securityError URLLoader.securityError event
	 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Event("securityError", type="flash.events.SecurityErrorEvent")]

	[IconFile("FLVPlaybackCaptioning.png")]
	[RequiresDataBinding(true)]

	/**
	 * The FLVPlaybackCaptioning component enables captioning for the FLVPlayback component.
	 * The FLVPlaybackCaptioning component downloads a Timed Text (TT) XML file
	 * and applies those captions to an FLVPlayback component to which this
	 * component is partnered.
	 *
	 * <p>For more information on Timed Text format, see
	 * <a href="http://www.w3.org/AudioVideo/TT/" target="_blank">http://www.w3.org/AudioVideo/TT/</a>.  The FLVPlaybackCaptioning component
	 * supports a subset of the
	 * Timed Text 1.0 specification.  For detailed information on the supported subset, see
	 * <a href="../../TimedTextTags.html">Timed Text Tags</a>. The following is a 
	 * brief example:</p>
	 *
	 * <pre>
	 * &lt;?xml version="1.0" encoding="UTF-8"?&gt;
	 * &lt;tt xml:lang="en" xmlns="http://www.w3.org/2006/04/ttaf1"  xmlns:tts="http://www.w3.org/2006/04/ttaf1#styling"&gt;
	 *     &lt;head&gt;
	 *         &lt;styling&gt;
	 *             &lt;style id="1" tts:textAlign="right"/&gt;
	 *             &lt;style id="2" tts:color="transparent"/&gt;
	 *             &lt;style id="3" style="2" tts:backgroundColor="white"/&gt;
	 *             &lt;style id="4" style="2 3" tts:fontSize="20"/&gt;
	 *         &lt;/styling&gt;
	 *     &lt;/head&gt;
	 *     &lt;body&gt;
	 *          &lt;div xml:lang="en"&gt;
	 *             &lt;p begin="00:00:00.50" dur="500ms"&gt;Four score and twenty years ago&lt;/p&gt;
	 *             &lt;p begin="00:00:02.50"&gt;&lt;span tts:fontFamily="monospaceSansSerif,proportionalSerif,TheOther"tts:fontSize="+2"&gt;our forefathers&lt;/span&gt; brought forth&lt;br /&gt; on this continent&lt;/p&gt;
	 *             &lt;p begin="00:00:04.40" dur="10s" style="1"&gt;a &lt;span tts:fontSize="12 px"&gt;new&lt;/span&gt; &lt;span tts:fontSize="300%"&gt;nation&lt;/span&gt;&lt;/p&gt;
	 *             &lt;p begin="00:00:06.50" dur="3"&gt;conceived in &lt;span tts:fontWeight="bold" tts:color="#ccc333"&gt;liberty&lt;/span&gt; &lt;span tts:color="#ccc333"&gt;and dedicated to&lt;/span&gt; the proposition&lt;/p&gt;
	 *             &lt;p begin="00:00:11.50" tts:textAlign="right"&gt;that &lt;span tts:fontStyle="italic"&gt;all&lt;/span&gt; men are created equal.&lt;/p&gt;
	 * 			&lt;p begin="15s" style="4"&gt;The end.&lt;/p&gt;
	 *         &lt;/div&gt;    
	 *     &lt;/body&gt;
	 * &lt;/tt&gt;
	 * </pre>
	 *
     * @includeExample examples/FLVPlaybackCaptioningExample.as -noswf
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0	 
	 */

	 	public class FLVPlaybackCaptioning extends Sprite {

		include "ComponentVersion.as"

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var ttm:TimedTextManager;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var visibleCaptions:Array;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var hasSeeked:Boolean;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var flvPos:Rectangle;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var prevCaptionTargetHeight:Number;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var captionTargetOwned:Boolean;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var captionTargetLastHeight:Number;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var captionToggleButton:Sprite;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var onButton:Sprite;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var offButton:Sprite;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var captionToggleButtonWaiting:Sprite;

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal static const AUTO_VALUE:String = "auto"; 
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var _captionTarget:TextField;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var _captionTargetContainer:DisplayObjectContainer;

		// full screen stuff
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var cacheCaptionTargetParent:DisplayObjectContainer;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var cacheCaptionTargetIndex:int;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var cacheCaptionTargetAutoLayout:Boolean;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var cacheCaptionTargetLocation:Rectangle;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var cacheCaptionTargetScaleY:Number;

		/**
		 * Used when keeing flvplayback skin above the caption
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal var skinHijacked:Boolean;


		// properties
		private var _autoLayout:Boolean;
		private var _captionsOn:Boolean;
		private var _captionURL:String;
		private var _flvPlaybackName:String;
		private var _flvPlayback:FLVPlayback;
		private var _captionTargetName:String;
		private var _videoPlayerIndex:uint;
		private var _limitFormatting:Boolean;
		private var _track:uint;

		/**
         * Creates a new FLVPlaybackCaptioning instance. 
         *  
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function FLVPlaybackCaptioning() {
			try {
				removeChild(getChildAt(0));
			} catch (e:Error) {
			}
			mouseEnabled = false;
			tabEnabled = false;
			visibleCaptions = new Array();
			_autoLayout = true;
			_captionsOn = true;
			_captionURL = "";
			_flvPlaybackName = AUTO_VALUE;
			_captionTargetName = AUTO_VALUE;
			_videoPlayerIndex = 0;
			_limitFormatting = false;
			_track = 0;
			addEventListener(Event.ENTER_FRAME, startLoad);
			// priority -1 to ensure that UIManager listener is called first
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}

        [Inspectable(defaultValue="true")]
	/**
	 * Used to display captions; <code>true</code> = display captions, 
	 * <code>false</code> = do not display captions.
         * 
         * <p>If you use the <code>captionButton</code> property to allow the
         * user to turn captioning on and off, set the <code>showCaptions</code>
         * property to <code>false</code>.</p>
         * 
         * @default true
         *
         * @see #captionButton 
         * 
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        public function get showCaptions():Boolean {
            return _captionsOn;
        }
        
        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set showCaptions(b:Boolean):void {
			if (_captionsOn == b) return;
			_captionsOn = b;
			if (!_captionsOn && _captionTarget != null) {
				_captionTarget.text = "";
				if (_autoLayout) {
					if (_captionTargetContainer != null) {
						_captionTargetContainer.visible = false;
					}
					_captionTarget.visible = false;
				}
			}
			if (_flvPlayback != null) {
				if (!_captionsOn) {
					removeFLVPlaybackListeners();
				} else {
					addFLVPlaybackListeners();
					displayCaptionNow();
				}
			}
			if (onButton != null) onButton.visible = _captionsOn;
			if (offButton != null) offButton.visible = !_captionsOn;
		}

        [Inspectable(defaultValue="")]
	/**
         * URL of the Timed Text XML file that contains caption information (<b>required property</b>).
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        public function get source():String {
            return _captionURL;
        }
        
        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set source(url:String):void {
			if (_captionURL == url) return;
			_captionURL = url;
			if (url != null && url != "") {
				addEventListener(Event.ENTER_FRAME, startLoad);
			}
		}

        [Inspectable(defaultValue="true")]
	/**
	 * Determines whether the FLVPlaybackCaptioning component
	 * automatically moves and resizes the TextField object for captioning.
	 *
	 * 
	 * <p>If the <code>autoLayout</code> property is set to <code>true</code>, the DisplayObject instance or 
	 * the TextField object containing the captions displays 10 pixels from the bottom
	 * of the FLVPlayback instance. The captioning area covers the width of
	 * the FLVPlayback instance, maintaining a margin of 10 pixels on each side.</p>
	 * 
	 * <p>When this property is set to <code>true</code>, the DisplayObject instance
	 * or TextField object displays directly over the FLVPlayback instance.
	 * If you are creating your own TextField object, you should set
	 * <code>autoLayout</code> to <code>false</code>. 
	 * If <code>wordWrap = false</code>, the captioning area centers over the FLVPlayback
	 * instance, but it can be wider than the FLVPlayback instance.</p>
	 * 
	 * <p>To control layout, you need to listen for the <code>captionChange</code> event to
	 * determine when the TextField object instance is created.</p>
	 * 
	 * @default true
	 * 
         * @see #captionTarget 
         * @see #event:captionChange captionChange event
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        public function get autoLayout():Boolean {
            return _autoLayout;
        }
        
        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set autoLayout(b:Boolean):void {
			if (b == _autoLayout) return;
			_autoLayout = b;
			if (_captionTarget != null && _autoLayout) {
				layoutCaptionTarget();
			}
		}

        [Inspectable(defaultValue="auto")]
	/**
	 * The instance name of the TextField object or MovieClip enclosing a Textfield object
	 * that contains the captions.
	 *
	 * <p>To specify no target, set this property to an empty string (that is, no target specified)
	 * or <code>auto</code>. This property is primarily used
	 * in the Component inspector. If you are writing code, use the
	 * <code>captionTarget</code> property instead.</p>
	 * 
	 * @default auto
	 *
         * @see #captionTarget 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        public function get captionTargetName():String {
            return _captionTargetName;
        }
        
        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set captionTargetName(tname:String):void {
			if (_captionTargetName == tname) return;
			_captionTargetName = tname;
			if (_captionTargetName == null || _captionTargetName.length < 1 || _captionTargetName == AUTO_VALUE) {
				_captionTarget = null;
			} else {
				var newCaptionTarget:DisplayObject = parent.getChildByName(_captionTargetName);
				if (newCaptionTarget != null) {
					captionTarget = newCaptionTarget;
				}
			}
		}

	/**
	 * Sets the DisplayObject instance in which to display captions. 
	 *
	 * <p>If you set the instance as a TextField object, it is targeted directly.
	 * If you set the instance as a DisplayObjectContainer
	 * containing one or more TextField objects, the captions display in the
	 * TextField object with the lowest display index.</p>
	 *
	 * <p>The <code>DisplayObjectContainer</code> method supports a movie-clip like object
	 * with a scale-9 background, which can be scaled when the TextField object size changes.</p>
	 *
	 * <p>For more complex scaling and drawing, write code to have the
	 * <code>DisplayObjectContainer</code> method listen for a <code>captionChange</code> event.</p>
	 * <p><b>Note</b> If the <code>captionTargetName</code> or the <code>captionTarget</code> property 
	 * is not set, the FLVPlaybackCaptioning instance creates a text field set by the
	 * <code>captionTarget</code> property with this formatting:</p>
	 *
	 * <ul>
	 * <li>black background (background = <code>true</code>; backgroundColor = <code>0x000000</code>;)</li>	
	 * <li>white text (textColor = <code>0xFFFFFF</code>)</li>
	 * <li>autoSize = <code>TextFieldAutoSize.LEFT</code></li>
	 * <li>multiLine = <code>true</code></li>
	 * <li>wordWrap = <code>true</code></li>
	 * <li>font = <code>"_sans"</code></li>
	 * <li>size = <code>12</code></li>
	 * </ul>
	 * 
	 * <p>To customize these values, listen for the <code>captionTargetCreated</code> event.</p>
	 * 
	 *
         * @see #captionTargetName 
         * @see flash.display.DisplayObjectContainer
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        public function get captionTarget():DisplayObject {
			if (_captionTargetContainer != null) {
				return _captionTargetContainer;
			}
            return _captionTarget;
        }
        
        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set captionTarget(ct:DisplayObject):void {
			if (ct is DisplayObjectContainer) {
				if (_captionTargetContainer != null && ct == _captionTargetContainer) return;
			} else {
				if (ct == _captionTarget) return;
			}
			if (_captionTarget != null) {
				if (captionTargetOwned) {
					_captionTarget.parent.removeChild(_captionTarget);
					captionTargetOwned = false;
				} else if (_flvPlayback != null && _flvPlayback.uiMgr._fullScreen) {
					exitFullScreenTakeOver();
				}
			}
			visibleCaptions = new Array();
			hasSeeked = false;
			prevCaptionTargetHeight = NaN;
			_captionTargetContainer = null;
			_captionTarget = null;
			if (ct is DisplayObjectContainer) {
				_captionTargetContainer = DisplayObjectContainer(ct);
				for (var i:int = 0; i < _captionTargetContainer.numChildren; i++) {
					var child:DisplayObject = _captionTargetContainer.getChildAt(i);
					if (child is TextField) {
						_captionTarget = TextField(child);
						break; 
					}
				}
			} else {
				_captionTarget = TextField(ct);
			}
			silenceCaptionTarget();
			if (_flvPlayback != null && _flvPlayback.uiMgr._fullScreen && _flvPlayback.fullScreenTakeOver) {
				enterFullScreenTakeOver();
			}
		}

	/**
	 * Defines the captionButton FLVPlayback custom UI component instance
	 * which provides toggle capabilities to turn captioning on and off. 
	 * 
	 * <p>The <code>captionButton</code> property functions similarly to the FLVPlayback
	 * properties <code>playButton</code>,
	 * <code>pauseButton</code>, <code>muteButton</code>, and so on.</p>
	 *
	 * @see FLVPlayback
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 */
		public function get captionButton():Sprite {
			if (captionToggleButtonWaiting != null) {
				return captionToggleButtonWaiting;
			}
			return captionToggleButton;
		}
		public function set captionButton(s:Sprite):void {
			if (captionToggleButtonWaiting != null) {
				if (s == captionToggleButtonWaiting) {
					return;
				} else {
					cleanupCaptionButton();
				}
				captionToggleButton = null;
			}
			if (s == captionToggleButton) return;
			if (_flvPlayback == null) {
				captionToggleButton = null;
				captionToggleButtonWaiting = s;
				addEventListener(Event.ENTER_FRAME, hookupCaptionToggle);
				return;
			}
			try {
				var uiMgr:UIManager = _flvPlayback.uiMgr;

				cleanupCaptionButton();

				captionToggleButton = s;
				uiMgr.ctrlDataDict[captionToggleButton] = new ControlData(uiMgr, captionToggleButton, null, -1);
				
				// setup the on and off buttons and states
				onButton = setupButton(Sprite(captionToggleButton.getChildByName("on_mc")), null, _captionsOn);
				offButton = setupButton(Sprite(captionToggleButton.getChildByName("off_mc")), null, !_captionsOn);

			} catch (e:Error) {
			}
		}

        [Inspectable(defaultValue="auto")]
	/**
	 * Sets an FLVPlayback instance name for the FLVPlayback instance
	 * that you want to caption. 
	 * 
	 * <p>To specify no target, set this to an empty string or <code>auto</code>.
	 * The FLVPlayback instance must have the same
	 * parent as the FLVPlaybackCaptioning instance.</p>
	 * 
	 * <p>The FLVPlayback instance name is primarily used in
	 * the Component inspector.  If you are writing code,
	 * use the <code>flvPlayback</code> property.</p>
	 * 
	 * <p>If the <code>flvPlaybackName</code> or  
	 * the <code>flvPlayback</code> property is not set or set to <code>auto</code>, 
	 * the FLVPlaybackCaptioning instance searches for a FLVPlayback
	 * instance with the same parent and captions the first one it finds.</p>
	 * 
	 * @default auto
	 *
         * @see FLVPlayback FLVPlayback class
         * @see #flvPlayback flvPlayback property
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        public function get flvPlaybackName():String {
            return _flvPlaybackName;
        }
        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set flvPlaybackName(flvname:String):void {
			if (_flvPlaybackName == flvname) return;
			_flvPlaybackName = flvname;
			if (_flvPlaybackName == null || _flvPlaybackName.length < 1 || _flvPlaybackName == AUTO_VALUE) {
				flvPlayback = null;
			} else {
				var newFLVPlayback:DisplayObject = parent.getChildByName(_flvPlaybackName);
				if (newFLVPlayback != null) {
					flvPlayback = FLVPlayback(newFLVPlayback);
				}
			}
		}

	/**
	 * Sets the FLVPlayback instance to caption.  The FLVPlayback
	 * instance must have the same parent as the
	 * FLVPlaybackCaptioning instance.
	 * <p>If the 
	 * <code>flvPlaybackName</code> or
	 * <code>flvPlayback</code> property is <b>not</b> set, the
	 * FLVPlaybackCaptioning instance will look for a FLVPlayback
	 * instance with the same parent and caption the first one it
	 * finds.</p>
	 *
         * @see #flvPlaybackName 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        public function get flvPlayback():FLVPlayback {
            return _flvPlayback;
        }
        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set flvPlayback(fp:FLVPlayback):void {
			if (fp == _flvPlayback) return;
			if (_flvPlayback != null) {
				removeFLVPlaybackListeners();
				if (skinHijacked) {
					var skin_mc:Sprite = _flvPlayback.uiMgr.skin_mc;
					skin_mc.x = 0;
					skin_mc.y = 0;
					_flvPlayback.addChild(skin_mc);
					skinHijacked = false;
				}
			}
			_flvPlayback = fp;
			if (_flvPlayback != null) {
				if (_captionsOn) {
					addFLVPlaybackListeners();
				}
				if (_captionTarget != null) {
					_captionTarget.text = "";
					if (_autoLayout) {
						_captionTarget.visible = false;
						if (_captionTargetContainer != null) {
							_captionTargetContainer.visible = false;
						}
					}
				}
				addEventListener(Event.ENTER_FRAME, startLoad);
				handleSkinLoad(null);
				displayCaptionNow();
			}
		}

	/**
	 * Support for multiple language tracks.  
	 * 
	 * <p>The best utilization of the <code>track</code> property
	 * is to support multiple language tracks with
	 * embedded cue points.</p>
	 * 
	 * <p>You must follow the supported formats for FLVPlaybackCaptioning
	 * cue points.</p>
	 *
	 * <p>If the <code>track</code> property is set to something other than <code>0</code>,
	 * the FLVPlaybackCaptioning component searches for a text&lt;n&gt; property on the cue point,
	 * where <em>n</em> is the track value.</p> 
	 * 
	 * <p>For example, if <code>track == 1</code>, then the FLVPlayBackCaptioning component
	 * searches for the parameter <code>text1</code> on the cue point.  If 
	 * no matching parameter is found, the text property in the cue point parameter is used.</p>
	 *
	 * @default 0
	 * 
	 * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public function get track():uint {
			return _track;
		}
		public function set track(i:uint):void {
			if (_track != i) {
				
			}
		}

	/**
	 * Connects the captioning to a specific VideoPlayer in the
	 * FLVPlayback component.
	 *
	 * <p> If you want to use captioning in
	 * multiple video players (using the <code>activeVideoPlayerIndex</code>
	 * and <code>visibleVideoPlayerIndex</code> properties in the FLVPlayback
	 * component), you
	 * should create one instance of the FLVPlaybackCaptioning
	 * component for each <code>VideoPlayer</code> that you will be using and set
	 * this property to correspond to the index.</p>
	 * 
	 * <p>The VideoPlayer index defaults to
         * 0 when only one video player is used.</p> 
         * 
         * @see FLVPlayback#activeVideoPlayerIndex 
         * @see FLVPlayback#visibleVideoPlayerIndex 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public function set videoPlayerIndex(v:uint):void {
			if (v == _videoPlayerIndex) return;
			_videoPlayerIndex = v;
			addEventListener(Event.ENTER_FRAME, startLoad);
		}
		public function get videoPlayerIndex():uint {
			return _videoPlayerIndex;
		}

        [Inspectable(defaultValue="false")]
	/**
	 * Limits formatting instructions 
	 * from the Timed Text file when set to <code>true</code>.
	 *
	 * <p>The following styles are <b>not</b> supported if the <code>simpleFormatting</code>
	 * property is set to <code>true</code>:</p>
	 * 
	 * <ul>
	 *   <li>tts:backgroundColor</li>
	 *   <li>tts:color</li>
	 *   <li>tts:fontSize</li>
	 *   <li>tts:fontFamily</li>
	 *   <li>tts:wrapOption</li>
	 * </ul>
	 *
	 * <p>The following styles <b>are</b> supported if the <code>simpleFormatting</code>
	 * property is set to <code>true</code>:</p>
	 * 
	 * <ul>
	 *   <li>tts:fontStyle</li>
	 *   <li>tts:fontWeight</li>
	 *   <li>tts:textAlign</li>
         * </ul>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	 */
		public function set simpleFormatting(b:Boolean):void {
			_limitFormatting = b;
		}
		public function get simpleFormatting():Boolean {
			return _limitFormatting;
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function forwardEvent(e:Event):void {
			if (e.type == Event.COMPLETE) {
				displayCaptionNow();
			}
			dispatchEvent(e);
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function startLoad(e:Event):void {
			// make sure we have an FLVPlayback
			if (_flvPlayback == null) {
				findFLVPlayback();
			}

			// remove enter frame event listener after calling findFLVPlayback
			// because that call can add the event listener back again!
			removeEventListener(Event.ENTER_FRAME, startLoad);

			// return if no flvPlayback property is set
			if (_flvPlayback == null) return;

			// we will try to hookup the toggle button if none has been hooked up
			if (captionToggleButton == null && captionToggleButtonWaiting == null) {
				addEventListener(Event.ENTER_FRAME, hookupCaptionToggle);
			}

			// if no caption url, don't load anything
			if (_captionURL == null || _captionURL == "") return;

			// check if this url has been loaded yet by this flv, in which case
			// we won't load anything
			var cacheActiveIndex:int = _flvPlayback.activeVideoPlayerIndex;
			var firstCuePoint:Object = _flvPlayback.findNearestCuePoint(0, CuePointType.ACTIONSCRIPT);
			_flvPlayback.activeVideoPlayerIndex = cacheActiveIndex;
			if (firstCuePoint != null) {
				var cuePoints:Array = firstCuePoint.array as Array;
				for (var i:int = 0; i < cuePoints.length; i++) {
					try {
						if (cuePoints[i].name.slice(0, 17) == "fl.video.caption.") {
							if (cuePoints[i].parameters.url == _captionURL) {
								return;
							}
						}
					} catch (err:Error) {
					}
				}
			}

			// load it!
			if (ttm == null) ttm = new TimedTextManager(this);
			ttm.load(_captionURL);
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function hookupCaptionToggle(e:Event):void {
			if (_flvPlayback == null) return;
			removeEventListener(Event.ENTER_FRAME, hookupCaptionToggle);
			if (captionToggleButtonWaiting == null) {
				for (var i:int = 0; i < parent.numChildren; i++) {
					var dispObj:DisplayObject = parent.getChildAt(i);
					var name:String = getQualifiedClassName(dispObj);
					if (name == "CaptionButton") {
						captionToggleButtonWaiting = Sprite(dispObj);
						break;
					}
				}
			}
			if (captionToggleButtonWaiting == null) return;
			var c:Sprite = captionToggleButtonWaiting;
			captionToggleButtonWaiting = null;
			captionButton = c;
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function handleCaption(e:MetadataEvent):void {
			var flv:FLVPlayback = (e.target == null) ? _flvPlayback : FLVPlayback(e.target);
			if ( e.vp != _videoPlayerIndex || !flv.getVideoPlayer(e.vp).visible ||
			     flv.scrubbing || e.info.name.slice(0, 17) != "fl.video.caption." ||
			     (e.info.parameters.url != undefined && e.info.parameters.url != _captionURL) ) {
				return;
			}
			var cp:Object = e.info;
			for (var i:int = 0; i < visibleCaptions.length; i++) {
				var compCP:Object = visibleCaptions[i];
				if ( compCP.name == cp.name && compCP.time == cp.time &&
				     ( (_track == 0 && compCP.parameters.text == cp.parameters.text) ||
				       (compCP.parameters["text" + _track] == cp.parameters["text" + _track]) ) ) {
					return;
				} 
			}
			var removedCaptions:Array = new Array();
			removeOldCaptions(e.info.time, removedCaptions);
			visibleCaptions.push(cp);
			if (_captionTarget == null) {
				_captionTargetContainer = null;
				createCaptionTarget();
			}
			if (_captionTarget.text.match(/^\s*$/)) {
				_captionTarget.htmlText = getCaptionText(cp);
			} else {
				_captionTarget.htmlText += getCaptionText(cp);
			}
			if (cp.parameters.backgroundColorAlpha != undefined) {
				_captionTarget.background = !cp.parameters.backgroundColorAlpha;
			}
			if (cp.parameters.backgroundColor != undefined) {
				_captionTarget.backgroundColor = cp.parameters.backgroundColor;
			}
			if (cp.parameters.wrapOption != undefined) {
				_captionTarget.wordWrap = cp.parameters.wrapOption;
			}
			layoutCaptionTarget();
			for (var j:int = 0; j < removedCaptions.length; j++) {
				dispatchEvent(new CaptionChangeEvent(CaptionChangeEvent.CAPTION_CHANGE, false, false, false, removedCaptions[j]));
			}
			dispatchEvent(new CaptionChangeEvent(CaptionChangeEvent.CAPTION_CHANGE, false, false, true, cp));
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function handleStateChange(e:VideoEvent):void {
			if (e.state == VideoState.SEEKING) {
				hasSeeked = true;
				return;
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function handleComplete(e:VideoEvent):void {
			removeOldCaptions(NaN);
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function handlePlayheadUpdate(e:VideoEvent):void {
			layoutCaptionTarget();
			if (e.state == VideoState.SEEKING) return;
			removeOldCaptions(e.playheadTime);
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function handleSkinLoad(e:VideoEvent):void {
			try {
				var uiMgr:UIManager = _flvPlayback.uiMgr;

				// find the avatar for captionToggle_mc in layout_mc
				var partAvatar:DisplayObject = uiMgr.layout_mc.getChildByName("captionToggle_mc");
				if (partAvatar == null) return;

				cleanupCaptionButton();

				// find the DisplayObject with this avatar in skin_mc
				var ctrlData:ControlData;
				var i:int = 0;
				while (i < uiMgr.skin_mc.numChildren) {
					ctrlData = uiMgr.ctrlDataDict[uiMgr.skin_mc.getChildAt(i)];
					if (ctrlData != null && ctrlData.avatar == partAvatar) break;
					i++;
				}
				if (i >= uiMgr.skin_mc.numChildren) return;

				// empty out the sprite to put our buttons in it
				captionToggleButton = Sprite(uiMgr.skin_mc.getChildAt(i));
				while (captionToggleButton.numChildren > 0) {
					captionToggleButton.removeChildAt(0);
				}
				captionToggleButton.graphics.clear();

				// setup the on and off buttons and states
				onButton = setupButton(null, "captionButtonOn", _captionsOn);
				offButton = setupButton(null, "captionButtonOff", !_captionsOn);

			} catch (e:Error) {
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function handleAddedToStage(e:Event):void {
			if (stage != null) {
				try {
					// priority -1 to ensure that UIManager listener is called first
					stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreenEvent, false, -1);
				} catch (se:SecurityError) {
				}
			}
			if (_flvPlayback == null) return;
			if (!_flvPlayback.uiMgr._fullScreen) {
				exitFullScreenTakeOver();
			} else if (_flvPlayback.fullScreenTakeOver) {
				enterFullScreenTakeOver();
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function handleFullScreenEvent(e:FullScreenEvent):void {
			if (_flvPlayback == null) return;
			if (!_flvPlayback.uiMgr._fullScreen) {
				exitFullScreenTakeOver();
			} else if (_flvPlayback.fullScreenTakeOver) {
				enterFullScreenTakeOver();
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		function enterFullScreenTakeOver():void {
			if (_flvPlayback == null || !_flvPlayback.uiMgr._fullScreen || cacheCaptionTargetParent != null || _captionTarget == null) return;

			// suspend this listener for the duration of the call
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false);

			try {
				var moveObj:DisplayObject = (_captionTargetContainer != null) ? _captionTargetContainer : _captionTarget;
				cacheCaptionTargetParent = moveObj.parent;
				cacheCaptionTargetIndex = moveObj.parent.getChildIndex(moveObj);
				cacheCaptionTargetAutoLayout = _autoLayout;
				cacheCaptionTargetLocation = new Rectangle(moveObj.x, moveObj.y, moveObj.width, moveObj.height);
				cacheCaptionTargetScaleY = moveObj.scaleY;

				var oldFLVPlaybackLoc:Rectangle = _flvPlayback.uiMgr.cacheFLVPlaybackLocation;
				var widthRatio:Number = _flvPlayback.registrationWidth / oldFLVPlaybackLoc.width;
				var heightRatio:Number = _flvPlayback.registrationHeight / oldFLVPlaybackLoc.height;
				captionTarget.scaleY *= Math.min(widthRatio, heightRatio);

				if (moveObj.stage != moveObj.parent) {
					moveObj.stage.addChild(moveObj);
				} else {
					moveObj.stage.setChildIndex(moveObj, moveObj.stage.numChildren - 1);
				}
				_autoLayout = true;
				layoutCaptionTarget();
			} catch (err:Error) {
				cacheCaptionTargetParent = null;
			}

			// re-add this listener after of the call
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, -1);
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		function exitFullScreenTakeOver():void {
			if (cacheCaptionTargetParent == null || _captionTarget == null) return;

			// suspend this listener for the duration of the call
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false);

			try {
				var moveObj:DisplayObject = (_captionTargetContainer != null) ? _captionTargetContainer : _captionTarget;
				if (cacheCaptionTargetParent.getChildAt(cacheCaptionTargetIndex) == _flvPlayback) {
					cacheCaptionTargetIndex++;
				}
				if (moveObj.parent != cacheCaptionTargetParent) {
					cacheCaptionTargetParent.addChildAt(moveObj, cacheCaptionTargetIndex);
				} else {
					cacheCaptionTargetParent.setChildIndex(moveObj, cacheCaptionTargetIndex);
				}
				moveObj.scaleY = cacheCaptionTargetScaleY;
				moveObj.x = cacheCaptionTargetLocation.x;
				moveObj.y = cacheCaptionTargetLocation.y;
				moveObj.width = cacheCaptionTargetLocation.width;
				moveObj.height = cacheCaptionTargetLocation.height;
				_autoLayout = cacheCaptionTargetAutoLayout;
				layoutCaptionTarget();
				
			} catch (err:Error) {
			}

			// re-add this listener after of the call
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, -1);

			cacheCaptionTargetParent = null;
			cacheCaptionTargetIndex = 0;
			cacheCaptionTargetLocation = null;
			cacheCaptionTargetScaleY = 0;
			cacheCaptionTargetAutoLayout = false;
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function cleanupCaptionButton():void {
			try {
				if (captionToggleButtonWaiting != null) {
					removeEventListener(Event.ENTER_FRAME, hookupCaptionToggle);
					captionToggleButtonWaiting = null;
				}
				var uiMgr:UIManager = _flvPlayback.uiMgr;

				// clean up handlers for old toggle button if necessary
				if (onButton != null) {
					uiMgr.removeButtonListeners(onButton);
					onButton.removeEventListener(MouseEvent.CLICK, handleButtonClick);
					delete uiMgr.ctrlDataDict[onButton];
					onButton = null;
				}
				if (offButton != null) {
					uiMgr.removeButtonListeners(offButton);
					offButton.removeEventListener(MouseEvent.CLICK, handleButtonClick);
					delete uiMgr.ctrlDataDict[offButton];
					offButton = null;
				}
				delete uiMgr.ctrlDataDict[captionToggleButton];
				captionToggleButton = null;
			} catch (e:Error) {
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function setupButton(ctrl:Sprite, prefix:String, vis:Boolean):Sprite {
			var uiMgr:UIManager = _flvPlayback.uiMgr;
			if (ctrl == null) {
				ctrl = setupButtonSkin(prefix);
			} else {
				var ctrlData:ControlData = new ControlData(uiMgr, ctrl, captionToggleButton, -1);
				uiMgr.ctrlDataDict[ctrl] = ctrlData;
				ctrlData.state = UIManager.NORMAL_STATE;
				ctrlData.enabled = true;
			}
			uiMgr.addButtonControl(ctrl);
			ctrl.removeEventListener(MouseEvent.CLICK, uiMgr.handleButtonEvent);
			ctrl.addEventListener(MouseEvent.CLICK, handleButtonClick);
			ctrl.visible = vis;
			if (ctrl.parent != captionToggleButton) {
				captionToggleButton.addChild(ctrl);
			}
			return ctrl;
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function handleButtonClick(e:MouseEvent):void {
			if (e.currentTarget == onButton) {
				showCaptions = false;
			} else if (e.currentTarget == offButton) {
				showCaptions = true;
			}
		}

		/**
		 * This function stolen from UIManager and tweaked.
		 * 
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function setupButtonSkin(prefix:String):Sprite {
			var uiMgr:UIManager = _flvPlayback.uiMgr;
			var ctrl:Sprite = new Sprite();
			var ctrlData:ControlData = new ControlData(uiMgr, ctrl, null, -1);
			uiMgr.ctrlDataDict[ctrl] = ctrlData;

			ctrlData.enabled = true;
			ctrlData.state_mc = new Array();

			ctrlData.state_mc[UIManager.NORMAL_STATE] =
				uiMgr.setupButtonSkinState(ctrl, uiMgr.skinTemplate, prefix + "NormalState");
			ctrlData.state_mc[UIManager.NORMAL_STATE].visible = true;
			ctrlData.currentState_mc = ctrlData.state_mc[UIManager.NORMAL_STATE];

			ctrlData.state_mc[UIManager.OVER_STATE] =
				uiMgr.setupButtonSkinState(ctrl, uiMgr.skinTemplate, prefix + "OverState", ctrlData.state_mc[UIManager.NORMAL_STATE]);

			ctrlData.state_mc[UIManager.DOWN_STATE] =
				uiMgr.setupButtonSkinState(ctrl, uiMgr.skinTemplate, prefix + "DownState", ctrlData.state_mc[UIManager.NORMAL_STATE]);

			ctrlData.disabled_mc =
				uiMgr.setupButtonSkinState(ctrl, uiMgr.skinTemplate, prefix + "DisabledState", ctrlData.state_mc[UIManager.NORMAL_STATE]);

			return ctrl;
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function removeOldCaptions(playheadTime:Number, removedCaptionsIn:Array=null):void {
			if (visibleCaptions.length < 1) return;
			var newVisibleCaptions:Array = new Array();
			var removedCaptions:Array = (isNaN(playheadTime)) ? visibleCaptions : (removedCaptionsIn == null) ? new Array() : removedCaptionsIn;
			var newText:String = "";
			if (!isNaN(playheadTime)) {
				for (var i:int = 0; i < visibleCaptions.length; i++) {
					var startTime:Number = visibleCaptions[i].time;
					var endTime:Number = visibleCaptions[i].parameters.endTime;
					if ( (!hasSeeked || startTime <= playheadTime) &&
					     ( (isNaN(endTime) && (removedCaptionsIn == null || visibleCaptions.length > i + 1)) ||
					       endTime > playheadTime ) ) {
						newVisibleCaptions.push(visibleCaptions[i]);
						newText += getCaptionText(visibleCaptions[i]);
					} else {
						removedCaptions.push(visibleCaptions[i]);
					}
				}
			}
			hasSeeked = false;
			visibleCaptions = newVisibleCaptions;
			_captionTarget.htmlText = newText;
			layoutCaptionTarget();
			if (removedCaptionsIn == null) {
				for (i = 0; i < removedCaptions.length; i++) {
					dispatchEvent(new CaptionChangeEvent(CaptionChangeEvent.CAPTION_CHANGE, false, false, false, removedCaptions[i]));
				}
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function findFLVPlayback():void {
			if (parent == null) return;
			for (var i:int = 0; i < parent.numChildren; i++) {
				if (parent.getChildAt(i) is FLVPlayback) {
					flvPlayback = FLVPlayback(parent.getChildAt(i));
					return;
				}
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function createCaptionTarget():void {
			captionTargetOwned = true;
			_autoLayout = true;
			_captionTarget = new TextField();
			silenceCaptionTarget();
			_captionTarget.autoSize = TextFieldAutoSize.LEFT;
			_captionTarget.multiline = true;
			_captionTarget.wordWrap = true;
			_captionTarget.background = true;
			_captionTarget.backgroundColor = 0x000000;
			_captionTarget.textColor = 0xFFFFFF;
			_captionTarget.visible = false;
			captionTargetLastHeight = _captionTarget.height;
			if (_flvPlayback != null) {
				_flvPlayback.addEventListener(LayoutEvent.LAYOUT, layoutCaptionTarget);
			}
			layoutCaptionTarget();
			parent.addChild(_captionTarget);
			if (_flvPlayback != null && _flvPlayback.uiMgr._fullScreen && _flvPlayback.fullScreenTakeOver) {
				enterFullScreenTakeOver();
			}
			dispatchEvent(new CaptionTargetEvent(CaptionTargetEvent.CAPTION_TARGET_CREATED, false, false, _captionTarget));
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function layoutCaptionTarget(e:LayoutEvent=null):void {
			// first handle hijacked skin_mc
			if (_flvPlayback != null && _flvPlayback.uiMgr.skin_mc != null) {
				if (_autoLayout && _captionTarget != null) {
					skinHijacked = true;
				}
				if (skinHijacked) {
					try {
						var skin_mc:Sprite = _flvPlayback.uiMgr.skin_mc;
						var theParent:DisplayObjectContainer = _flvPlayback.parent;
						if (skin_mc.parent != theParent) {
							theParent.addChild(skin_mc);
						}
						skin_mc.x = _flvPlayback.registrationX;
						skin_mc.y = _flvPlayback.registrationY;
						
						var indexObj:DisplayObject = (_captionTargetContainer != null) ? _captionTargetContainer : _captionTarget;
						if (indexObj != null) {
							var captionIndex:int = theParent.getChildIndex(indexObj);
							if (theParent.getChildIndex(skin_mc) < captionIndex) {
								theParent.setChildIndex(skin_mc, captionIndex);
							}
						}
					} catch (err:Error) {
					}
				}
			} else {
				skinHijacked = false;
			}

			// now laying out the captionTarget
			if (!_autoLayout || _captionTarget == null || _flvPlayback == null) return;
			if (_captionTarget.autoSize == TextFieldAutoSize.NONE) {
				_captionTarget.autoSize = TextFieldAutoSize.LEFT;
			}
			_captionTarget.visible = (_captionTarget.text.length > 0);
			if (_captionTargetContainer != null) {
				_captionTargetContainer.visible = _captionTarget.visible;
			}
			var vp:VideoPlayer = _flvPlayback.getVideoPlayer(_videoPlayerIndex);
			var newPoint:Point = _flvPlayback.localToGlobal(new Point(vp.x, vp.y));
			var newRect:Rectangle = new Rectangle(newPoint.x, newPoint.y, vp.width, vp.height)
			if ( !isNaN(prevCaptionTargetHeight) &&
			     prevCaptionTargetHeight == _captionTarget.height &&
			     flvPos != null && flvPos.equals(newRect) ) {
				return;
			}
			flvPos = newRect;
			var moveObj:DisplayObject = (_captionTargetContainer != null) ? _captionTargetContainer : _captionTarget;
			_captionTarget.width = flvPos.width - 20;
			if (moveObj.parent != null) {
				prevCaptionTargetHeight = _captionTarget.height;
				newPoint = moveObj.parent.globalToLocal(new Point(flvPos.x + 10, flvPos.y + flvPos.height - _captionTarget.height - 10));
				moveObj.x = newPoint.x;
				moveObj.y = newPoint.y;
				if (_captionTargetContainer != null) {
					for (var i:int = 0; i < _captionTargetContainer.numChildren; i++) {
						var child:DisplayObject = _captionTargetContainer.getChildAt(i);
						child.x = child.y = 0;
						if (child != _captionTarget) {
							child.width = _captionTarget.width;
							child.height = _captionTarget.height;
						}
					}
				}
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function addFLVPlaybackListeners():void {
			_flvPlayback.addEventListener(MetadataEvent.CUE_POINT, handleCaption);
			_flvPlayback.addEventListener(VideoEvent.STATE_CHANGE, handleStateChange);
			_flvPlayback.addEventListener(VideoEvent.PLAYHEAD_UPDATE, handlePlayheadUpdate);
			_flvPlayback.addEventListener(VideoEvent.COMPLETE, handleComplete);
			_flvPlayback.addEventListener(VideoEvent.SKIN_LOADED, handleSkinLoad);
			if (_captionTarget != null) {
				_captionTarget.htmlText ="";
				visibleCaptions = new Array();
				flvPos = null;
				hasSeeked = true;
				if (_autoLayout) {
					_flvPlayback.addEventListener(LayoutEvent.LAYOUT, layoutCaptionTarget);
				}
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function removeFLVPlaybackListeners():void {
			_flvPlayback.removeEventListener(MetadataEvent.CUE_POINT, handleCaption);
			_flvPlayback.removeEventListener(VideoEvent.STATE_CHANGE, handleStateChange);
			_flvPlayback.removeEventListener(VideoEvent.PLAYHEAD_UPDATE, handlePlayheadUpdate);
			_flvPlayback.removeEventListener(VideoEvent.COMPLETE, handleComplete);
			_flvPlayback.removeEventListener(VideoEvent.SKIN_LOADED, handleSkinLoad);
			_flvPlayback.removeEventListener(LayoutEvent.LAYOUT, layoutCaptionTarget);
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function getCaptionText(cp:Object):String {
			var cpText:String;
			if (_track != 0) {
				try {
					cpText = String(cp.parameters["text" + _track]);
				} catch (re:ReferenceError) {
					cpText = null;
				}
			}
			if (cpText == null) {
				cpText = cp.parameters.text;
			}
			return cpText;
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal function displayCaptionNow():void {
			try {
				var cacheActiveIndex:int = _flvPlayback.activeVideoPlayerIndex;
				var nowTime:Number = _flvPlayback.playheadTime;
				var firstCuePoint:Object = _flvPlayback.findNearestCuePoint(nowTime);
				_flvPlayback.activeVideoPlayerIndex = cacheActiveIndex;
				var index:int = int(firstCuePoint.index);
				var cuePoints:Array = firstCuePoint.array as Array;
				while ( index >= 0 &&
				        ( cuePoints[index].name.slice(0, 17) != "fl.video.caption." ||
				          cuePoints[index].parameters == undefined ||
				          (cuePoints[index].parameters.url != undefined && cuePoints[index].parameters.url != _captionURL) ) ) {
					index--;
				}
				if (index < 0) return;
				var cuePoint:Object = cuePoints[index];
				if ( cuePoint.time > nowTime ||
				     (!isNaN(cuePoint.parameters.endTime) && cuePoint.parameters.endTime <= nowTime) ) {
					return;
				}
				for (var i:int = 0; i < visibleCaptions.length; i++) {
					if ( (isNaN(cuePoint.parameters.endTime) && visibleCaptions[i].time > cuePoint.time) ||
					     (cuePoint.parameters.endTime <= visibleCaptions[i].time) ) {
						return;
					}
				}
				handleCaption(new MetadataEvent(MetadataEvent.CUE_POINT, false, false, cuePoint, _videoPlayerIndex));
			} catch (err:Error) {
			}
		}

		/**
		 * Keeps screen reader from reading captionTarget
		 * 
		 * @private
		 */
		flvplayback_internal function silenceCaptionTarget():void {
			var accProps:AccessibilityProperties = _captionTarget.accessibilityProperties;
			if (accProps == null) {
				accProps = new AccessibilityProperties();
			}
			accProps.silent = true;
			_captionTarget.accessibilityProperties = accProps;
			if (Capabilities.hasAccessibility) {
				Accessibility.updateProperties();
			}
		}

	} // class FLVPlaybackCaptioning

} // package fl.video
