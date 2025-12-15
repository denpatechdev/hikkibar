package customers;

import data.Drink.DrinkName;
import flixel.FlxSprite;

class BaseCustomer extends FlxSprite {
    public var name:String;
    public var drink:DrinkName;

    public function new(?X:Float = 0, ?Y:Float = 0, Name:String, Drink:DrinkName) {
        super(X, Y);
        name = Name;
        drink = Drink;
    }
}