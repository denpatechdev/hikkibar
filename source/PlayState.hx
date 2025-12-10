package;

import data.Drink;
import data.Menu;
import flixel.FlxG;
import flixel.FlxState;
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
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function save() {

	}
}
