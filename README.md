Backbone.Widget
===============

Make jQuery widgets from your Backbone Views.

`Backbone.Widget` extends `Backbone.View` with some simple helpers for creating jQuery widgets/plugins (`$.fn`).

This enables creating `Backbone.View` instances with jQuery syntax:

```javascript
$('.example').myView([options]);
```

Why?
----

At the code level `Backbone.View` offers a nice way to structure your jQuery widget/plugin code.
`Backbone.Widget` just provides some minimal glue code to make this easy.

At the application / architecture level, the [JS Widgets][js-widgets] approach can offer a hybrid / DOM-centric alternative to single page apps; with static HTML from the server providing the foundation for multiple mini-applications (widgets).


Usage
-----

### JavaScript ###

```javascript
// extend Backbone.Widget
MyView = Backbone.Widget.extend({
  initialize: function(options) {
    console.log(this.el, options);
  }
});

// export as widget
MyView.exportWidget('myView');

// call on element
$('.example').myView([options]);
```

### CoffeeScript ###

```coffeescript
# extend Backbone.Widget
class MyView extends Backbone.Widget

  # export as widget
  @exportWidget 'myView'

  initialize: (options) ->
    console.log @el, options

# call on element
$('.example').myView([options])
```


Tricks
------

### Calling view methods ###

View methods can be called directly on the element

```javascript
$('.example').myView('remove')
```

### View instance ###

A reference to the view instance is stored in the element's `$.data`.

```javascript
view = $('.example').data('myView');
console.log(view.cid); // view0
```

### Namespace ###

The `namespace` option is passed to the view instance for convenience.
This can be useful for e.g. [namespacing events][jquery-events].

```javascript
...
initialize: function(options) {
  console.log(options.namespace); // myView
}
...
```

### Auto remove ###

`Widgets`'s can optionally `remove` themselves on a given event.
This can be useful with [pjax] / [turbolinks]
where you need to routinely cleanup views between "page loads".
See the [wiki page][auto-remove-wiki] for more details.

[js-widgets]: http://blog.pamelafox.org/2013/05/frontend-architectures-server-side-html.html
[jquery-events]: http://docs.jquery.com/Namespaced_Events
[pjax]: https://github.com/defunkt/jquery-pjax
[turbolinks]: https://github.com/rails/turbolinks
[auto-remove-wiki]: https://github.com/meleyal/backbone.pluginview/wiki/Auto-Uninstall
