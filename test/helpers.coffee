jasmine.Matchers.prototype.toBeInstanceOf = (klass) ->
  this.actual instanceof klass

jasmine.Matchers.prototype.toBeA = (expected) ->
  typeof this.actual is expected
