package;

import customers.BaseCustomer;
import customers.Test;
import data.Constants;
import data.Customer;
import data.DialogueState;
import data.Drink;
import data.Ingredient;
import data.Menu;
import data.ViewState.View;
import engines.DialogueEngine;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.drink.AttributeInteractable;
import objects.drink.IngredientInteractable;
import objects.particles.SnowEmitter;
import parsers.CustomersParser;
import tools.DrinkTools;

class PlayState extends FlxState
{

	// general
	public var bg:FlxSprite;
	public var characters:FlxTypedGroup<BaseCustomer>;
	public var sprites:FlxTypedGroup<FlxSprite>;

	// view variables
	public var oldView:View = CustomerView;
	public var curView:View = CustomerView;
	// false during dialogue
	public var canChangeView:Bool = true;

	// drink variables
	// current drink
	public var curDrink:Drink;
	// requested drink
	public var reqDrinkName:DrinkName;
	public var reqDrink:Drink;

	// interactables
	public var ingredientInteractables:FlxTypedGroup<IngredientInteractable>;
	public var attributeInteractable:FlxTypedGroup<AttributeInteractable>;

	// to move the camera left or right
	public var leftCamObj:FlxObject;
	public var rightCamObj:FlxObject;

	static final camObjTimeLimit:Float = .2;

	public var camObjTimer:Float = 0;
	public var camTweening:Bool = false;

	// bg stuff
	var snowEmitter:SnowEmitter;

	// customer stuff
	var curCustomer:BaseCustomer;
	var customersData:Array<Customer> = [];

	// dialogue stuff
	var dialogueEngine:DialogueEngine;

	var nameText:FlxText;
	var dialogueText:FlxTypeText;
	var choicesObjects:FlxTypedGroup<FlxButtonPlus>;

	var inDialogue:Bool = false;

	// drink stuff
	var drinkMade:Bool = false;

	// job stuff
	var money:Int;

	// restock stuff
	var inRestockMenu:Bool = false;

	public function new() {
		super();
		curDrink = {
			ingredients: [],
			attributes: []
		};
		reqDrink = {
			ingredients: [],
			attributes: []
		}
		customersData = [
			{
				name: "Test",
				drink: "Rum and Coke",
				dialoguePath: 'assets/data/dialogue/test.json'
			}
		];

		dialogueEngine = new DialogueEngine();
	}

	override public function create()
	{
		Menu.init();
		DrinkTools.loadDrinks();

		createInteractables();
		createCamObjs();

		super.create();
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		snowEmitter = new SnowEmitter(0, 0, 600);
		add(snowEmitter);
		snowEmitter.start(false, 0.01);

		characters = new FlxTypedGroup<BaseCustomer>();
		add(characters);

		sprites = new FlxTypedGroup<FlxSprite>();
		add(sprites);

		nameText = new FlxText(20, 20, 0, '', 24);
		dialogueText = new FlxTypeText(nameText.x, nameText.y + nameText.height + 20, 0, '', 24);
		nameText.color = dialogueText.color = FlxColor.GREEN;
		add(nameText);
		add(dialogueText);

		dialogueEngine.bind(nameText, dialogueText, choicesObjects, bg, characters, sprites);

		nextCustomer();

		dialogueEngine.runDialogue();
		inDialogue = true;
	}

	override public function update(elapsed:Float)
	{
		oldView = curView;
		manageView(elapsed);
		manageCamera();

		if (FlxG.keys.justPressed.ENTER && inDialogue)
		{
			dialogueEngine.progressDialogue();
		}

		if (dialogueEngine.isDialogueDone())
		{
			inDialogue = false;
		}

		if (!inDialogue)
		{
			if (FlxG.keys.justPressed.E && !drinkMade)
			{
				if (makeDrink() == reqDrinkName)
				{
					trace("LOL WIN");
					dialogueEngine.setBranch('correct');
					dialogueEngine.runDialogue();
					inDialogue = true;
					drinkMade = true;
				}
				else
				{
					trace("LOL LOSE");
					dialogueEngine.setBranch('incorrect');
					dialogueEngine.runDialogue();
					inDialogue = true;
					drinkMade = true;
				}
			}
		}

		super.update(elapsed);
	}

	function nextCustomer()
	{
		if (customersData.length == 0)
			return;

		if (curCustomer != null)
		{
			curCustomer.kill();
			curCustomer.destroy();
			characters.remove(curCustomer);
		}

		var curCustomerData = customersData.shift();
		switch (curCustomerData.name)
		{
			case 'Test':
				curCustomer = new Test(0, 0, curCustomerData.drink);
				curCustomer.screenCenter();
				characters.add(curCustomer);
				dialogueEngine.loadFromFile(curCustomerData.dialoguePath);
				dialogueEngine.setBranch(dialogueEngine.startBranch);
		}
		drinkMade = false;
		curCustomer.drink = curCustomerData.drink;
		setReqDrink(curCustomer.drink);
	}

	public function save() {

	}

	// Ingredient and attribute interactables are created and added to the state in this function
	function createInteractables() {}

	function addIngredient(ingredient:Ingredient)
	{
		if (DrinkTools.getSummedQuantity(curDrink) < Constants.MAX_INGREDIENTS)
			DrinkTools.addIngredient(curDrink, ingredient);
	}

	function addAttribute(attribute:DrinkAttribute)
	{
		DrinkTools.addAttribute(curDrink, attribute);
	}
	function createCamObjs()
	{
		leftCamObj = new FlxObject(0, 0, FlxG.width / 5, FlxG.height);
		rightCamObj = new FlxObject(FlxG.width - FlxG.width / 5, 0, FlxG.width / 5, FlxG.height);
		leftCamObj.scrollFactor.set();
		rightCamObj.scrollFactor.set();
		add(leftCamObj);
		add(rightCamObj);
		var a = new FlxSprite(FlxG.width).makeGraphic(FlxG.width, FlxG.height, FlxColor.RED);
		add(a);
		var a = new FlxSprite(-FlxG.width).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
		add(a);
	}

	function manageView(elapsed:Float)
	{
		if (camTweening)
			return;

		camObjTimer -= elapsed;

		if (camObjTimer > 0)
			return;

		switch (curView)
		{
			case CustomerView:
				if (FlxG.mouse.overlaps(leftCamObj))
				{
					camObjTimer = camObjTimeLimit;
					curView = RestockView;
					trace('CV: RV');
				}
				else if (FlxG.mouse.overlaps(rightCamObj))
				{
					camObjTimer = camObjTimeLimit;
					curView = DrinkView;
					trace('CV: DV');
				}
			case RestockView:
				if (FlxG.mouse.overlaps(rightCamObj))
				{
					camObjTimer = camObjTimeLimit;
					curView = CustomerView;
					trace('RV: CV');
				}
			case DrinkView:
				if (FlxG.mouse.overlaps(leftCamObj))
				{
					camObjTimer = camObjTimeLimit;
					curView = CustomerView;
					trace('DV: CV');
				}
		}
	}

	function manageCamera()
	{
		if (oldView == curView)
			return;

		switch (curView)
		{
			case CustomerView:
				FlxTween.tween(FlxG.camera, {"scroll.x": 0}, .4, {
					onComplete: _ ->
					{
						camTweening = false;
					}
				});
				camTweening = true;
			case RestockView:
				FlxTween.tween(FlxG.camera, {"scroll.x": -FlxG.width / 2}, .4, {
					onComplete: _ ->
					{
						camTweening = false;
					}
				});
				camTweening = true;
			case DrinkView:
				FlxTween.tween(FlxG.camera, {"scroll.x": FlxG.width / 2}, .4, {
					onComplete: _ ->
					{
						camTweening = false;
					}
				});
				camTweening = true;
		}
	}

	public function makeDrink()
	{
		for (k in DrinkTools.drinks.keys())
		{
			if (DrinkTools.isEqual(curDrink, DrinkTools.drinks[k].instructions))
			{
				return k;
			}
		}
		return null;
	}

	public inline function setReqDrink(name:String)
	{
		reqDrinkName = name;
		reqDrink = DrinkTools.drinks[name].instructions;
	}
}
