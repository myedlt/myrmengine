//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMSlideClasses.IQuestionScore;

interface MMQuizzingV3.MMSlideClasses.ISlideContainer
{
	// Send interaction-level (question-level) tracking information 
	public function sendInteractionData(questionScore:IQuestionScore):String;
	
	// Send course-level tracking information.  If flush is true, force the information to 
	// be immediately written to the server.  
	public function sendCourseData(flush:Boolean):String


	// Informs the container that the user has hit an "exit" button and that container needs to call LMS shutdown code
	public function exitCourse():Void;
};
