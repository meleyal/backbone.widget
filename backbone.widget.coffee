###
  Backbone.Widget
  https://github.com/meleyal/backbone.widget

  Copyright (c) 2013 William Meleyal
  MIT License
###

class Backbone.Widget extends Backbone.View

  @exportWidget: (namespace) ->
    self = this
    $.fn[namespace] = (options = {}) ->
      @each (idx, el) -> self.install el, options, namespace

  @install: (el, options, namespace) ->
    { uninstallEvent } = Backbone.Widget
    $el = $(el)
    data = $el.data namespace
    unless data?
      options = _.extend options, { el, namespace }
      view = new this(options)
      $el.data(namespace, view)
      if uninstallEvent
        $(document).on "#{uninstallEvent}.#{namespace}", view.uninstall

  uninstall: (e) =>
    { namespace } = @options
    @undelegateEvents()
    $(document).off ".#{namespace}"
    @$el.removeData(namespace)
