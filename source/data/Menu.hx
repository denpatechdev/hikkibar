package data;

import data.Drink.DrinkName;
import data.Drink.MenuDrink;
import haxe.Json;
import openfl.Assets;

class Menu {
    public static var drinkMap:Map<DrinkName, MenuDrink> = [];

    public static function init() {
        var data:Dynamic = Json.parse(Assets.getText('assets/data/drinks.json'));
        for (i in 0...data.drinks.length) {
            var drinkData = data.drinks[i];
            var drink:Drink = {
                ingredients: [],
                attributes: []
            }
            // loop through JSON ingredients array and make it a map
            for (j in 0...drinkData.ingredients.length) {
                var name:Ingredient = cast drinkData.ingredients[j][0];
                var quantity:Int = cast drinkData.ingredients[j][1];
                drink.ingredients[name] = quantity;
            }

            // push attributes from JSON attributes array 
            for (j in 0...drinkData.attributes.length) {
                drink.attributes.push(drinkData.attributes[j]);
            }

            // create MenuDrink and map it a DrinkName
            drinkMap[drinkData.name] = {
                name: drinkData.name,
				price: drinkData.price,
                description: drinkData.description,
                instructions: drink
            };
        }

        #if debug
        trace('Drink Menu: ${drinkMap}');
        #end
    }

    public static function getDrink(name:DrinkName) {
        return drinkMap[name];
    }
}