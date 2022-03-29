# ActiveAdmin + AlpineJS

If you're tired of dealing with jQuery's messy file structure, AlpineJS proves itself to be a worthy alternative. In most cases there's no need for an external JS file, so all the necessary code for a function to work can be declared directly into your resource's ActiveAdmin file.

  - [Installing AlpineJS](#installing-alpinejs)
  - [Basics](#basics)
  - [Format a field when writing](#format-a-field-when-writing)
  - [Validate a Field](#validate-a-field)
  - [Toggle a Field's Visibility](#toggle-a-fields-visibility)
  - [Select2 Fields](#select2-fields)
  - [Has Many](#has-many)
  - [Complex Forms](#complex-forms)
  - [Running this repo](#running-this-repo)

## Installing AlpineJS

```bash
# When using Shakapacker, Webpack 5+ or other modern bundlers
yarn add alpine

# When using Webpacker
yarn add alpine@2
```

Then we need to add the following to a javascript file that runs when ActiveAdmin is active, usually the one with `import '@activeadmin/activeadmin';`

```javascript
import '@activeadmin/activeadmin';

import Alpine from 'alpinejs';

window.Alpine = Alpine;
Alpine.start();

```

if you're using Alpine 2 (due to Webpacker), you need to use the following instead:

```javascript
import '@activeadmin/activeadmin';

import 'alpinejs'
```

> :grey_exclamation: All examples in this repository use AlpineJS 3 but they should work as-is in AlpineJS 2.

## Basics

An AlpineJS component is an html element with an `x-data` attribute with all the variables we'll use.

```html
<div x-data="{open: false}"></div>
```

To make that work in ActiveAdmin, we need to add the `x-data` attribute either to `inputs` or `input`.

```ruby
f.inputs 'x-data':  CGI.escapeHTML("{...#{f.resource.attributes.to_json}}") do
  f.input :name
end
```

> :grey_exclamation: `CGI.escapeHTML` is necessary to avoid breaking printing something that'll escape the `x-data` attribute (usually because of a double quote)

> :grey_exclamation: `f.resource.attributes` gives us access to all the attributes the model has. Instead of using it you can declare values by hand, always remembering it needs to be a valid javascript object.

> :exclamation: Most examples assume the `x-data` attribute has been declared.

Once we have initialized the component with `x-data` we can start using AlpineJS's directives.

```ruby
f.inputs 'x-data':  CGI.escapeHTML("{...#{f.resource.attributes.to_json}}") do
  f.input :name, input_html: { 'x-model': 'name' }
end
```

## Format a field when writing

When to use: Telephone numbers, currency values, national id numbers.

To start, we need to add the formatter function to the same file where we initialized Alpine and expose it to the browser page.

```javascript
window.Alpine = Alpine;
Alpine.start();

window.formatters = {
  // Formats a number to currency
  currency: new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP' }),
  // Removes everything that's not a number from a string
  numberCleaner(value) {
    return value.replaceAll(/\D/g, '');
  },
};
```

Then, inside our admin file we use `x-on:input` (or `@input`) to format the value every time we input a number into our input.

> :grey_exclamation: For this specific example we need to clean the number (so that it's actually a number (`1000`) instead of a string (`1.000`), so we run `numberCleaner` before `format`.

```ruby
f.input :amount, input_html: {
  'x-model': 'amount',
  'x-on:input': 'amount = formatters.currency.format(formatters.numberCleaner($event.target.value));'
}
```

If we reload the page, the amount will not be formatted since the formatter only runs on input. For that we need to edit the initial data in `x-data`.

```ruby

f.inputs 'x-data': CGI.escapeHTML("{ amount: '#{number_to_currency(f.resource.attributes['amount'])}'}") do

  f.input :amount, input_html:
    'x-model': 'amount',
    'x-on:input': 'amount = formatters.currency.format(formatters.numberCleaner($event.target.value));
    '
```

In the case the model's attribute is an `integer` in the database, we can't save the formatted string. For that, we need to add a couple of things to have to inputs, the formatted one and the "real" one that is saved to the database.

In the model add:

```ruby
class FormatFieldExample < ApplicationRecord
  attr_accessor :active_admin_amount
end
```

> :grey_exclamation: `attr_accessor` is necessary since ActiveAdmin doesn't allow values that don't exist to be shown as inputs.

Then in our admin file we use `amount` directly and then add a formatted `active_admin_amount` to `x-data`.

```ruby
f.inputs 'x-data': CGI.escapeHTML("{
    amount: #{f.resource.attributes['amount']},
    active_admin_amount: '#{number_to_currency(f.resource.attributes['amount'])}',
  }") do

```

For the visible amount, we replace it with `active_admin_amount` and update the `x-on:input` method so it also updates the `amount` in `x-data`.

```ruby
  f.input :active_admin_amount, input_html:
    'x-model': 'active_admin_amount',
    'x-on:input': '
      active_admin_amount = formatters.currency.format(formatters.numberCleaner($event.target.value));
      amount = formatters.numberCleaner(active_admin_amount);
    '
```

Finally, we add a hidden input with the real `amount` so it gets saved in the database as a number.

```ruby
f.input :amount, as: :hidden, input_html: {
  'x-bind:value': 'amount'
}
```

[source code](app/admin/format_field_examples.rb)

## Validate a Field

When to use: To prevent the form being able to be saved if a value is not valid, to display when a value needs to be filled or it has an invalid value.

As in the previous example, we need to add our validation function to the window variable so it's available in the ActiveAdmin page.

```javascript
import { rutValidate } from 'rut-helpers';

window.validators = {
  // Formats a value to the standard RUT format.
  rut: rutValidate
};
```

In this example we want to change the input's class if the value is not valid, for that we need to use `x-bind:class` (or `:class`) so the class `error` gets dynamically added when `validators.rut(rut)` is `false`:

```ruby
f.input :rut, input_html: {
  'x-model': 'rut',
  'x-bind:class': '{error: !validators.rut(rut)}'
}
```

If we also want to disable the submit button, we can edit the `submit` action to add the disabled attribute. `x-bind:disabled` (or `:disabled`) dynamically adds the attribute when the validator is false.

```ruby
f.actions do
  f.action :submit, button_html: { 'x-bind:disabled': "!validators.rut(rut)" }
end
```

[source code](app/admin/validate_field_examples.rb)

## Toggle a Field's Visibility

Being able to show or hide a field can be done using Alpine's `x-show` directive.

First we need a field with `x-model` so we can check its value afterwards

```ruby
f.input :has_description, input_html: {
  'x-model': 'has_description'
}
```

And then we add the `x-show ` directive to the field we want to show or hide depending on the value of the `has_description` field.

```ruby
f.input :description, wrapper_html: {
  'x-show': 'has_description'
}
```

> :exclamation: We need to use `wrapper_html` instead of `input_html` to hide both the label and the input field.

[source code](app/admin/toggle_field_examples.rb)

## Select2 Fields

[ActiveAdmin Addons](https://github.com/platanus/activeadmin_addons) transforms all select controls to use Select2, to make it easier to add large collections or tags. However, AlpineJS doesn't know what to do with Select2 elements (and the other way around).

To make them work we need to install [active-admin-alpine-fixes](https://www.npmjs.com/package/active-admin-alpinejs-fixes).

```bash
yarn add active-admin-alpine-fixes
```

Then, we have to make the fix available to the DOM.

```javascript
import { select2 } from 'active-admin-alpine-fixes';

window.alpineFixes = { select2 };
```

Finally, we add the fix to our AlpineJS component by adding the `x-init` attribute so that it can run the fix as soon as the component runs.

```ruby
f.inputs 'x-init': 'alpineFixes.select2.init', 'x-data':  CGI.escapeHTML("{...#{f.resource.attributes.to_json}}") do
  f.input :choices
end
```

[source code](app/admin/select2_examples.rb)

## Has Many

ActiveAdmin allows us to add a nested form when a resource has a `has_many`. When you click "new resource" inside this nested form, ActiveAdmin uses jQuery to create the new fields and AlpineJS gets confused.

To make them work we need to install [active-admin-alpine-fixes](https://www.npmjs.com/package/active-admin-alpinejs-fixes).

```bash
yarn add active-admin-alpine-fixes
```

Then, we have to make the fix available to the DOM.

```javascript
import { hasMany } from 'active-admin-alpine-fixes';

window.alpineFixes = { hasMany };
```

In our component we need to add the fix to the `x-init` directive, and in our `x-data` we need to explicitly add the nested resource. Inside `has_many`, we need to declare the `x-model` using the available index number so that AlpineJS knows what field corresponds to what element in the children array.

```ruby
f.inputs 'x-init': 'alpineFixes.hasMany.init',
          'x-data': CGI.escapeHTML("{
            ...#{f.resource.attributes.to_json},
            children: #{f.resource.children.to_json}
          }") do
  f.has_many :children, allow_destroy: true do |co, i|
    # has_many index starts with 1 while javascript's starts with 0 so we subtract one
    co.input :name, input_html: {
      'x-model': "children[#{i - 1}].name"
    }
  end
end
```

[source code](app/admin/has_many_examples.rb)


## Complex Forms

If our form is really complex _or_ it has functionality that can very easily be reused, we can use `Alpine.data` in our javascript to declare an object that can be used in our form without having to expose variables with `window`. In other words, we can have a different JS file with everything we need and then we can import it and use it in our main JS file.

```javascript
// activeadmin/complex_example.js

export default (attributes = {}) => {
  function init() {
    // We need to pass the Alpine context (this) so it can find the element
    select2.init.bind(this)();
  }

  const currencyFormat = new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP' });

  function numberCleaner(value) {
    return value.replaceAll(/\D/g, '');
  }


  // We return an object that will be available inside our component
  return { ...attributes, init, currencyFormat, numberCleaner };
};

```

```javascript
import complexExample from './activeadmin/complex_example';

Alpine.data('complexExample', complexExample);
Alpine.start();
```

Once we have done the above, we can use `complexExample` in our `x-data`, which receives the attributes we need to initialize the data.

```ruby
  form do |f|
    f.inputs 'x-data': "complexExample(#{CGI.escapeHTML("{
        ...#{f.resource.attributes.to_json},
        active_admin_amount: '#{number_to_currency(f.resource.attributes['amount'])}'
      }")})" do
      f.input :name

      f.input :rut, input_html: {
        'x-model': 'rut',
        # We can use rutFormat directly since it's available inside the data object returned by the complexExample function.
        'x-on:input': 'rut = rutFormat(rut)',
        'x-bind:class': '{error: !rutValidate(rut)}'
      }

      f.input :active_admin_amount, input_html: {
        'x-model': 'active_admin_amount',
        'x-on:input': '
          active_admin_amount = currencyFormat.format(numberCleaner($event.target.value));
          amount = numberCleaner(active_admin_amount);
        '
      }
      f.input :amount, as: :hidden, input_html: {
        'x-bind:value': 'amount'
      }

      f.actions do
        f.action :submit, button_html: { 'x-bind:disabled': "!rutValidate(rut)" }
      end
    end
  end
end

```

[source code](app/admin/complex_examples.rb)

## Running this repo

Assuming you've just cloned the repo, run this script to setup the project in your
machine:

```bash
  ./bin/setup
```

It assumes you have a machine equipped with Ruby, Node.js, Docker and make.

The script will do the following among other things:

- Install the dependencies
- Create a docker container for your database
- Prepare your database

After the app setup is done you can run it with

```bash
  bundle exec rails s
```
