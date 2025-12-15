package data;

enum abstract DrinkName(String) from String to String {
    var Beer;
    var Soda;
    var RumAndCoke = "Rum and Coke";
    var Whiskey;
    var Wine;
    var Vodka;
    var Water;
}

enum abstract DrinkAttribute(String) from String to String  {
    var Iced;
    var Stirred;
    var Shaken;
}

typedef Drink = {
    var ingredients:Map<Ingredient, Int>;
    var attributes:Array<DrinkAttribute>;
}

typedef MenuDrink = {
    var name:DrinkName;
    var description:String;
	var price:Int;
    var instructions:Drink; // how to make
}
