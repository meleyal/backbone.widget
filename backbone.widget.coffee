###
  Backbone.Widget
  https://github.com/meleyal/backbone.widget

  Copyright (c) 2013 William Meleyal
  MIT License
###

class Backbone.Widget extends Backbone.View

  # Add the plugin to the jQuery.fn namespace.
  # This enables instantiating new views by calling `$(element).myView()`
  @exportWidget: (namespace) ->
    klass = this
    $.fn[namespace] = (options = {}) ->
      @each (idx, el) -> klass.install el, options, namespace

  # Install the plugin
  # Follows the standard jQuery plugin spec: http://learn.jquery.com/plugins
  # - Create a new instance of the View class
  # - Store a reference to the view instance in `$el.data`
  # - Return the instance if it was already installed
  # - If a string is passed, attempt to call a method by that name on the view instance
  # - Bind an event handler to remove the view (if the event has been defined)
  # - NOTE: we use `on` instead of `one` so we can unbind the event in case the view is removed manually.
  @install: (el, options, namespace) ->
    klass = this
    if instance = $(el).data namespace
      if options and typeof options is 'string'
        instance[options].call klass
      else
        return instance
    else
      options = _.extend options, { el, namespace }
      instance = new klass options
      $(el).data namespace, instance
      @removeEvent = Backbone.Widget.removeEvent
      $(document).on(@removeEvent, instance.remove) if @removeEvent

  # Ensure each view instance has a remove method and unbind our removeEvent listener.
  # Delegate to `View.remove()`: http://backbonejs.org/#View-remove
  remove: =>
    $(document).off @removeEvent, @remove
    super
