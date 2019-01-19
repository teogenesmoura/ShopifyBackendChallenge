
# Harry's first walk on Diagon Alley

_"There were shops selling robes, shops selling telescopes and strange silver instruments Harry had never seen before, windows stacked with barrels of bat spleens and eels' eyes, tottering piles of spell books, quills, and rolls of parchment, potion bottles, globes of the moon..._""

![Harry Potter gif](https://media.giphy.com/media/U4kB6WUGv6THW/giphy.gif)

Although invisible to muggles, the Diagon Alley is where every wizard buys magical supplies in order to attend their first year at Hogwarts. However, since it's Harry's first time there, we'll help him by providing a ready-to-use shopping cart API with which he'll be able to create a cart and add all the item he needs to be happy and successful at school.

_well, we don't need to tell him about a certain someone who must not be named just yet, right?_

The API is ready for us and for Harry, so let's get started!

### Demo

There's an online version of our backend-server already up and running, so we'll start by going there. 

First, we need to create a shopping cart. In order to do so, we (and Harry too!) need to fire a POST request to the ```/cart``` endpoint in our API and create a new shopping cart. You might use any program or application that handles that kind of request. 

You can choose your favorite one or follow us by opening up your terminal (if you're on linux or mac) and using CURL in order to perform such requests, which is what we're going to do from now on.

Open your terminal and type:

```
curl -d "title=harry's shoping cart" -H "Content-Type: application/x-www-form-urlencoded" -X POST https://backendchallengeshopify.herokuapp.com/cart
```
which should give you the following response:

```
{"id":4,"title":"harry's shoping cart","total_amount":0.0,"created_at":"2019-01-19T20:22:56.148Z","updated_at":"2019-01-19T20:22:56.148Z"
```
_The JSON object the API sent to you contain might contain different numbers for the _id_ and _date_ fields, but don't worry as that is totally normal. Also, take note of the _id_ field, we'll need it later fellow wizard!_

Next, we'll need to create the products Harry is going to buy and add them to our API. As an example, we'll create two of the items included in Harry's school list: 

_A History of Magic_ by Bathilda Bagshot and 1 wand 
(_source:_ https://www.pottermore.com/book-extract-long/harrys-school-list)

In your terminal window, please type the following command:

```
curl -d "title=wand&price=50&inventory_count=10" -H "Content-Type: application/x-www-form-urlencoded" -X POST https://backendchallengeshopify.herokuapp.com/product
```
to which you should receive a response that looks like the following:
```
{"id":1,"title":"wand","price":50.0,"inventory_count":10,"created_at":"2019-01-19T20:31:26.927Z","updated_at":"2019-01-19T20:31:26.927Z"}
```
then, let's create the book item:
```
curl -d "title=A History of Magic&price=30&inventory_count=15" -H "Content-Type: application/x-www-form-urlencoded" -X POST https://backendchallengeshopify.herokuapp.com/product
```
If everything went correctly, you should have received a response like this:

```
{"id":2,"title":"A History of Magic","price":30.0,"inventory_count":15,"created_at":"2019-01-19T20:33:40.831Z","updated_at":"2019-01-19T20:33:40.831Z"}
```
Awesome! Now we have set up a shopping cart and the two products Harry will need. Next step comes naturally then: We'll need to add both products to the shopping cart we've created previously. To do so, type this in your terminal

```
curl -d "cartId=4&productId=1" -H "Content-Type: application/x-www-form-urlencoded" -X POST https://backendchallengeshopify.herokuapp.com/addProductToCart 
```
to add a wand to Harry's cart and then 
```
curl -d "cartId=4&productId=2" -H "Content-Type: application/x-www-form-urlencoded" -X POST https://backendchallengeshopify.herokuapp.com/addProductToCart
```
to add the book. 

Please note that we're using the _id_ field of the response provided by the server in order to add products to our shopping cart. Since the server returned 1 and 2 as _ids_ for the wand and the book respectively, that's what we use in our POST requests. 

Wonderful! Now we have a shopping cart that contains two products. Harry now needs to pay for those items (_no magical wrongdoings here boy!_) and we'll provide him with a _checkout_ endpoint in our API. The POST request that allows us to do that is the following:

```
{"cart":{"id":4,"title":"harry's shoping cart","total_amount":0.0,"created_at":"2019-01-19T20:22:56.148Z","updated_at":"2019-01-19T20:48:20.164Z"},"amount_charged":80.0}
```

With the response the server is telling us that everything went fine! The new total_amount in Harry's cart is $0 and the amount the store charged from him is $80, which is the sum of the price of the book and the wand. 

![enter image description here](https://media1.giphy.com/media/26gN27K98gXfnvEJy/giphy.gif?cid=3640f6095c438ddd6d71744a326a69d3)

To check if everything went really smoothly, we can perform one final check: Wether the items he bought were actually removed from the store's inventory or not. To do so, type this in your terminal:

```
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET https://backendchallengeshopify.herokuapp.com/products 
```
The response should be the following:

```
[{"id":1,"title":"wand","price":50.0,"inventory_count":9,"created_at":"2019-01-19T20:31:26.927Z","updated_at":"2019-01-19T21:00:00.533Z"},{"id":2,"title":"A History of Magic","price":30.0,"inventory_count":14,"created_at":"2019-01-19T20:33:40.831Z","updated_at":"2019-01-19T21:00:00.592Z"}] 
```

You can see that the inventory_count field for both items is 1 less than it was when we created both products (9 vs 10 and 14 vs 15), so we know the order happened just as we expected. 

That's it for our demo! I hope you enjoyed helping Harry fulfill his magical duties like a pro :) 

### Getting started

Oh! So you want to download the code and help Harry even more by coding your own functionality or improving the test coverage? Awesome! Here's what you need to do:

Start by cloning this repo:

```
git clone https://github.com/teogenesmoura/backendChallenge.git
```

run 
```
rake db:migrate
```
and you should be all set!  the app will be running on 
```
http://localhost:3000
```
If you run into gem-related issues, try running 
```
bundle install 
```
In case you find any trouble with the database, there are two commands that might come to rescue:

```
rake db:setup
```
and 
```
rake db:reset
```
Warning:  be careful with the last one since it'll delete all records you have stored in the database and no magic (_pun intended_) will help you after you've done that.

### Testing

In order to run tests, open your terminal and go to the root folder of the application. From there, run

```
rails test
```
It will run all tests on the test folder. 

### Documentation

Documentation is available on the ```public/doc``` folder or online here:

https://backendchallengeshopify.herokuapp.com/doc

If you make any changes to the code and wish to generate the documentation for those changes, simply modify the comments on the method you've made changes to and run 

```
rdoc --output public/doc/ -O
```