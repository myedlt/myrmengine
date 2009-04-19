//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************//

import MMQuizzingV3.MMSlideClasses.ISlideContent;

[Event("isScrubbingChanged")]
/*
	{type:"isScrubbingChanged", target:ISlideContent, isScrubbing:Boolean, fromHB:Boolean}
	
	This event is broadcast whenever user-controlled scrubbing begins or ends.
	Generally, isScrubbingChanged with isScrubbing=true is broadcast when the user
	mouses down on the scrub bar, then a bunch of scrubChanged events are sent,
	then isScrubbingChanged with isScrubbing=true is broadcast when the user mouses up.
*/

[Event("viewModeChanged")]
/*
	{type:"viewModeChanged", target:ISlideContent, mode:"normal" or "mini"}
	
	This event is broadcast whenever the user changes view mode to/from normal/mini mode.
*/

[Event("sidebarCheckboxChanged")]
/*
	{type:"sidebarCheckboxChanged", target:ISlideContent, isChecked:Boolean}
	
	This event is broadcast whenever the user changes the state of the sidebar-checkbox.
	If there is no sidebar-checkbox, or if it is not visible, this event will never be broadcast.
*/

[Event("quizSlideReached")]
/*
	{type:"quizSlideReached", target:ISlideContent, slideNum:Number, fromHB:Boolean}
	
	This event is broadcast whenever a quiz-related slide becomes the current slide.
	Note that this event is broadcast AFTER the slideChanged event for a given slide.
*/

/*
	Note that ISlideContent2 ALSO broadcasts the same events
	as ISlideContent, but the event object contain the
	following additional fields:
	
		fromHB:Boolean	(required)
			if true, the event came as a result of the heartbeat advancing.
			if false, the event did not.

*/

[Event("playStateChanged")]
/*
	{type:"playStateChanged", target:ISlideContent, isPlaying:Boolean [, scrub:Number]}
	
	this event may now optionally include the scrub value, which specifies the 
	currentscrub value when the event was sent.
*/

[Event("scrubChanged")]
/*
	{type:"scrubChanged", target:ISlideContent, scrub:Number [, isPlaying:Boolean]}

	this event may now optionally include the isPlaying value, which specifies the 
	playing state when the event was sent.
*/

[Event("syncModeChanged")]
/*
	{type:"syncModeChanged", target:ISlideContent, syncMode:String}
	
	@todo srj -- document me
*/

/*
	additional well-defined values for showUI:

		"presentationtitle"		show/hide the presentation title
		"presenterphoto"		show/hide the presenter's photo
		"presentername"			show/hide the presenter's name
		"presentertitle"		show/hide the presenter's title
		"presenteremail"		show/hide the presenter's contact info
		"presenterbio"			show/hide the presenter's bio
		"companylogo"			show/hide the company logo (not the breeze logo!)
		"sidebar"				show/hide the entire sidebar
		"outline"				show/hide the outline tab view in the sidebar
		"thumbnail"				show/hide the thumbnail tab view in the sidebar
		"notes"					show/hide the notes tab view in the sidebar
		"search"				show/hide the search tab view in the sidebar
		"attachments"			show/hide the button for opening the attachments window
		"volume"				show/hide the volume control menu
		"playbar"				show/hide the entire control bar
		"talkinghead"			show/hide the "talking head" video, if any
		"sidebaronright"		if true, sidebar goes on right; if false, sidebar goes on left
		"viewchange"			show/hide the "change view mode" button
		"margins"				show/hide the margins (top, left, bottom, right)
		"initialdisplaymodeisnormal"	if true, go to full-UI mode; if false, go to mini-UI mode
		"allowrootscale"		if true, allow scaling of the UI instead of layout-to-fit (defaults to false)
		"sidebarenable"			enable/disable the entire sidebar
		"playbarenable"			enable/disable the entire sidebar
		"show_sidebarcheckbox"	show the "show sidebar to participants" checkbox (defaults to false)
		"set_sidebarcheckbox"	set the value of the sidebar checkbox. (defaults to false; ignored if show_sidebarcheckbox is false)
*/

interface MMQuizzingV3.MMSlideClasses.ISlideContent2 extends ISlideContent
{
	// return the volume used for playback (0-100).
	public function getVolume():Number;    // 0-100

	// set the volume used for playback (0-100).
	public function setVolume(v:Number):Void;

	// return true if the scrub-bar is currently being manipulated by the user, false if not.
	public function getIsScrubbing():Boolean;
	
	// returns true if the content supports syncing in Breeze live.  Certain content, like that which
	// contains interactivity (e.g. questions), can't easily be run in a synchronous way with one presenter
	// driving  simultaneously in lock step the content on the rest of the students machines.  This is because
	// the runtime state of the user's machine won't be identical to that of the presenter since not all events and 
	// mouse-clicks are sent from the presenter to the student machines.
	// This getter allows the container to know that it shouldn't try to attempt to run the content in a synchronous mode.
	public function getSupportsSyncPlayback():Boolean;

	// If set to false, this will prevent the content from "force
	// quitting" the container when the user attempts to exit the course.  In the
	// case of content running inside of Breeze Live, for instance, we
	// DON'T want the content to quit the container.  However, when we
	// are running "stand-alone" in Breeze, we do want to allow the
	// content to quit the containing browser window.  The default is
	// true.
	public function setAllowForceQuitContainer(allow:Boolean):Void;
	
	/*
		Allows us to inquire if the content has certain properties, based
		on a given selector. If the content does not understand a selector,
		it should return undefined (not true or false). Currently well-defined
		selectors are:
			
			"talkingheadvideo"   returns true if the content contains "talking-head"
									style video on any slide (not just the current slide)
		
	*/
	public function hasProperty(prop:String):Boolean;

	// returns an object of the form 
	//
	//		{left:Number, top:Number, right:Number, bottom:Number}.
	//
    // these are distance from the borders of the toplevel MovieClip 
    // of the slide content to the slide viewing area, 
    // and are in the coordinate system of that toplevel movieclip.
    public function getSlideViewMetrics():Object;

	// @todo srj -- document me
	// valid args: "normal", "syncPlay", "syncPause"
    public function setSyncMode(p_mode:String):Void;

	// @todo srj -- document me
	// atomically set play and scrub pos; important for net sync
	// returns false (and does NOTHING) if unable to atomically set
	// (default implementation just returns false)
    public function setPlayAndScrub(p_playing:Boolean, p_position:Number):Boolean;

	// called when the content is about to be closed -- if you have
	// external resources to shutdown, close, release, etc., you must
	// do it here. (You should NOT close yourself, this is really "notification
	// that you are about to be forcibly destroyed")
    public function close():Void;
};
