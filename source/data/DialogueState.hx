package data;

enum abstract DialogueState(Int) from Int to Int {
    var None; // not dialogue
    var Start; // before drink-making
    var PostDrink; // after drink is made
}