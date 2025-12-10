package objects.drink;

import data.Ingredient;
import flixel.FlxG;
import flixel.FlxSprite;

class AttributeInteractable extends FlxSprite {
    public var attribute:Ingredient;
    public var onClick:Void -> Void;

    public function new(?X:Float = 0, ?Y:Float = 0, Attribute:Ingredient, OnClick:Void -> Void) {
        super(X, Y);
        attribute = Attribute;
        onClick = OnClick;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this)) {
            onClick();
        }
    }
    
}