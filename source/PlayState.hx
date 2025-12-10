package;

import data.Constants;
import data.Drink;
import data.Ingredient;
import data.Menu;
import flixel.FlxG;
import flixel.FlxState;
import objects.drink.AttributeInteractable;
import objects.drink.IngredientInteractable;
import parsers.CustomersParser;
import tools.DrinkTools;

class PlayState extends FlxState
{

	// current drink
	public var curDrink:Drink;
	// requested drink
	public var reqDrink:Drink;

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
	}

	override public function create()
	{
		Menu.init();
		createInteractables();
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
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
}
