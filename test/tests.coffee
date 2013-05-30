describe 'Backbone.Widget', ->

  beforeEach ->
    fixture = $('<div/>', class: 'fixture')
    $(document.body).append fixture

    class window.MyView extends Backbone.Widget
      @exportWidget 'myView'
      log: sinon.spy()

  afterEach ->
    $('.fixture').remove()
    Backbone.Widget.removeEvent = null
    $(document).off 'page:change'

  it 'should be defined', ->
    expect(Backbone.Widget).toBeDefined()

  it 'should create jQuery widget', ->
    expect($.fn.myView).toBeDefined()
    expect($(document.body).myView).toBeA('function')

  it 'should store view instance in $.data', ->
    view = $('.fixture').myView().data('myView')
    expect(view).toBeInstanceOf(Backbone.Widget)
    expect(view).toBeInstanceOf(MyView)

  it 'should create separate view instances for each element passed to widget', ->
    $('.fixture').clone().appendTo(document.body)
    els = $('.fixture').myView()
    view1 = els.first().data('myView')
    view2 = els.last().data('myView')
    expect(view1.cid).not.toBe(view2.cid)

  it 'should only create widget once', ->
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

  it 'should attempt to call method on existing view', ->
    view = $('.fixture').myView().data('myView')
    $('.fixture').myView('log')
    expect(view.log.called).toBeTruthy()

  it 'should call default remove method if removeEvent is defined', ->
    Backbone.Widget.removeEvent = 'page:change'
    proto = Backbone.Widget.prototype
    sinon.spy proto, 'remove'
    $('.fixture').myView()
    $(document).trigger('page:change')
    expect(proto.remove.called).toBeTruthy()
    proto.remove.restore()

  it 'should call view remove method if removeEvent is defined', ->
    Backbone.Widget.removeEvent = 'page:change'
    spy = sinon.spy()
    CustomView = Backbone.Widget.extend({ remove: -> spy() })
    CustomView.exportWidget 'customView'
    $('.fixture').customView()
    $(document).trigger('page:change')
    expect(spy.called).toBeTruthy()

  it 'should unbind removeEvent listener if default remove method is called', ->
    Backbone.Widget.removeEvent = 'page:change'
    $('.fixture').myView()
    expect($._data(document, 'events')['page:change']).toBeDefined()
    $(document).trigger('page:change')
    expect($._data(document, 'events')).not.toBeDefined()
