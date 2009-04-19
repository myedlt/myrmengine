package {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.events.Event;
    import fl.controls.RadioButton;
    import fl.controls.RadioButtonGroup;
   
    public class QuizQuestion extends Sprite {
        private var question:String;
        private var questionField:TextField;
        private var choices:Array;
        private var theCorrectAnswer:int;
        private var theUserAnswer:int;
       
        //variables for positioning:
        private var questionX:int = 25;
        private var questionY:int = 25;
        private var answerX:int = 60;
        private var answerY:int = 55;
        private var spacing:int = 25;
               
        public function QuizQuestion(theQuestion:String, theAnswer:int, ...answers) {
            //store the supplied arguments in the private variables:
            question = theQuestion;
            theCorrectAnswer = theAnswer;
            choices = answers;
            //create and position the textfield (question):
            questionField = new TextField();
            questionField.text = question;
            questionField.autoSize = TextFieldAutoSize.LEFT;
            questionField.x = questionX;
            questionField.y = questionY;
            addChild(questionField);
            //create and position the radio buttons (answers):
            var myGroup:RadioButtonGroup = new RadioButtonGroup("group1");
            myGroup.addEventListener(Event.CHANGE, changeHandler);
            for(var i:int = 0; i < choices.length; i++) {
                var rb:RadioButton = new RadioButton();
                rb.textField.autoSize = TextFieldAutoSize.LEFT;
                rb.label = choices[i];
                rb.group = myGroup;
                rb.value = i + 1;
                rb.x = answerX;
                rb.y = answerY + (i * spacing);
                addChild(rb);
            }
        }
       
        private function changeHandler(event:Event) {
            theUserAnswer = event.target.selectedData;
        }
        public function get correctAnswer():int {
            return theCorrectAnswer;
        }
        public function get userAnswer():int {
            return theUserAnswer;
        }
    }
}