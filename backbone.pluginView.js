(function() {
  /*
    Backbone.PluginView
    https://github.com/meleyal/backbone.pluginview
  
    Copyright (c) 2012 William Meleyal
    MIT License
  */
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Backbone.PluginView = (function() {
    __extends(PluginView, Backbone.View);
    function PluginView() {
      this.uninstall = __bind(this.uninstall, this);
      PluginView.__super__.constructor.apply(this, arguments);
    }
    PluginView.exportPlugin = function(namespace) {
      var self;
      self = this;
      return $.fn[namespace] = function(options) {
        if (options == null) {
          options = {};
        }
        return this.each(function(idx, el) {
          return self.install(el, options, namespace);
        });
      };
    };
    PluginView.install = function(el, options, namespace) {
      var $el, data, uninstallEvent, view;
      uninstallEvent = Backbone.PluginView.uninstallEvent;
      $el = $(el);
      data = $el.data(namespace);
      if (data == null) {
        options = _.extend(options, {
          el: el,
          namespace: namespace
        });
        view = new this(options);
        $el.data(namespace, view);
        if (uninstallEvent) {
          return $(document).on("" + uninstallEvent + "." + namespace, view.uninstall);
        }
      }
    };
    PluginView.prototype.uninstall = function(e) {
      var eventNamespace, namespace;
      namespace = this.options.namespace;
      eventNamespace = "." + namespace;
      this.$el.removeData(namespace);
      this.undelegateEvents();
      this.$el.off(eventNamespace);
      $(window).off(eventNamespace);
      return $(document).off(eventNamespace);
    };
    return PluginView;
  })();
}).call(this);
