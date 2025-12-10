package tools;

import data.Drink;

class DrinkTools {

    public static var drinkMap:Map<DrinkName, Drink>;

    public static function countIngredients(drink:Drink) {
        var num:Int = 0;
        for (k in drink.ingredients.keys())
            num++;
        return num;
    }

    public static function isEqual(drinkA:Drink, drinkB:Drink) {
        if (countIngredients(drinkA) != countIngredients(drinkB) || drinkA.attributes.length != drinkB.attributes.length)
            return false;

        for (k in drinkA.ingredients.keys()) {
            if (!drinkB.ingredients.exists(k) || drinkB.ingredients[k] != drinkA.ingredients[k]) {
                return false;
            }
        }

        for (i in 0...drinkA.attributes.length) {
            if (drinkB.attributes[i] != drinkA.attributes[i]) {
                return false;
            }
        }

        return true;
    }


}