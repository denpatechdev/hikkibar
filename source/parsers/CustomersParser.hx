package parsers;

import data.Customer;
import haxe.Json;
import openfl.Assets;

class CustomersParser {
    public static function fromFile(file:String) {
        return fromString(Assets.getText(file));
    }

    public static function fromString(str:String) {
        var customers:Array<Customer> = [];
        var data = Json.parse(str);
        for (i in 0...data.customers.length) {
            customers.push(cast data.customers[i]);
        }
        return customers;
    }
}