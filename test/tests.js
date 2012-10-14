module('Backbone.PluginView', {

  setup: function() {
    window.MyView = Backbone.PluginView.extend({
      events: { 'click': 'log' },
      log: function(e) { console.log(e.type) }
    })
    MyView.exportPlugin('myView')
    Backbone.PluginView.uninstallEvent = 'page:change'
  },

  teardown: function() {
    Backbone.PluginView.uninstallEvent = null
    $(document).off('page:change')
  }

})

  test('should be defined', function() {
    ok(Backbone.PluginView, 'PluginView is defined')
  })

  test('should create jQuery plugin', function() {
    ok($.fn.myView, '$.fn.myView is defined')
    ok($(document.body).myView, 'myView() can be called on an element')
  })

  test('should store view instance in $.data', function() {
    var view = $('.fixture').myView().data('myView')
    ok(view instanceof Backbone.PluginView, 'view is an instance of PluginView')
    ok(view instanceof MyView, 'view is an instance of MyView')
  })

  test('should create separate view instances for each element passed to plugin', function() {
    $('.fixture').clone().appendTo('#qunit-fixture')
    var els = $('.fixture').myView()
    var first = els.first().data('myView').cid
    var last = els.last().data('myView').cid
    ok(first != last, 'first and last view cids are different')
  })

  test('should only create plugin once', function() {
    var el = $('.fixture')
    var view1 = el.myView().data('myView')
    var view2 = el.myView().data('myView')
    ok(view1 === view2, 'calling plugin again returns the same view')
  })

  test('should pass el to view', function() {
    var el = $('.fixture')
    var view = el.myView().data('myView')
    ok(el[0] === view.el, 'el and view.el are equal')
  })

  test('should pass options to view', function() {
    var el = $('.fixture')
    var options = { key: 'value' }
    var view = el.myView(options).data('myView')
    ok(options === view.options, 'options and view.options are equal')
  })

  test('should pass namespace option to view', function() {
    var view = $('.fixture').myView().data('myView')
    ok(view.options.namespace === 'myView', 'namespace is present in options')
  })

  test('should call default uninstall method if uninstallEvent is defined', function() {
    var proto = Backbone.PluginView.prototype
    sinon.spy(proto, 'uninstall')
    var view = $('.fixture').myView().data('myView')
    $(document).trigger('page:change')
    ok(proto.uninstall.called, 'uninstall was called')
    proto.uninstall.restore()
  })

  test('should call view uninstall method if uninstallEvent is defined', function() {
    var CustomView = Backbone.PluginView.extend({ uninstall: function(){} })
    var proto = CustomView.prototype
    sinon.spy(proto, 'uninstall')
    CustomView.exportPlugin('customView')
    $('.fixture').customView().data('customView')
    $(document).trigger('page:change')
    ok(proto.uninstall.called, 'uninstall was called')
    proto.uninstall.restore()
  })

  test('should undelegateEvents on uninstall', function() {
    expect(1)
    var proto = MyView.prototype
    sinon.spy(proto, 'log')
    var view = $('.fixture').myView().data('myView')
    $(document).on('page:change', function() {
      view.$el.trigger('click')
      ok(!proto.log.called, 'view.log not called')
      proto.log.restore()
    })
    $(document).trigger('page:change')
  })

  test('should remove $.data reference on uninstall', function() {
    $('.fixture').myView()
    $(document).trigger('page:change')
    ok($('.fixture').data('myView') === undefined, 'data is undefined')
  })
