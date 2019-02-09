
# Backmeals

Backmeals is an iOS-App for backpackers. It helps to keep track of the ingredients/food items you have, helps you remembering what ingredients you need for the dishes you normaly cook and provies a shopping list function.

## The basic features as a list

- "backpack" - list of ingredients you have
- "recipes" - list of provided and own recipes
- "shoppinglist" - self explanatory

## The Three Tabs
### 1. Backpack
The idea behind the backpack is that you add all the ingredients and food items you own to it. As a backpacker this number normaly is between 0 and 10. You can add items to the backpack by:
1. Use the "+" in the navigation bar
2. Swipe to the right in the "Shoppinglist"-tab on a item 

You can delete items from the backpack by swiping left on them.

### 2. Recipes
In the recipes tab you can see all the saved recipes you have. a recipe is a object that has a name and a list of ingredients. In the future it will include instructions as well.
There are "Stock Recipes" which are provided by the app. The developer can change them in the StockRecipes.json file.
There are also "Your Recipes" which can be added by taping on the "+" button in the navigation bar. To save the recipes they need a name and at least one ingredient.
"Your Recipes" can be deleted by a swipe to the left.

By tapping on a recipe the "Recipe Details"-screen shows. It tells you the name, a list of all the ingredients needed for this recipe and a list of ingredients you don't own but need.

The Rule is easy:

`"You don't have" = "Ingredients" - "Backpack-items" `

you can use the `Add to Shoppinglist` Button to add all these Ingredients you don't have to your ...

### 3. Shoppinglist
A simple list of the items you want to buy. Swipe left on an item to delete it or swipe right on an item to delete it from the shoppinglist and add it to your backpack "buy". You can add items by taping on the "+" in the navigation bar.

# License
Licensed under [ MIT License ](https://choosealicense.com/licenses/mit/#)

Thank you for the icons provided by [Iconshock](https://www.iconshock.com)
