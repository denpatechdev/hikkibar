package tools;

import data.Drink;
import data.Ingredient;
import haxe.Json;
import haxe.ds.ArraySort;
import openfl.Assets;

class DrinkTools {

	public static var drinks:Map<DrinkName, MenuDrink> = [];

	public static function loadDrinks()
	{
		var data = Json.parse(Assets.getText('assets/data/drinks.json'));
		for (i in 0...data.drinks.length)
		{
			var drink = data.drinks[i];
			/*
						typedef Drink = {
				var ingredients:Map<Ingredient, Int>;
				var attributes:Array<DrinkAttribute>;
				}
			 */
			var ingredients:Map<Ingredient, Int> = [];
			for (j in 0...drink.ingredients.length)
			{
				ingredients[drink.ingredients[j][0]] = cast(drink.ingredients[j][1], Int);
			}
			drinks[drink.name] = {
				name: drink.name,
				description: drink.description,
				instructions: {ingredients: ingredients, attributes: drink.attributes}
			};
		}

		return drinks;
	}

    public static function countIngredients(drink:Drink) {
        var num:Int = 0;
        for (k in drink.ingredients.keys())
            num++;
        return num;
    }

	public static function getSummedQuantity(drink:Drink)
	{
		var sum:Int = 0;
		for (k in drink.ingredients.keys())
		{
			sum += drink.ingredients[k];
		}
		return sum;
	}

    public static function isEqual(drinkA:Drink, drinkB:Drink) {
        if (countIngredients(drinkA) != countIngredients(drinkB) || drinkA.attributes.length != drinkB.attributes.length)
            return false;

        for (k in drinkA.ingredients.keys()) {
            if (!drinkB.ingredients.exists(k) || drinkB.ingredients[k] != drinkA.ingredients[k]) {
                return false;
            }
        }

		// sort code by ashes999
		drinkA.attributes.sort(function(a:String, b:String):Int
		{
			a = a.toUpperCase();
			b = b.toUpperCase();

			if (a < b)
			{
				return -1;
			}
			else if (a > b)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		});

		drinkB.attributes.sort(function(a:String, b:String):Int
		{
			a = a.toUpperCase();
			b = b.toUpperCase();

			if (a < b)
			{
				return -1;
			}
			else if (a > b)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		});

        for (i in 0...drinkA.attributes.length) {
            if (drinkB.attributes[i] != drinkA.attributes[i]) {
                return false;
            }
        }

        return true;
    }

	public static inline function ingredientExists(drink:Drink, ingredient:Ingredient)
	{
		return drink.ingredients != null && drink.ingredients.exists(ingredient);
	}

	public static function addIngredient(drink:Drink, ingredient:Ingredient)
	{
		if (ingredientExists(drink, ingredient))
		{
			drink.ingredients[ingredient]++;
			return true;
		}
		else
		{
			drink.ingredients[ingredient] = 1;
			return true;
		}

		return false; // should never happen, but just keeping it to look 'clean' with the addAttribute func
	}

	public static inline function attributeExists(drink:Drink, attribute:DrinkAttribute)
	{
		return drink.attributes != null && drink.attributes.contains(attribute);
	}

	public static function addAttribute(drink:Drink, attribute:DrinkAttribute)
	{
		if (!attributeExists(drink, attribute))
		{
			drink.attributes.push(attribute);
			return true;
		}

		return false;
	}

	public static inline function clearDrink(drink:Drink)
	{
		drink.ingredients = [];
		drink.attributes = [];
		return drink;
	}
}