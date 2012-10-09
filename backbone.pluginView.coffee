###
  Backbone.PluginView
  https://github.com/meleyal/backbone.pluginview

  Copyright (c) 2012 William Meleyal
  MIT License
###

class Backbone.PluginView extends Backbone.View

  @exportPlugin: (namespace) ->
    #console.log 'exportPlugin', namespace
    self = this
    $.fn[namespace] = (options = {}) ->
      @each (idx, el) -> self.install el, options, namespace

  @install: (el, options, namespace) ->
    { uninstallEvent } = Backbone.PluginView
    $el = $(el)
    data = $el.data namespace
    unless data?
      #console.log 'install', namespace
      options = _.extend options, { el, namespace }
      view = new this(options)
      $el.data(namespace, view)
      if uninstallEvent
        $(document).on "#{uninstallEvent}.#{namespace}", view.uninstall

  uninstall: (e) =>
    { namespace } = @options
    #console.log 'uninstall', namespace
    eventNamespace = ".#{namespace}"
    @$el.removeData(namespace)
    @undelegateEvents()
    # TODO: combine into single off() call?
    @$el.off eventNamespace
    $(window).off eventNamespace
    $(document).off eventNamespace
