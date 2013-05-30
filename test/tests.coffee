describe 'Backbone.Widget', ->

  beforeEach ->
    fixture = $('<div/>', class: 'fixture')
    $(document.body).append fixture
    class window.MyView extends Backbone.Widget
      @exportWidget 'myView'
      events: { 'click': 'log' }
      log: (e) -> console.log(e.type)

  afterEach ->
    $('.fixture').remove()
    Backbone.Widget.uninstallEvent = null
    $(document).off 'page:change'

  it 'should be defined', ->
    expect(Backbone.Widget).toBeDefined()

  it 'should create jQuery plugin', ->
    expect($.fn.myView).toBeDefined()
    expect(typeof $(document.body).myView is 'function').toBeTruthy()

  it 'should store view instance in $.data', ->
    view = $('.fixture').myView().data('myView')
    expect(view instanceof Backbone.Widget).toBeTruthy()
    expect(view instanceof MyView).toBeTruthy()

  it 'should create separate view instances for each element passed to plugin', ->
    $('.fixture').clone().appendTo(document.body)
    els = $('.fixture').myView()
    view1 = els.first().data('myView')
    view2 = els.last().data('myView')
    expect(view1.cid).not.toBe(view2.cid)

  it 'should only create plugin once', ->
    el = $('.fixture')
    first = el.myView().data('myView')
    second = el.myView().data('myView')
    expect(first).toBe(second)

  it 'should pass el to view', ->
    el = $('.fixture')
    view = el.myView().data('myView')
    expect(el[0]).toBe(view.el)

  it 'should pass options to view', ->
    el = $('.fixture')
    options = { key: 'value' }
    view = el.myView(options).data('myView')
    expect(options).toBe(view.options)

  it 'should pass namespace option to view', ->
    view = $('.fixture').myView().data('myView')
    expect(view.options.namespace).toBe('myView')

  it 'should call default uninstall method if uninstallEvent is defined', ->
    Backbone.Widget.uninstallEvent = 'page:change'
    proto = Backbone.Widget.prototype
    sinon.spy proto, 'uninstall'
    view = $('.fixture').myView().data('myView')
    $(document).trigger('page:change')
    expect(proto.uninstall.called).toBeTruthy()
    proto.uninstall.restore()

  it 'should call view uninstall method if uninstallEvent is defined', ->
    Backbone.Widget.uninstallEvent = 'page:change'
    spy = sinon.spy()
    CustomView = Backbone.Widget.extend({ uninstall: -> spy() })
    CustomView.exportWidget 'customView'
    view = $('.fixture').customView().data('customView')
    $(document).trigger('page:change')
    expect(spy.called).toBeTruthy()

  it 'should undelegateEvents on uninstall', ->
    Backbone.Widget.uninstallEvent = 'page:change'
    spy = sinon.spy()
    proto = MyView.prototype
    sinon.spy proto, 'log'
    view = $('.fixture').myView().data('myView')
    $(document).on 'page:change', ->
      view.$el.trigger('click')
      expect(proto.log.called).toBeFalsy()
      proto.log.restore()
    $(document).trigger('page:change')
