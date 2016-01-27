# Sugarify

Sugarify is an atom package for sorting RequireJS requires.

## How do I use it?

Press <key>ctrl</key>+<key>shift</key>+<key>s</key>.

## What does it do?

Sugarify lets you turn something like this:

```javascript
const Egg = require('ingredients/animal/egg');
const Backbone = require('backbone');
const Oven = require('tools/appliances/oven');
const exceptions = require('lib/exceptions');
const BakingPowder = require('ingredients/powders/bakingPowder');
const Cake = require('recipes/cake');
const Flour = require('ingredients/powders/flour');
const Pan = require('tools/pan');
require('vendor/backbone/plugins/stickit');
const Q = require('q');
const Bowl = require('tools/bowl');
const Whisk = require('tools/whisk');
const _ = require('underscore');
const React = require('react');
require('css!css/main.css');
const Milk = require('ingredients/dairy/milk');
require('vendor/jquery/plugins/slideshow');
const Butter = require('ingredients/dairy/butter');
const Sugar = require('ingredients/sweets/sugar');
const $ = require('jquery');
const Vanilla = require('ingredients/flavors/vanilla');
const template = require('templates/app.html');

class BakeryApp extends React.Component {
  // Bake a cake!
}

module.exports = BakeryApp;
```

into this:

```javascript
const Backbone = require('backbone');
const $ = require('jquery');
const Q = require('q');
const React = require('react');
const _ = require('underscore');

const Egg = require('ingredients/animal/egg');
const Butter = require('ingredients/dairy/butter');
const Milk = require('ingredients/dairy/milk');
const Vanilla = require('ingredients/flavors/vanilla');
const BakingPowder = require('ingredients/powders/bakingPowder');
const Flour = require('ingredients/powders/flour');
const Sugar = require('ingredients/sweets/sugar');

const exceptions = require('lib/exceptions');

const Cake = require('recipes/cake');

const template = require('templates/app.html');

const Oven = require('tools/appliances/oven');
const Bowl = require('tools/bowl');
const Pan = require('tools/pan');
const Whisk = require('tools/whisk');

require('css!css/main.css');
require('vendor/backbone/plugins/stickit');
require('vendor/jquery/plugins/slideshow');

class BakeryApp extends React.Component {
  // Bake a cake!
}

module.exports = BakeryApp;
```
