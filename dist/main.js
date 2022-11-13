(() => {
  // output/Data.Functor/foreign.js
  var arrayMap = function(f) {
    return function(arr) {
      var l = arr.length;
      var result = new Array(l);
      for (var i = 0; i < l; i++) {
        result[i] = f(arr[i]);
      }
      return result;
    };
  };

  // output/Control.Semigroupoid/index.js
  var semigroupoidFn = {
    compose: function(f) {
      return function(g) {
        return function(x) {
          return f(g(x));
        };
      };
    }
  };

  // output/Control.Category/index.js
  var identity = function(dict) {
    return dict.identity;
  };
  var categoryFn = {
    identity: function(x) {
      return x;
    },
    Semigroupoid0: function() {
      return semigroupoidFn;
    }
  };

  // output/Data.Function/index.js
  var flip = function(f) {
    return function(b) {
      return function(a) {
        return f(a)(b);
      };
    };
  };
  var $$const = function(a) {
    return function(v) {
      return a;
    };
  };

  // output/Data.Unit/foreign.js
  var unit = void 0;

  // output/Type.Proxy/index.js
  var $$Proxy = /* @__PURE__ */ function() {
    function $$Proxy2() {
    }
    ;
    $$Proxy2.value = new $$Proxy2();
    return $$Proxy2;
  }();

  // output/Data.Functor/index.js
  var map = function(dict) {
    return dict.map;
  };
  var $$void = function(dictFunctor) {
    return map(dictFunctor)($$const(unit));
  };
  var functorArray = {
    map: arrayMap
  };

  // output/Data.Semigroup/foreign.js
  var concatArray = function(xs) {
    return function(ys) {
      if (xs.length === 0)
        return ys;
      if (ys.length === 0)
        return xs;
      return xs.concat(ys);
    };
  };

  // output/Data.Symbol/index.js
  var reflectSymbol = function(dict) {
    return dict.reflectSymbol;
  };

  // output/Record.Unsafe/foreign.js
  var unsafeGet = function(label4) {
    return function(rec) {
      return rec[label4];
    };
  };
  var unsafeSet = function(label4) {
    return function(value12) {
      return function(rec) {
        var copy = {};
        for (var key in rec) {
          if ({}.hasOwnProperty.call(rec, key)) {
            copy[key] = rec[key];
          }
        }
        copy[label4] = value12;
        return copy;
      };
    };
  };

  // output/Data.Semigroup/index.js
  var semigroupArray = {
    append: concatArray
  };
  var append = function(dict) {
    return dict.append;
  };

  // output/Control.Apply/foreign.js
  var arrayApply = function(fs) {
    return function(xs) {
      var l = fs.length;
      var k = xs.length;
      var result = new Array(l * k);
      var n = 0;
      for (var i = 0; i < l; i++) {
        var f = fs[i];
        for (var j = 0; j < k; j++) {
          result[n++] = f(xs[j]);
        }
      }
      return result;
    };
  };

  // output/Control.Apply/index.js
  var identity2 = /* @__PURE__ */ identity(categoryFn);
  var applyArray = {
    apply: arrayApply,
    Functor0: function() {
      return functorArray;
    }
  };
  var apply = function(dict) {
    return dict.apply;
  };
  var applySecond = function(dictApply) {
    var apply1 = apply(dictApply);
    var map4 = map(dictApply.Functor0());
    return function(a) {
      return function(b) {
        return apply1(map4($$const(identity2))(a))(b);
      };
    };
  };

  // output/Control.Applicative/index.js
  var pure = function(dict) {
    return dict.pure;
  };
  var liftA1 = function(dictApplicative) {
    var apply2 = apply(dictApplicative.Apply0());
    var pure12 = pure(dictApplicative);
    return function(f) {
      return function(a) {
        return apply2(pure12(f))(a);
      };
    };
  };
  var applicativeArray = {
    pure: function(x) {
      return [x];
    },
    Apply0: function() {
      return applyArray;
    }
  };

  // output/Control.Bind/foreign.js
  var arrayBind = function(arr) {
    return function(f) {
      var result = [];
      for (var i = 0, l = arr.length; i < l; i++) {
        Array.prototype.push.apply(result, f(arr[i]));
      }
      return result;
    };
  };

  // output/Control.Bind/index.js
  var bindArray = {
    bind: arrayBind,
    Apply0: function() {
      return applyArray;
    }
  };
  var bind = function(dict) {
    return dict.bind;
  };

  // output/Data.Bounded/foreign.js
  var topChar = String.fromCharCode(65535);
  var bottomChar = String.fromCharCode(0);
  var topNumber = Number.POSITIVE_INFINITY;
  var bottomNumber = Number.NEGATIVE_INFINITY;

  // output/Data.Ord/foreign.js
  var unsafeCompareImpl = function(lt) {
    return function(eq2) {
      return function(gt) {
        return function(x) {
          return function(y) {
            return x < y ? lt : x === y ? eq2 : gt;
          };
        };
      };
    };
  };
  var ordNumberImpl = unsafeCompareImpl;

  // output/Data.Eq/foreign.js
  var refEq = function(r1) {
    return function(r2) {
      return r1 === r2;
    };
  };
  var eqNumberImpl = refEq;

  // output/Data.Eq/index.js
  var eqNumber = {
    eq: eqNumberImpl
  };

  // output/Data.Ordering/index.js
  var LT = /* @__PURE__ */ function() {
    function LT2() {
    }
    ;
    LT2.value = new LT2();
    return LT2;
  }();
  var GT = /* @__PURE__ */ function() {
    function GT2() {
    }
    ;
    GT2.value = new GT2();
    return GT2;
  }();
  var EQ = /* @__PURE__ */ function() {
    function EQ2() {
    }
    ;
    EQ2.value = new EQ2();
    return EQ2;
  }();

  // output/Data.Semiring/foreign.js
  var intAdd = function(x) {
    return function(y) {
      return x + y | 0;
    };
  };
  var intMul = function(x) {
    return function(y) {
      return x * y | 0;
    };
  };

  // output/Data.Semiring/index.js
  var zeroRecord = function(dict) {
    return dict.zeroRecord;
  };
  var zero = function(dict) {
    return dict.zero;
  };
  var semiringRecordNil = {
    addRecord: function(v) {
      return function(v1) {
        return function(v2) {
          return {};
        };
      };
    },
    mulRecord: function(v) {
      return function(v1) {
        return function(v2) {
          return {};
        };
      };
    },
    oneRecord: function(v) {
      return function(v1) {
        return {};
      };
    },
    zeroRecord: function(v) {
      return function(v1) {
        return {};
      };
    }
  };
  var semiringInt = {
    add: intAdd,
    zero: 0,
    mul: intMul,
    one: 1
  };
  var oneRecord = function(dict) {
    return dict.oneRecord;
  };
  var one = function(dict) {
    return dict.one;
  };
  var mulRecord = function(dict) {
    return dict.mulRecord;
  };
  var mul = function(dict) {
    return dict.mul;
  };
  var addRecord = function(dict) {
    return dict.addRecord;
  };
  var semiringRecord = function() {
    return function(dictSemiringRecord) {
      return {
        add: addRecord(dictSemiringRecord)($$Proxy.value),
        mul: mulRecord(dictSemiringRecord)($$Proxy.value),
        one: oneRecord(dictSemiringRecord)($$Proxy.value)($$Proxy.value),
        zero: zeroRecord(dictSemiringRecord)($$Proxy.value)($$Proxy.value)
      };
    };
  };
  var add = function(dict) {
    return dict.add;
  };
  var semiringRecordCons = function(dictIsSymbol) {
    var reflectSymbol2 = reflectSymbol(dictIsSymbol);
    return function() {
      return function(dictSemiringRecord) {
        var addRecord1 = addRecord(dictSemiringRecord);
        var mulRecord1 = mulRecord(dictSemiringRecord);
        var oneRecord1 = oneRecord(dictSemiringRecord);
        var zeroRecord1 = zeroRecord(dictSemiringRecord);
        return function(dictSemiring) {
          var add1 = add(dictSemiring);
          var mul1 = mul(dictSemiring);
          var one1 = one(dictSemiring);
          var zero1 = zero(dictSemiring);
          return {
            addRecord: function(v) {
              return function(ra) {
                return function(rb) {
                  var tail = addRecord1($$Proxy.value)(ra)(rb);
                  var key = reflectSymbol2($$Proxy.value);
                  var insert = unsafeSet(key);
                  var get = unsafeGet(key);
                  return insert(add1(get(ra))(get(rb)))(tail);
                };
              };
            },
            mulRecord: function(v) {
              return function(ra) {
                return function(rb) {
                  var tail = mulRecord1($$Proxy.value)(ra)(rb);
                  var key = reflectSymbol2($$Proxy.value);
                  var insert = unsafeSet(key);
                  var get = unsafeGet(key);
                  return insert(mul1(get(ra))(get(rb)))(tail);
                };
              };
            },
            oneRecord: function(v) {
              return function(v1) {
                var tail = oneRecord1($$Proxy.value)($$Proxy.value);
                var key = reflectSymbol2($$Proxy.value);
                var insert = unsafeSet(key);
                return insert(one1)(tail);
              };
            },
            zeroRecord: function(v) {
              return function(v1) {
                var tail = zeroRecord1($$Proxy.value)($$Proxy.value);
                var key = reflectSymbol2($$Proxy.value);
                var insert = unsafeSet(key);
                return insert(zero1)(tail);
              };
            }
          };
        };
      };
    };
  };

  // output/Data.Ord/index.js
  var ordNumber = /* @__PURE__ */ function() {
    return {
      compare: ordNumberImpl(LT.value)(EQ.value)(GT.value),
      Eq0: function() {
        return eqNumber;
      }
    };
  }();
  var compare = function(dict) {
    return dict.compare;
  };
  var comparing = function(dictOrd) {
    var compare3 = compare(dictOrd);
    return function(f) {
      return function(x) {
        return function(y) {
          return compare3(f(x))(f(y));
        };
      };
    };
  };

  // output/Data.Show/foreign.js
  var showIntImpl = function(n) {
    return n.toString();
  };

  // output/Data.Show/index.js
  var showInt = {
    show: showIntImpl
  };
  var show = function(dict) {
    return dict.show;
  };

  // output/Data.Maybe/index.js
  var Nothing = /* @__PURE__ */ function() {
    function Nothing2() {
    }
    ;
    Nothing2.value = new Nothing2();
    return Nothing2;
  }();
  var Just = /* @__PURE__ */ function() {
    function Just2(value0) {
      this.value0 = value0;
    }
    ;
    Just2.create = function(value0) {
      return new Just2(value0);
    };
    return Just2;
  }();
  var maybe = function(v) {
    return function(v1) {
      return function(v2) {
        if (v2 instanceof Nothing) {
          return v;
        }
        ;
        if (v2 instanceof Just) {
          return v1(v2.value0);
        }
        ;
        throw new Error("Failed pattern match at Data.Maybe (line 237, column 1 - line 237, column 51): " + [v.constructor.name, v1.constructor.name, v2.constructor.name]);
      };
    };
  };

  // output/Effect/foreign.js
  var pureE = function(a) {
    return function() {
      return a;
    };
  };
  var bindE = function(a) {
    return function(f) {
      return function() {
        return f(a())();
      };
    };
  };

  // output/Control.Monad/index.js
  var ap = function(dictMonad) {
    var bind3 = bind(dictMonad.Bind1());
    var pure3 = pure(dictMonad.Applicative0());
    return function(f) {
      return function(a) {
        return bind3(f)(function(f$prime) {
          return bind3(a)(function(a$prime) {
            return pure3(f$prime(a$prime));
          });
        });
      };
    };
  };

  // output/Data.Monoid/index.js
  var monoidArray = {
    mempty: [],
    Semigroup0: function() {
      return semigroupArray;
    }
  };
  var mempty = function(dict) {
    return dict.mempty;
  };

  // output/Effect/index.js
  var $runtime_lazy = function(name15, moduleName, init) {
    var state3 = 0;
    var val;
    return function(lineNumber) {
      if (state3 === 2)
        return val;
      if (state3 === 1)
        throw new ReferenceError(name15 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
      state3 = 1;
      val = init();
      state3 = 2;
      return val;
    };
  };
  var monadEffect = {
    Applicative0: function() {
      return applicativeEffect;
    },
    Bind1: function() {
      return bindEffect;
    }
  };
  var bindEffect = {
    bind: bindE,
    Apply0: function() {
      return $lazy_applyEffect(0);
    }
  };
  var applicativeEffect = {
    pure: pureE,
    Apply0: function() {
      return $lazy_applyEffect(0);
    }
  };
  var $lazy_functorEffect = /* @__PURE__ */ $runtime_lazy("functorEffect", "Effect", function() {
    return {
      map: liftA1(applicativeEffect)
    };
  });
  var $lazy_applyEffect = /* @__PURE__ */ $runtime_lazy("applyEffect", "Effect", function() {
    return {
      apply: ap(monadEffect),
      Functor0: function() {
        return $lazy_functorEffect(0);
      }
    };
  });
  var functorEffect = /* @__PURE__ */ $lazy_functorEffect(20);

  // output/Data.Tuple/index.js
  var Tuple = /* @__PURE__ */ function() {
    function Tuple2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    Tuple2.create = function(value0) {
      return function(value1) {
        return new Tuple2(value0, value1);
      };
    };
    return Tuple2;
  }();
  var snd = function(v) {
    return v.value1;
  };
  var fst = function(v) {
    return v.value0;
  };

  // output/Control.Monad.Trans.Class/index.js
  var lift = function(dict) {
    return dict.lift;
  };

  // output/Control.Monad.Writer.Trans/index.js
  var runWriterT = function(v) {
    return v;
  };
  var monadTransWriterT = function(dictMonoid) {
    var mempty2 = mempty(dictMonoid);
    return {
      lift: function(dictMonad) {
        var bind3 = bind(dictMonad.Bind1());
        var pure3 = pure(dictMonad.Applicative0());
        return function(m) {
          return bind3(m)(function(a) {
            return pure3(new Tuple(a, mempty2));
          });
        };
      }
    };
  };
  var mapWriterT = function(f) {
    return function(v) {
      return f(v);
    };
  };
  var functorWriterT = function(dictFunctor) {
    var map4 = map(dictFunctor);
    return {
      map: function(f) {
        return mapWriterT(map4(function(v) {
          return new Tuple(f(v.value0), v.value1);
        }));
      }
    };
  };
  var applyWriterT = function(dictSemigroup) {
    var append3 = append(dictSemigroup);
    return function(dictApply) {
      var apply2 = apply(dictApply);
      var Functor0 = dictApply.Functor0();
      var map4 = map(Functor0);
      var functorWriterT1 = functorWriterT(Functor0);
      return {
        apply: function(v) {
          return function(v1) {
            var k = function(v3) {
              return function(v4) {
                return new Tuple(v3.value0(v4.value0), append3(v3.value1)(v4.value1));
              };
            };
            return apply2(map4(k)(v))(v1);
          };
        },
        Functor0: function() {
          return functorWriterT1;
        }
      };
    };
  };
  var bindWriterT = function(dictSemigroup) {
    var append3 = append(dictSemigroup);
    var applyWriterT1 = applyWriterT(dictSemigroup);
    return function(dictBind) {
      var bind3 = bind(dictBind);
      var Apply0 = dictBind.Apply0();
      var map4 = map(Apply0.Functor0());
      var applyWriterT2 = applyWriterT1(Apply0);
      return {
        bind: function(v) {
          return function(k) {
            return bind3(v)(function(v1) {
              var v2 = k(v1.value0);
              return map4(function(v3) {
                return new Tuple(v3.value0, append3(v1.value1)(v3.value1));
              })(v2);
            });
          };
        },
        Apply0: function() {
          return applyWriterT2;
        }
      };
    };
  };
  var applicativeWriterT = function(dictMonoid) {
    var mempty2 = mempty(dictMonoid);
    var applyWriterT1 = applyWriterT(dictMonoid.Semigroup0());
    return function(dictApplicative) {
      var pure3 = pure(dictApplicative);
      var applyWriterT2 = applyWriterT1(dictApplicative.Apply0());
      return {
        pure: function(a) {
          return pure3(new Tuple(a, mempty2));
        },
        Apply0: function() {
          return applyWriterT2;
        }
      };
    };
  };

  // output/Effect.Console/foreign.js
  var log = function(s) {
    return function() {
      console.log(s);
    };
  };

  // output/Data.Array/foreign.js
  var replicateFill = function(count) {
    return function(value12) {
      if (count < 1) {
        return [];
      }
      var result = new Array(count);
      return result.fill(value12);
    };
  };
  var replicatePolyfill = function(count) {
    return function(value12) {
      var result = [];
      var n = 0;
      for (var i = 0; i < count; i++) {
        result[n++] = value12;
      }
      return result;
    };
  };
  var replicate = typeof Array.prototype.fill === "function" ? replicateFill : replicatePolyfill;
  var fromFoldableImpl = function() {
    function Cons(head, tail) {
      this.head = head;
      this.tail = tail;
    }
    var emptyList = {};
    function curryCons(head) {
      return function(tail) {
        return new Cons(head, tail);
      };
    }
    function listToArray(list) {
      var result = [];
      var count = 0;
      var xs = list;
      while (xs !== emptyList) {
        result[count++] = xs.head;
        xs = xs.tail;
      }
      return result;
    }
    return function(foldr2) {
      return function(xs) {
        return listToArray(foldr2(curryCons)(emptyList)(xs));
      };
    };
  }();
  var length = function(xs) {
    return xs.length;
  };
  var unconsImpl = function(empty2) {
    return function(next) {
      return function(xs) {
        return xs.length === 0 ? empty2({}) : next(xs[0])(xs.slice(1));
      };
    };
  };
  var reverse = function(l) {
    return l.slice().reverse();
  };
  var filter = function(f) {
    return function(xs) {
      return xs.filter(f);
    };
  };
  var sortByImpl = function() {
    function mergeFromTo(compare2, fromOrdering, xs1, xs2, from2, to) {
      var mid;
      var i;
      var j;
      var k;
      var x;
      var y;
      var c;
      mid = from2 + (to - from2 >> 1);
      if (mid - from2 > 1)
        mergeFromTo(compare2, fromOrdering, xs2, xs1, from2, mid);
      if (to - mid > 1)
        mergeFromTo(compare2, fromOrdering, xs2, xs1, mid, to);
      i = from2;
      j = mid;
      k = from2;
      while (i < mid && j < to) {
        x = xs2[i];
        y = xs2[j];
        c = fromOrdering(compare2(x)(y));
        if (c > 0) {
          xs1[k++] = y;
          ++j;
        } else {
          xs1[k++] = x;
          ++i;
        }
      }
      while (i < mid) {
        xs1[k++] = xs2[i++];
      }
      while (j < to) {
        xs1[k++] = xs2[j++];
      }
    }
    return function(compare2) {
      return function(fromOrdering) {
        return function(xs) {
          var out;
          if (xs.length < 2)
            return xs;
          out = xs.slice(0);
          mergeFromTo(compare2, fromOrdering, out, xs.slice(0), 0, xs.length);
          return out;
        };
      };
    };
  }();
  var slice = function(s) {
    return function(e) {
      return function(l) {
        return l.slice(s, e);
      };
    };
  };
  var zipWith = function(f) {
    return function(xs) {
      return function(ys) {
        var l = xs.length < ys.length ? xs.length : ys.length;
        var result = new Array(l);
        for (var i = 0; i < l; i++) {
          result[i] = f(xs[i])(ys[i]);
        }
        return result;
      };
    };
  };

  // output/Data.Array.ST/foreign.js
  var sortByImpl2 = function() {
    function mergeFromTo(compare2, fromOrdering, xs1, xs2, from2, to) {
      var mid;
      var i;
      var j;
      var k;
      var x;
      var y;
      var c;
      mid = from2 + (to - from2 >> 1);
      if (mid - from2 > 1)
        mergeFromTo(compare2, fromOrdering, xs2, xs1, from2, mid);
      if (to - mid > 1)
        mergeFromTo(compare2, fromOrdering, xs2, xs1, mid, to);
      i = from2;
      j = mid;
      k = from2;
      while (i < mid && j < to) {
        x = xs2[i];
        y = xs2[j];
        c = fromOrdering(compare2(x)(y));
        if (c > 0) {
          xs1[k++] = y;
          ++j;
        } else {
          xs1[k++] = x;
          ++i;
        }
      }
      while (i < mid) {
        xs1[k++] = xs2[i++];
      }
      while (j < to) {
        xs1[k++] = xs2[j++];
      }
    }
    return function(compare2) {
      return function(fromOrdering) {
        return function(xs) {
          return function() {
            if (xs.length < 2)
              return xs;
            mergeFromTo(compare2, fromOrdering, xs, xs.slice(0), 0, xs.length);
            return xs;
          };
        };
      };
    };
  }();

  // output/Data.Foldable/foreign.js
  var foldrArray = function(f) {
    return function(init) {
      return function(xs) {
        var acc = init;
        var len = xs.length;
        for (var i = len - 1; i >= 0; i--) {
          acc = f(xs[i])(acc);
        }
        return acc;
      };
    };
  };
  var foldlArray = function(f) {
    return function(init) {
      return function(xs) {
        var acc = init;
        var len = xs.length;
        for (var i = 0; i < len; i++) {
          acc = f(acc)(xs[i]);
        }
        return acc;
      };
    };
  };

  // output/Unsafe.Coerce/foreign.js
  var unsafeCoerce2 = function(x) {
    return x;
  };

  // output/Data.Foldable/index.js
  var foldr = function(dict) {
    return dict.foldr;
  };
  var traverse_ = function(dictApplicative) {
    var applySecond2 = applySecond(dictApplicative.Apply0());
    var pure3 = pure(dictApplicative);
    return function(dictFoldable) {
      var foldr2 = foldr(dictFoldable);
      return function(f) {
        return foldr2(function($454) {
          return applySecond2(f($454));
        })(pure3(unit));
      };
    };
  };
  var for_ = function(dictApplicative) {
    var traverse_1 = traverse_(dictApplicative);
    return function(dictFoldable) {
      return flip(traverse_1(dictFoldable));
    };
  };
  var foldl = function(dict) {
    return dict.foldl;
  };
  var sum = function(dictFoldable) {
    var foldl22 = foldl(dictFoldable);
    return function(dictSemiring) {
      return foldl22(add(dictSemiring))(zero(dictSemiring));
    };
  };
  var foldMapDefaultR = function(dictFoldable) {
    var foldr2 = foldr(dictFoldable);
    return function(dictMonoid) {
      var append3 = append(dictMonoid.Semigroup0());
      var mempty2 = mempty(dictMonoid);
      return function(f) {
        return foldr2(function(x) {
          return function(acc) {
            return append3(f(x))(acc);
          };
        })(mempty2);
      };
    };
  };
  var foldableArray = {
    foldr: foldrArray,
    foldl: foldlArray,
    foldMap: function(dictMonoid) {
      return foldMapDefaultR(foldableArray)(dictMonoid);
    }
  };

  // output/Data.Traversable/foreign.js
  var traverseArrayImpl = function() {
    function array1(a) {
      return [a];
    }
    function array2(a) {
      return function(b) {
        return [a, b];
      };
    }
    function array3(a) {
      return function(b) {
        return function(c) {
          return [a, b, c];
        };
      };
    }
    function concat2(xs) {
      return function(ys) {
        return xs.concat(ys);
      };
    }
    return function(apply2) {
      return function(map4) {
        return function(pure3) {
          return function(f) {
            return function(array) {
              function go2(bot, top2) {
                switch (top2 - bot) {
                  case 0:
                    return pure3([]);
                  case 1:
                    return map4(array1)(f(array[bot]));
                  case 2:
                    return apply2(map4(array2)(f(array[bot])))(f(array[bot + 1]));
                  case 3:
                    return apply2(apply2(map4(array3)(f(array[bot])))(f(array[bot + 1])))(f(array[bot + 2]));
                  default:
                    var pivot = bot + Math.floor((top2 - bot) / 4) * 2;
                    return apply2(map4(concat2)(go2(bot, pivot)))(go2(pivot, top2));
                }
              }
              return go2(0, array.length);
            };
          };
        };
      };
    };
  }();

  // output/Data.Traversable/index.js
  var identity3 = /* @__PURE__ */ identity(categoryFn);
  var traverse = function(dict) {
    return dict.traverse;
  };
  var sequenceDefault = function(dictTraversable) {
    var traverse2 = traverse(dictTraversable);
    return function(dictApplicative) {
      return traverse2(dictApplicative)(identity3);
    };
  };
  var traversableArray = {
    traverse: function(dictApplicative) {
      var Apply0 = dictApplicative.Apply0();
      return traverseArrayImpl(apply(Apply0))(map(Apply0.Functor0()))(pure(dictApplicative));
    },
    sequence: function(dictApplicative) {
      return sequenceDefault(traversableArray)(dictApplicative);
    },
    Functor0: function() {
      return functorArray;
    },
    Foldable1: function() {
      return foldableArray;
    }
  };
  var $$for = function(dictApplicative) {
    return function(dictTraversable) {
      var traverse2 = traverse(dictTraversable)(dictApplicative);
      return function(x) {
        return function(f) {
          return traverse2(f)(x);
        };
      };
    };
  };

  // output/Data.Array/index.js
  var append2 = /* @__PURE__ */ append(semigroupArray);
  var zip = /* @__PURE__ */ function() {
    return zipWith(Tuple.create);
  }();
  var uncons = /* @__PURE__ */ function() {
    return unconsImpl($$const(Nothing.value))(function(x) {
      return function(xs) {
        return new Just({
          head: x,
          tail: xs
        });
      };
    });
  }();
  var sortBy = function(comp) {
    return sortByImpl(comp)(function(v) {
      if (v instanceof GT) {
        return 1;
      }
      ;
      if (v instanceof EQ) {
        return 0;
      }
      ;
      if (v instanceof LT) {
        return -1 | 0;
      }
      ;
      throw new Error("Failed pattern match at Data.Array (line 870, column 31 - line 873, column 11): " + [v.constructor.name]);
    });
  };
  var sortWith = function(dictOrd) {
    var comparing2 = comparing(dictOrd);
    return function(f) {
      return sortBy(comparing2(f));
    };
  };
  var singleton2 = function(a) {
    return [a];
  };
  var drop = function(n) {
    return function(xs) {
      var $172 = n < 1;
      if ($172) {
        return xs;
      }
      ;
      return slice(n)(length(xs))(xs);
    };
  };
  var cons = function(x) {
    return function(xs) {
      return append2([x])(xs);
    };
  };
  var concatMap = /* @__PURE__ */ flip(/* @__PURE__ */ bind(bindArray));
  var mapMaybe = function(f) {
    return concatMap(function() {
      var $190 = maybe([])(singleton2);
      return function($191) {
        return $190(f($191));
      };
    }());
  };

  // output/Stats/index.js
  var growthIsSymbol = {
    reflectSymbol: function() {
      return "growth";
    }
  };
  var priceIsSymbol = {
    reflectSymbol: function() {
      return "price";
    }
  };
  var seedsIsSymbol = {
    reflectSymbol: function() {
      return "seeds";
    }
  };
  var semiringRecord2 = /* @__PURE__ */ semiringRecord()(/* @__PURE__ */ semiringRecordCons(growthIsSymbol)()(/* @__PURE__ */ semiringRecordCons(priceIsSymbol)()(/* @__PURE__ */ semiringRecordCons(seedsIsSymbol)()(semiringRecordNil)(semiringInt))(semiringInt))(semiringInt));
  var add2 = /* @__PURE__ */ add(semiringRecord2);
  var mul2 = /* @__PURE__ */ mul(semiringRecord2);
  var semiringStats = {
    zero: /* @__PURE__ */ zero(semiringRecord2),
    one: /* @__PURE__ */ one(semiringRecord2),
    add: function(v) {
      return function(v1) {
        return add2(v)(v1);
      };
    },
    mul: function(v) {
      return function(v1) {
        return mul2(v)(v1);
      };
    }
  };
  var seeds = function(n) {
    return {
      growth: 0,
      price: 0,
      seeds: n
    };
  };
  var price = function(n) {
    return {
      growth: 0,
      price: n,
      seeds: 0
    };
  };
  var growth = function(n) {
    return {
      growth: n,
      price: 0,
      seeds: 0
    };
  };

  // output/Cards/index.js
  var weedCard = {
    description: "Weeds are dangerus to your plants but they grow well",
    name: "Weeds",
    stats: /* @__PURE__ */ add(semiringStats)(/* @__PURE__ */ seeds(2))(/* @__PURE__ */ growth(2)),
    discard: 2
  };
  var basicSeeds = {
    description: "No seeds no... plants",
    name: "Basic Seeds",
    stats: /* @__PURE__ */ seeds(1),
    discard: 0
  };
  var basicPrice = {
    description: "Money makes the world go round",
    name: "Basic Money",
    stats: /* @__PURE__ */ price(1),
    discard: 0
  };
  var basicGrowth = {
    description: "Without growth your plants will die",
    name: "Basic Growth",
    stats: /* @__PURE__ */ growth(1),
    discard: 0
  };

  // output/Seeds/index.js
  var weedSeed = {
    daysToHarvest: 3,
    genome: [basicGrowth, basicGrowth, weedCard, basicPrice, basicPrice],
    stats: {
      growth: 0,
      price: 0,
      seeds: 0
    }
  };
  var baseSeed = {
    daysToHarvest: 3,
    genome: [basicGrowth, basicGrowth, basicGrowth, basicGrowth, basicSeeds, basicSeeds, basicPrice],
    stats: {
      growth: 0,
      price: 0,
      seeds: 0
    }
  };

  // output/Effect.Random/foreign.js
  var random = Math.random;

  // output/Effect.Timer/foreign.js
  function setTimeoutImpl(ms) {
    return function(fn) {
      return function() {
        return setTimeout(fn, ms);
      };
    };
  }

  // output/Effect.Timer/index.js
  var setTimeout2 = setTimeoutImpl;

  // output/Util/index.js
  var $$for2 = /* @__PURE__ */ $$for(applicativeEffect)(traversableArray);
  var identity4 = /* @__PURE__ */ identity(categoryFn);
  var map2 = /* @__PURE__ */ map(functorArray);
  var sortWith2 = /* @__PURE__ */ sortWith(ordNumber);
  var $$void2 = /* @__PURE__ */ $$void(functorEffect);
  var shuffle = function(a) {
    var actions = replicate(length(a))(random);
    return function __do2() {
      var numbers = $$for2(actions)(identity4)();
      return map2(snd)(sortWith2(fst)(zip(numbers)(a)));
    };
  };
  var doXEvery = /* @__PURE__ */ function() {
    var go2 = function(y) {
      return function(t) {
        return function(x) {
          return function(f) {
            return function(a) {
              return function __do2() {
                var a$prime = f(y)(a)();
                var $11 = x > y;
                if ($11) {
                  return $$void2(setTimeout2(t)(go2(y + 1 | 0)(t)(x)(f)(a$prime)))();
                }
                ;
                return unit;
              };
            };
          };
        };
      };
    };
    return go2(0);
  }();

  // output/Plants/index.js
  var add3 = /* @__PURE__ */ add(semiringStats);
  var shouldHarvest = function(v) {
    return v.stats.growth >= v.daysToHarvest;
  };
  var plant = function(v) {
    return function __do2() {
      var cards = shuffle(v.genome)();
      return {
        cards,
        stats: v.stats,
        daysToHarvest: v.daysToHarvest,
        seed: v
      };
    };
  };
  var age = function(v) {
    var v1 = uncons(v.cards);
    if (v1 instanceof Nothing) {
      return Nothing.value;
    }
    ;
    if (v1 instanceof Just) {
      return new Just({
        daysToHarvest: v.daysToHarvest,
        cards: drop(v1.value0.head.discard)(v1.value0.tail),
        stats: add3(v.stats)(v1.value0.head.stats),
        seed: v.seed
      });
    }
    ;
    throw new Error("Failed pattern match at Plants (line 36, column 17 - line 41, column 10): " + [v1.constructor.name]);
  };

  // output/Game/index.js
  var show2 = /* @__PURE__ */ show(showInt);
  var pure2 = /* @__PURE__ */ pure(applicativeEffect);
  var sum2 = /* @__PURE__ */ sum(foldableArray)(semiringInt);
  var map3 = /* @__PURE__ */ map(functorArray);
  var bind1 = /* @__PURE__ */ bind(bindArray);
  var append1 = /* @__PURE__ */ append(semigroupArray);
  var pure1 = /* @__PURE__ */ pure(applicativeArray);
  var bind2 = /* @__PURE__ */ bind(/* @__PURE__ */ bindWriterT(semigroupArray)(bindEffect));
  var lift3 = /* @__PURE__ */ lift(/* @__PURE__ */ monadTransWriterT(monoidArray))(monadEffect);
  var pure22 = /* @__PURE__ */ pure(/* @__PURE__ */ applicativeWriterT(monoidArray)(applicativeEffect));
  var Grass = /* @__PURE__ */ function() {
    function Grass2() {
    }
    ;
    Grass2.value = new Grass2();
    return Grass2;
  }();
  var Dirt = /* @__PURE__ */ function() {
    function Dirt2(value0) {
      this.value0 = value0;
    }
    ;
    Dirt2.create = function(value0) {
      return new Dirt2(value0);
    };
    return Dirt2;
  }();
  var showGame = {
    show: function(v) {
      var plants = length(filter(function(v1) {
        if (v1 instanceof Dirt && v1.value0 instanceof Just) {
          return true;
        }
        ;
        return false;
      })(v.land));
      var grass = length(filter(function(v1) {
        if (v1 instanceof Grass) {
          return true;
        }
        ;
        return false;
      })(v.land));
      var free = length(filter(function(v1) {
        if (v1 instanceof Dirt && v1.value0 instanceof Nothing) {
          return true;
        }
        ;
        return false;
      })(v.land));
      return "Money: " + (show2(v.money) + ("\n" + ("Grass: " + (show2(grass) + ("\n" + ("Plants: " + (show2(plants) + ("\n" + ("Free: " + (show2(free) + ("\n" + ("Seeds: " + show2(length(v.seeds))))))))))))));
    }
  };
  var functorLand = {
    map: function(f) {
      return function(m) {
        if (m instanceof Grass) {
          return Grass.value;
        }
        ;
        if (m instanceof Dirt) {
          return new Dirt(f(m.value0));
        }
        ;
        throw new Error("Failed pattern match at Game (line 0, column 0 - line 0, column 0): " + [m.constructor.name]);
      };
    }
  };
  var map1 = /* @__PURE__ */ map(functorLand);
  var start = /* @__PURE__ */ function() {
    return {
      land: [Grass.value, Grass.value, Grass.value, Grass.value, new Dirt(Nothing.value), Grass.value, Grass.value, Grass.value, Grass.value],
      seeds: [baseSeed, baseSeed, weedSeed, weedSeed],
      money: 30
    };
  }();
  var plantSeeds = function(v) {
    var go2 = function(land) {
      return function(seeds2) {
        var v1 = uncons(land);
        if (v1 instanceof Nothing) {
          return pure2({
            land,
            seeds: seeds2
          });
        }
        ;
        if (v1 instanceof Just && (v1.value0.head instanceof Dirt && v1.value0.head.value0 instanceof Nothing)) {
          var v2 = uncons(seeds2);
          if (v2 instanceof Nothing) {
            return pure2({
              land,
              seeds: seeds2
            });
          }
          ;
          if (v2 instanceof Just) {
            return function __do2() {
              var plant$prime = plant(v2.value0.head)();
              var v3 = go2(v1.value0.tail)(v2.value0.tail)();
              return {
                land: cons(new Dirt(new Just(plant$prime)))(v3.land),
                seeds: v3.seeds
              };
            };
          }
          ;
          throw new Error("Failed pattern match at Game (line 98, column 50 - line 104, column 80): " + [v2.constructor.name]);
        }
        ;
        if (v1 instanceof Just) {
          return function __do2() {
            var v22 = go2(v1.value0.tail)(seeds2)();
            return {
              land: cons(v1.value0.head)(v22.land),
              seeds: v22.seeds
            };
          };
        }
        ;
        throw new Error("Failed pattern match at Game (line 95, column 25 - line 108, column 57): " + [v1.constructor.name]);
      };
    };
    return function __do2() {
      var v1 = go2(v.land)(v.seeds)();
      return {
        land: v1.land,
        seeds: v1.seeds,
        money: v.money
      };
    };
  };
  var harvestPlants = function(v) {
    var harvested = mapMaybe(function(v1) {
      if (v1 instanceof Dirt && v1.value0 instanceof Just) {
        var $97 = shouldHarvest(v1.value0.value0);
        if ($97) {
          return new Just(v1.value0.value0);
        }
        ;
        return Nothing.value;
      }
      ;
      return Nothing.value;
    })(v.land);
    var revenue = sum2(map3(function(v1) {
      return v1.price;
    })(map3(function(v1) {
      return v1.stats;
    })(harvested)));
    var seeds$prime = bind1(harvested)(function(v1) {
      return replicate(v1.stats.seeds)(v1.seed);
    });
    return {
      land: map3(function(v2) {
        if (v2 instanceof Dirt && v2.value0 instanceof Just) {
          var $109 = shouldHarvest(v2.value0.value0);
          if ($109) {
            return new Dirt(Nothing.value);
          }
          ;
          return new Dirt(new Just(v2.value0.value0));
        }
        ;
        return v2;
      })(v.land),
      seeds: append1(v.seeds)(seeds$prime),
      money: v.money + revenue | 0
    };
  };
  var clearGrass = function(v) {
    var go2 = function($copy_v1) {
      var $tco_done = false;
      var $tco_result;
      function $tco_loop(v1) {
        var $114 = v1.money < 10;
        if ($114) {
          $tco_done = true;
          return {
            acc: v1.acc,
            land: v1.land,
            money: v1.money
          };
        }
        ;
        var v2 = uncons(v1.land);
        if (v2 instanceof Nothing) {
          $tco_done = true;
          return {
            acc: v1.acc,
            land: v1.land,
            money: v1.money
          };
        }
        ;
        if (v2 instanceof Just && v2.value0.head instanceof Grass) {
          $copy_v1 = {
            acc: cons(new Dirt(Nothing.value))(v1.acc),
            land: v2.value0.tail,
            money: v1.money - 10 | 0
          };
          return;
        }
        ;
        if (v2 instanceof Just) {
          $copy_v1 = {
            acc: cons(v2.value0.head)(v1.acc),
            land: v2.value0.tail,
            money: v1.money
          };
          return;
        }
        ;
        throw new Error("Failed pattern match at Game (line 120, column 18 - line 128, column 58): " + [v2.constructor.name]);
      }
      ;
      while (!$tco_done) {
        $tco_result = $tco_loop($copy_v1);
      }
      ;
      return $tco_result;
    };
    var result = go2({
      acc: [],
      land: v.land,
      money: v.money
    });
    return {
      land: append1(reverse(result.acc))(result.land),
      seeds: v.seeds,
      money: result.money
    };
  };
  var agePlants = function(v) {
    return {
      land: function(land) {
        return bind1(land)(function(l) {
          return pure1(map1(function(v2) {
            if (v2 instanceof Nothing) {
              return Nothing.value;
            }
            ;
            if (v2 instanceof Just) {
              return age(v2.value0);
            }
            ;
            throw new Error("Failed pattern match at Game (line 55, column 17 - line 57, column 28): " + [v2.constructor.name]);
          })(l));
        });
      }(v.land),
      seeds: v.seeds,
      money: v.money
    };
  };
  var tick = function(game) {
    return bind2(lift3(plantSeeds(clearGrass(game))))(function(game$prime) {
      return pure22(harvestPlants(agePlants(game$prime)));
    });
  };

  // output/Web.DOM.Document/foreign.js
  var getEffProp = function(name15) {
    return function(doc) {
      return function() {
        return doc[name15];
      };
    };
  };
  var url = getEffProp("URL");
  var documentURI = getEffProp("documentURI");
  var origin = getEffProp("origin");
  var compatMode = getEffProp("compatMode");
  var characterSet = getEffProp("characterSet");
  var contentType = getEffProp("contentType");
  var _documentElement = getEffProp("documentElement");
  function getElementsByClassName(classNames) {
    return function(doc) {
      return function() {
        return doc.getElementsByClassName(classNames);
      };
    };
  }

  // output/Web.DOM.Element/foreign.js
  var getProp = function(name15) {
    return function(doctype) {
      return doctype[name15];
    };
  };
  var _namespaceURI = getProp("namespaceURI");
  var _prefix = getProp("prefix");
  var localName = getProp("localName");
  var tagName = getProp("tagName");
  function setClassName(className2) {
    return function(node) {
      return function() {
        node.className = className2;
      };
    };
  }

  // output/Web.DOM.ParentNode/foreign.js
  var getEffProp2 = function(name15) {
    return function(node) {
      return function() {
        return node[name15];
      };
    };
  };
  var children = getEffProp2("children");
  var _firstElementChild = getEffProp2("firstElementChild");
  var _lastElementChild = getEffProp2("lastElementChild");
  var childElementCount = getEffProp2("childElementCount");

  // output/Web.DOM.HTMLCollection/foreign.js
  function toArray(list) {
    return function() {
      return [].slice.call(list);
    };
  }

  // output/Web.HTML/foreign.js
  var windowImpl = function() {
    return window;
  };

  // output/Web.HTML.HTMLDocument/index.js
  var toDocument = unsafeCoerce2;

  // output/Web.HTML.Window/foreign.js
  function document(window2) {
    return function() {
      return window2.document;
    };
  }

  // output/Render/index.js
  var $$void3 = /* @__PURE__ */ $$void(functorEffect);
  var for_2 = /* @__PURE__ */ for_(applicativeEffect)(foldableArray);
  var render = function(v) {
    return function(v1) {
      return function __do2() {
        log("Render")();
        var w = windowImpl();
        var d = document(w)();
        var collection = getElementsByClassName("tile")(toDocument(d))();
        var elements = toArray(collection)();
        return $$void3(for_2(zip(v.land)(elements))(function(v2) {
          return setClassName(function() {
            if (v2.value0 instanceof Grass) {
              return "tile tile-grass";
            }
            ;
            if (v2.value0 instanceof Dirt && v2.value0.value0 instanceof Nothing) {
              return "tile tile-dirt";
            }
            ;
            if (v2.value0 instanceof Dirt && v2.value0.value0 instanceof Just) {
              return "tile tile-seedling";
            }
            ;
            throw new Error("Failed pattern match at Render (line 28, column 31 - line 31, column 49): " + [v2.value0.constructor.name]);
          }())(v2.value1);
        }))();
      };
    };
  };

  // output/Main/index.js
  var show3 = /* @__PURE__ */ show(showInt);
  var show1 = /* @__PURE__ */ show(showGame);
  var main = function __do() {
    render(start)([])();
    return doXEvery(500)(100)(function(d) {
      return function(game) {
        return function __do2() {
          log("Day " + show3(d))();
          log(show1(game))();
          log("")();
          var v = runWriterT(tick(game))();
          render(v.value0)(v.value1)();
          return v.value0;
        };
      };
    })(start)();
  };

  // <stdin>
  main();
})();
