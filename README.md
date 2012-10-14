Backbone.PluginView
===================

Make jQuery plugins from your Backbone Views.

`Backbone.PluginView` extends `Backbone.View` with some simple helpers for creating jQuery plugins (`$.fn`).

This enables creating `Backbone.View` instances with jQuery syntax:

```javascript
$('.example').myView([options]);
```


Usage
-----

### JavaScript ###

```javascript
// extend Backbone.PluginView
MyView = Backbone.PluginView.extend({
  initialize: function(options) {
    console.log(this.el, options);
  }
});

// export as plugin
MyView.exportPlugin('myView');

// call on element
$(document).ready(function(){
  $('.example').myView([options]);
});
```

### CoffeeScript ###

```coffeescript
# extend Backbone.PluginView
class MyView extends Backbone.PluginView

  # export as plugin
  @exportPlugin 'myView'

  initialize: (options) ->
    console.log @el, options

# call on element
$(document).ready ->
  $('.example').myView([options])
```


Tricks
------

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

### View instance ###

A reference to the view instance is stored in the element's `$.data`.

```javascript
view = $('.example').data('myView');
console.log(view.cid); // view0
```

### Auto uninstall ###

`PluginView`'s can optionally "uninstall" on a given event.
This can be useful with [pjax] / [turbolinks]
where you need to routinely unbind views between "page loads".
See the [wiki page][auto-install-wiki] for more details.

[jquery-events]: http://docs.jquery.com/Namespaced_Events
[pjax]: https://github.com/defunkt/jquery-pjax
[turbolinks]: https://github.com/rails/turbolinks
[auto-install-wiki]: https://github.com/meleyal/backbone.pluginview/wiki/Auto-Uninstall
