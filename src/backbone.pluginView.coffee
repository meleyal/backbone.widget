###
  Backbone.PluginView
  https://github.com/meleyal/backbone.pluginView

  Copyright (c) 2012 William Meleyal
  MIT License
###

class Backbone.PluginView extends Backbone.View

  @exportPlugin: (namespace) ->
    #console.log 'exportPlugin', namespace
    self = this
    $.fn[namespace] = (options = {}) ->
      @each (idx, el) =>
        options = _.extend options, { el, namespace }
        self.install options

  @install: (options) ->
    { uninstallEvent } = Backbone.PluginView
    { namespace } = options
    #console.log 'install', namespace
    view = new this(options)
    if uninstallEvent
      $(document).on "#{uninstallEvent}.#{namespace}", view.uninstall

  uninstall: (e) =>
    console.log 'PluginView#uninstall', @options.namespace
    eventNamespace = ".#{@options.namespace}"
    @undelegateEvents()
    # TODO: combine into single off() call?
    @$el.off eventNamespace
    $(window).off eventNamespace
    $(document).off eventNamespace
