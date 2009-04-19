//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.QuizController;

class MMQuizzingV3.MMQuizClasses.rdQuizScoreDisplay extends MMQuizzingV3.MMQuizClasses.ScoreDisplay 
{
	private var m_nextAvailableDepth:Number;
	private var m_useBorders:Boolean;
	
	private var m_scoreTextField:TextField;
	private var m_scoreTextFormat:TextFormat;
	private var m_scoreTextFieldX:Number;
	private var m_scoreTextFieldY:Number;
	private var m_useScoreTextField:Boolean;
	
	private var m_maxScoreTextField:TextField;
	private var m_maxScoreTextFormat:TextFormat;
	private var m_maxScoreTextFieldX:Number;
	private var m_maxScoreTextFieldY:Number;
	private var m_useMaxScoreTextField:Boolean;
	
	private var m_numQuestionsTextField:TextField;
	private var m_numQuestionsTextFormat:TextFormat;
	private var m_numQuestionsTextFieldX:Number;
	private var m_numQuestionsTextFieldY:Number;
	private var m_useNumQuestionsTextField:Boolean;
	
	private var m_numRetriesTextField:TextField;
	private var m_numRetriesTextFormat:TextFormat;
	private var m_numRetriesTextFieldX:Number;
	private var m_numRetriesTextFieldY:Number;
	private var m_useNumRetiresTextField:Boolean;
	
	private var m_numQuizAttemptsTextField:TextField;
	private var m_numQuizAttemptsTextFormat:TextFormat;
	private var m_numQuizAttemptsTextFieldX:Number;
	private var m_numQuizAttemptsTextFieldY:Number;
	private var m_useQuizAttemptsTextField:Boolean;

	private var m_percentCorrectTextField:TextField;
	private var m_percentCorrectTextFormat:TextFormat;
	private var m_percentCorrectTextFieldX:Number;
	private var m_percentCorrectTextFieldY:Number;
	private var m_usePercentCorrectTextField:Boolean;

	private var m_numQuestionsCorrectTextField:TextField;
	private var m_numQuestionsCorrectTextFormat:TextFormat;
	private var m_numQuestionsCorrectTextFieldX:Number;
	private var m_numQuestionsCorrectTextFieldY:Number;
	private var m_useNumQuestionsCorrectTextField:Boolean;

	private var m_feedbackTextField:TextField;
	private var m_feedbackTextFormat:TextFormat;
	private var m_feedbackTextFieldX:Number;
	private var m_feedbackTextFieldY:Number;
	private var m_useFeedbackTextField:Boolean;

	function rdQuizScoreDisplay()
	{
		m_nextAvailableDepth = 0;
		m_useBorders = true;
		
		m_scoreTextFormat = new TextFormat();
		m_scoreTextFieldX = 0;
		m_scoreTextFieldY = 0;
		m_useScoreTextField = false;
		
		m_maxScoreTextFormat = new TextFormat();
		m_maxScoreTextFieldX = 0;
		m_maxScoreTextFieldY = 0;
		m_useMaxScoreTextField = false;
		
		m_numQuestionsTextFormat = new TextFormat();
		m_numQuestionsTextFieldX = 0;
		m_numQuestionsTextFieldY = 0;
		m_useNumQuestionsTextField = false;
				
		m_numRetriesTextFormat = new TextFormat();
		m_numRetriesTextFieldX = 0;
		m_numRetriesTextFieldY = 0;
		m_useNumRetiresTextField = false;

		m_numQuizAttemptsTextFormat = new TextFormat();
		m_numQuizAttemptsTextFieldX = 0;
		m_numQuizAttemptsTextFieldY = 0;
		m_useQuizAttemptsTextField = false;

		m_percentCorrectTextFormat = new TextFormat();
		m_percentCorrectTextFieldX = 0;
		m_percentCorrectTextFieldY = 0;
		m_usePercentCorrectTextField = false;

		m_numQuestionsCorrectTextFormat = new TextFormat();
		m_numQuestionsCorrectTextFieldX = 0;
		m_numQuestionsCorrectTextFieldY = 0;
		m_useNumQuestionsCorrectTextField = false;
		
		m_feedbackTextFormat = new TextFormat();
		m_feedbackTextFieldX = 0;
		m_feedbackTextFieldY = 0;
		m_useFeedbackTextField = false;
		
	}

	function init()
	{
		// Wait for this class to be fully loaded
		//myTrace("init() - m_scoreTextFormat="+m_scoreTextFormat);
		internalInit();
	}
	
	private function internalInit()
	{
		//super.init();
		if ((m_scoreTextFormat != null) && (m_scoreTextFormat != undefined) && (m_useScoreTextField))
		{
			this.createTextField("m_scoreTextField", this.getNextDepth(), m_scoreTextFieldX, m_scoreTextFieldY, 100, 100);
			//myTrace("internalInit() - m_scoreTextField="+m_scoreTextField);
			//myTrace("internalInit() - m_scoreTextFormat.size="+m_scoreTextFormat.size);
			m_scoreTextField.multiline = false;
			m_scoreTextField.autoSize = "left";
			m_scoreTextField.border = m_useBorders;
			m_scoreTextField.setNewTextFormat(m_scoreTextFormat);
		}
		if ((m_maxScoreTextFormat != null) && (m_maxScoreTextFormat != undefined) && (m_useMaxScoreTextField))
		{
			this.createTextField("m_maxScoreTextField", this.getNextDepth(), m_maxScoreTextFieldX, m_maxScoreTextFieldY, 100, 100);
			//myTrace("internalInit() - m_maxScoreTextField="+m_maxScoreTextField);
			m_maxScoreTextField.multiline = false;
			m_maxScoreTextField.autoSize = "left";
			m_maxScoreTextField.border = m_useBorders;
			m_maxScoreTextField.setNewTextFormat(m_maxScoreTextFormat);
		}
		if ((m_numQuestionsTextFormat != null) && (m_numQuestionsTextFormat != undefined) && (m_useNumQuestionsTextField))
		{
			this.createTextField("m_numQuestionsTextField", this.getNextDepth(), m_numQuestionsTextFieldX, m_numQuestionsTextFieldY, 100, 100);
			m_numQuestionsTextField.multiline = false;
			m_numQuestionsTextField.autoSize = "left";
			m_numQuestionsTextField.border = m_useBorders;
			m_numQuestionsTextField.setNewTextFormat(m_numQuestionsTextFormat);
		}	
		if ((m_numRetriesTextFormat != null) && (m_numRetriesTextFormat != undefined)&& (m_useNumRetiresTextField))
		{
			this.createTextField("m_numRetriesTextField", this.getNextDepth(), m_numRetriesTextFieldX, m_numRetriesTextFieldY, 100, 100);
			m_numRetriesTextField.multiline = false;
			m_numRetriesTextField.autoSize = "left";
			m_numRetriesTextField.border = m_useBorders;
			m_numRetriesTextField.setNewTextFormat(m_numRetriesTextFormat);
		}		
		if ((m_numQuizAttemptsTextFormat != null) && (m_numQuizAttemptsTextFormat != undefined) && (m_useQuizAttemptsTextField))
		{
			this.createTextField("m_numQuizAttemptsTextField", this.getNextDepth(), m_numQuizAttemptsTextFieldX, m_numQuizAttemptsTextFieldY, 100, 100);
			m_numQuizAttemptsTextField.multiline = false;
			m_numQuizAttemptsTextField.autoSize = "left";
			m_numQuizAttemptsTextField.border = m_useBorders;
			m_numQuizAttemptsTextField.setNewTextFormat(m_numQuizAttemptsTextFormat);
		}		
		if ((m_percentCorrectTextFormat != null) && (m_percentCorrectTextFormat != undefined) && (m_usePercentCorrectTextField))
		{
			this.createTextField("m_percentCorrectTextField", this.getNextDepth(), m_percentCorrectTextFieldX, m_percentCorrectTextFieldY, 100, 100);
			m_percentCorrectTextField.multiline = false;
			m_percentCorrectTextField.autoSize = "left";
			m_percentCorrectTextField.border = m_useBorders;
			m_percentCorrectTextField.setNewTextFormat(m_percentCorrectTextFormat);
		}		
		if ((m_numQuestionsCorrectTextFormat != null) && (m_numQuestionsCorrectTextFormat != undefined) && (m_useNumQuestionsCorrectTextField))
		{
			this.createTextField("m_numQuestionsCorrectTextField", this.getNextDepth(), m_numQuestionsCorrectTextFieldX, m_numQuestionsCorrectTextFieldY, 100, 100);
			m_numQuestionsCorrectTextField.multiline = false;
			m_numQuestionsCorrectTextField.autoSize = "left";
			m_numQuestionsCorrectTextField.border = m_useBorders;
			m_numQuestionsCorrectTextField.setNewTextFormat(m_numQuestionsCorrectTextFormat);
		}	
		if ((m_feedbackTextFormat != null) && (m_feedbackTextFormat != undefined) && (m_useFeedbackTextField))
		{
			this.createTextField("m_feedbackTextField", this.getNextDepth(), m_feedbackTextFieldX, m_feedbackTextFieldY, 100, 100);
			//myTrace("internalInit() - m_feedbackTextFormat.size="+m_feedbackTextFormat.size);
			m_feedbackTextField.multiline = false;
			m_feedbackTextField.autoSize = "left";
			m_feedbackTextField.border = m_useBorders;
			m_feedbackTextField.setNewTextFormat(m_feedbackTextFormat);
		}
	}
	
	private function getNextDepth():Number
	{
		//m_nextAvailableDepth++;
		//return m_nextAvailableDepth;
		return this.getNextHighestDepth();
	}
		
	public function set score(newScore:Number)
	{

		_score = newScore;		
		if ((m_scoreTextField != null) && (m_scoreTextField != undefined))
			m_scoreTextField.text = String(_score);
	}

	public function set maxScore(newMaxScore:Number)
	{
		_maxScore = newMaxScore;
		if ((m_maxScoreTextField != null) && (m_maxScoreTextField != undefined))
			m_maxScoreTextField.text = String(_maxScore);
		
	}
	
	public function set numQuestions(newNumQuestions:Number)
	{
		_numQuestions = newNumQuestions;
		if ((m_numQuestionsTextField != null) && (m_numQuestionsTextField != undefined))
			m_numQuestionsTextField.text = String(_numQuestions);
	}
	
	public function set numRetries(newNumRetries:Number)
	{
		_numRetries = newNumRetries;
		if ((m_numRetriesTextField != null) && (m_numRetriesTextField != undefined))
			m_numRetriesTextField.text = String(_numRetries);
	}
	
	public function set numQuizAttempts(newNumQuizAttempts:Number)
	{
		_numQuizAttempts = newNumQuizAttempts;
		if ((m_numQuizAttemptsTextField != null) && (m_numQuizAttemptsTextField != undefined))
			m_numQuizAttemptsTextField.text = String(_numQuizAttempts);
	}
	
	public function set percentCorrect(newPercentCorrect:String)
	{
		_percentCorrect = newPercentCorrect;
		if ((m_percentCorrectTextField != null) && (m_percentCorrectTextField != undefined))
			m_percentCorrectTextField.text = String(_percentCorrect);
	}


	public function set numQuestionsCorrect(newNumQuestionsCorrect:Number)
	{
		_numQuestionsCorrect = newNumQuestionsCorrect;
		if ((m_numQuestionsCorrectTextField != null) && (m_numQuestionsCorrectTextField != undefined))
			m_numQuestionsCorrectTextField.text = String(_numQuestionsCorrect);
	}
									

	public function set feedback(newFeedback:String)
	{
		//_feedback = newFeedback;
		if ((m_feedbackTextField != null) && (m_feedbackTextField != undefined))
			m_feedbackTextField.text = String(newFeedback);

	}
	
	/*public function set feedback(newFeedback:String)
	{
		var me = this;
		_feedback = newFeedback;
		if (me._feedbackMC && me._feedbackMC._valueMC) {
			me._feedbackMC._valueMC.feedback = _feedback;
		}
		if (_feedbackLbl) {
			_feedbackLbl.text = newFeedback;
		}

	}*/
	

	private function myTrace(msg:String)
	{
		//trace(">>>rdQuizScoreDisplay<<< "+msg);
	}
}