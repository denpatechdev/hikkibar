package engines;

import customers.BaseCustomer;
import data.DialogueState;
import data.dialogue.DialogueData.Choice;
import data.dialogue.DialogueData.DialogueBlock;
import data.dialogue.DialogueData.DialogueEvent;
import data.dialogue.DialogueData.EventFunc;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import haxe.Json;
import lime.utils.Assets;

class DialogueEngine {
    public var startBranch:String = "start";
    public var branches:Map<String, Array<DialogueBlock>> = []; 
    
    public var curIdx:Int = 0;
    public var curBranchName:String;
	public var curBranch:Array<DialogueBlock> = [];
	public var curBlock:DialogueBlock;
	public var curChoices:Array<Choice> = [];

    public var defaultTypingSpeed:Float = 0.016;

    public var events:Map<String, EventFunc> = [];

    public var nameText:FlxText;
    public var dialogueText:FlxTypeText;
    public var choices:FlxTypedGroup<FlxButtonPlus>;
    public var bg:FlxSprite;
    public var characters:FlxTypedGroup<BaseCustomer>;
    public var sprites:FlxTypedGroup<FlxSprite>;
    public var spriteTags:Map<String, FlxSprite> = [];

    public var typingDone:Bool = true;
    public var selectingChoices:Bool = false;

    public var dialogueFinished:Bool = false;

    public function new(?path:String) {
        if (path != null) {
            branches = loadFromFile(path);
            setBranch(startBranch);
            trace(curBranch);
            trace(curIdx);
            trace(curBlock);
        }
    }

    public function isDialogueDone() {
        return typingDone && curIdx >= curBranch.length - 1;
    }

    public function progressDialogue() 
    {
        if (!typingDone) {
            skipDialogue();
        } else if (!selectingChoices && typingDone && curIdx < curBranch.length - 1) {
            curIdx++;
            curBlock = curBranch[curIdx];
            curChoices = curBlock.choices;
            runDialogue();
        }
    }

    public function runDialogue() {
        var typingSpeed = defaultTypingSpeed;
        for (attr in curBlock.attrs) {
            if (attr.name == "typing_speed") {
                typingSpeed = attr.value;
            }
        }
        nameText.text = curBlock.name;
        dialogueText.resetText(curBlock.text);
        dialogueText.start(typingSpeed);
        typingDone = false;

        for (ev in curBlock.events) {
            handleEvent(ev);
        }
    }

    public function skipDialogue() {
        dialogueText.skip();
        typingDone = true;
        showChoices();
    }

    function handleEvent(ev:DialogueEvent) {

    }

    function showChoices() {

    }

    public function loadFromFile(path:String) {
        var ret:Map<String, Array<DialogueBlock>> = [];

        var jsonData = Json.parse(Assets.getText(path));
        var allDialogue:Array<Dynamic> = jsonData.dialogue;
        var branchNames:Array<String> = jsonData.branches;

        for (branch in allDialogue) {
            for (name in branchNames) {
                if (Reflect.field(branch, name) != null) {
                    ret.set(name, Reflect.field(branch, name));
                }
            }
        }
        branches = ret;
        return ret;
    }

    public function setBranch(name:String) {
        curBranchName = name;
        curBranch = branches[name];
        curIdx = 0;
        curBlock = curBranch[curIdx];
        curChoices = curBlock.choices;
    }

    public function bind(NameText:FlxText, DialogueText:FlxTypeText, Choices:FlxTypedGroup<FlxButtonPlus>, BG:FlxSprite, Characters:FlxTypedGroup<BaseCustomer>, Sprites:FlxTypedGroup<FlxSprite>) {
        nameText = NameText;
        dialogueText = DialogueText;
        choices = Choices;
        bg = BG;
        characters = Characters;
        sprites = Sprites;
        dialogueText.completeCallback = () -> {
            typingDone = true;
        }
    }

}

