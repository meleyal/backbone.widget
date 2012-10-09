(function() {
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
        return this.each(__bind(function(idx, el) {
          options = _.extend(options, {
            el: el,
            namespace: namespace
          });
          return self.install(options);
        }, this));
      };
    };
    PluginView.install = function(options) {
      var namespace, uninstallEvent, view;
      uninstallEvent = Backbone.PluginView.uninstallEvent;
      namespace = options.namespace;
      view = new this(options);
      if (uninstallEvent) {
        return $(document).on("" + uninstallEvent + "." + namespace, view.uninstall);
      }
    };
    PluginView.prototype.uninstall = function(e) {
      var eventNamespace;
      console.log('PluginView#uninstall', this.options.namespace);
      eventNamespace = "." + this.options.namespace;
      this.undelegateEvents();
      this.$el.off(eventNamespace);
      $(window).off(eventNamespace);
      return $(document).off(eventNamespace);
    };
    return PluginView;
  })();
}).call(this);
