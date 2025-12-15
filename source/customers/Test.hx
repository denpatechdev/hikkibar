package customers;

import data.Drink.DrinkName;

class Test extends BaseCustomer {
    public function new(?X:Float, ?Y:Float, Drink:DrinkName) {
        super(X, Y, "Test", Drink);
        loadGraphic('assets/images/characters/Test.png');
    }
}