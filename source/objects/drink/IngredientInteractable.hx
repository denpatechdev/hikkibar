package objects.drink;

import data.Drink;
import data.Ingredient;
import flixel.FlxG;
import flixel.FlxSprite;

class IngredientInteractable extends FlxSprite {
    public var ingredient:Ingredient;
    public var onClick:Void -> Void;

    public function new(?X:Float = 0, ?Y:Float = 0, Ingredient:Ingredient, OnClick:Void -> Void) {
        super(X, Y);
        ingredient = Ingredient;
        onClick = OnClick;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this)) {
            onClick();
        }
    }
    
}