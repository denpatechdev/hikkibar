package data.dialogue;

typedef DialogueAttr = {
	var name:String;
	var value:Dynamic;
}

typedef DialogueEvent = {
	var name:String;
	var args:Array<Dynamic>;
}

typedef Choice = {
	var text:String;
	var event:DialogueEvent;
}

typedef DialogueBlock = {
	var name:String;
	var text:String;
	var attrs:Array<DialogueAttr>;
	var events:Array<DialogueEvent>;
	var choices:Array<Choice>;
}

typedef EventFunc = (Array<Dynamic>, Bool) -> Void;