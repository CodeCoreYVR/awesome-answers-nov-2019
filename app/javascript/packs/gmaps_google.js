(function() {
  this.Gmaps = {
    build: function(e, t) {
      var n;
      if (t == null) {
        t = {};
      }
      n = _.isFunction(t.handler) ? t.handler : Gmaps.Objects.Handler;
      return new n(e, t);
    },
    Builders: {},
    Objects: {},
    Google: { Objects: {}, Builders: {} }
  };
}.call(this));
(function() {
  var e,
    t =
      [].indexOf ||
      function(e) {
        for (var t = 0, n = this.length; t < n; t++) {
          if (t in this && this[t] === e) return t;
        }
        return -1;
      };
  e = ["extended", "included"];
  this.Gmaps.Base = (function() {
    function n() {}
    n.extend = function(n) {
      var r, i, s;
      for (r in n) {
        i = n[r];
        if (t.call(e, r) < 0) {
          this[r] = i;
        }
      }
      if ((s = n.extended) != null) {
        s.apply(this);
      }
      return this;
    };
    n.include = function(n) {
      var r, i, s;
      for (r in n) {
        i = n[r];
        if (t.call(e, r) < 0) {
          this.prototype[r] = i;
        }
      }
      if ((s = n.included) != null) {
        s.apply(this);
      }
      return this;
    };
    return n;
  })();
}.call(this));
(function() {
  this.Gmaps.Objects.BaseBuilder = (function() {
    function e() {}
    e.prototype.build = function() {
      return new (this.model_class())(this.serviceObject);
    };
    e.prototype.before_init = function() {};
    e.prototype.after_init = function() {};
    e.prototype.addListener = function(e, t) {
      return this.primitives().addListener(this.getServiceObject(), e, t);
    };
    e.prototype.getServiceObject = function() {
      return this.serviceObject;
    };
    e.prototype.primitives = function() {
      return this.constructor.PRIMITIVES;
    };
    e.prototype.model_class = function() {
      return this.constructor.OBJECT;
    };
    return e;
  })();
}.call(this));
(function() {
  this.Gmaps.Objects.Builders = function(e, t, n) {
    return {
      build: function(r, i, s) {
        var o;
        t.PRIMITIVES = n;
        e.OBJECT = t;
        e.PRIMITIVES = n;
        o = new e(r, i, s);
        return o.build();
      }
    };
  };
}.call(this));
(function() {
  this.Gmaps.Objects.Handler = (function() {
    function e(e, t) {
      this.type = e;
      if (t == null) {
        t = {};
      }
      this.setPrimitives(t);
      this.setOptions(t);
      this._cacheAllBuilders();
      this.resetBounds();
    }
    e.prototype.buildMap = function(e, t) {
      var n = this;
      if (t == null) {
        t = function() {};
      }
      return (this.map = this._builder("Map").build(e, function() {
        n._createClusterer();
        return t();
      }));
    };
    e.prototype.addMarkers = function(e, t) {
      var n = this;
      return _.map(e, function(e) {
        return n.addMarker(e, t);
      });
    };
    e.prototype.addMarker = function(e, t) {
      var n;
      n = this._builder("Marker").build(e, t, this.marker_options);
      n.setMap(this.getMap());
      this.clusterer.addMarker(n);
      return n;
    };
    e.prototype.addCircles = function(e, t) {
      var n = this;
      return _.map(e, function(e) {
        return n.addCircle(e, t);
      });
    };
    e.prototype.addCircle = function(e, t) {
      return this._addResource("circle", e, t);
    };
    e.prototype.addPolylines = function(e, t) {
      var n = this;
      return _.map(e, function(e) {
        return n.addPolyline(e, t);
      });
    };
    e.prototype.addPolyline = function(e, t) {
      return this._addResource("polyline", e, t);
    };
    e.prototype.addPolygons = function(e, t) {
      var n = this;
      return _.map(e, function(e) {
        return n.addPolygon(e, t);
      });
    };
    e.prototype.addPolygon = function(e, t) {
      return this._addResource("polygon", e, t);
    };
    e.prototype.addKmls = function(e, t) {
      var n = this;
      return _.map(e, function(e) {
        return n.addKml(e, t);
      });
    };
    e.prototype.addKml = function(e, t) {
      return this._addResource("kml", e, t);
    };
    e.prototype.removeMarkers = function(e) {
      var t = this;
      return _.map(e, function(e) {
        return t.removeMarker(e);
      });
    };
    e.prototype.removeMarker = function(e) {
      e.clear();
      return this.clusterer.removeMarker(e);
    };
    e.prototype.fitMapToBounds = function() {
      return this.map.fitToBounds(this.bounds.getServiceObject());
    };
    e.prototype.getMap = function() {
      return this.map.getServiceObject();
    };
    e.prototype.setOptions = function(e) {
      this.marker_options = _.extend(this._default_marker_options(), e.markers);
      this.builders = _.extend(this._default_builders(), e.builders);
      return (this.models = _.extend(this._default_models(), e.models));
    };
    e.prototype.resetBounds = function() {
      return (this.bounds = this._builder("Bound").build());
    };
    e.prototype.setPrimitives = function(e) {
      return (this.primitives =
        e.primitives === void 0
          ? this._rootModule().Primitives()
          : _.isFunction(e.primitives)
          ? e.primitives()
          : e.primitives);
    };
    e.prototype.currentInfowindow = function() {
      return this.builders.Marker.CURRENT_INFOWINDOW;
    };
    e.prototype._addResource = function(e, t, n) {
      var r;
      r = this._builder(e).build(t, n);
      r.setMap(this.getMap());
      return r;
    };
    e.prototype._cacheAllBuilders = function() {
      var e;
      e = this;
      return _.each(
        [
          "Bound",
          "Circle",
          "Clusterer",
          "Kml",
          "Map",
          "Marker",
          "Polygon",
          "Polyline"
        ],
        function(t) {
          return e._builder(t);
        }
      );
    };
    e.prototype._clusterize = function() {
      return _.isObject(this.marker_options.clusterer);
    };
    e.prototype._createClusterer = function() {
      return (this.clusterer = this._builder("Clusterer").build(
        { map: this.getMap() },
        this.marker_options.clusterer
      ));
    };
    e.prototype._default_marker_options = function() {
      return _.clone({
        singleInfowindow: true,
        maxRandomDistance: 0,
        clusterer: { maxZoom: 5, gridSize: 50 }
      });
    };
    e.prototype._builder = function(e) {
      var t;
      e = this._capitalize(e);
      if (this[(t = "__builder" + e)] == null) {
        this[t] = Gmaps.Objects.Builders(
          this.builders[e],
          this.models[e],
          this.primitives
        );
      }
      return this["__builder" + e];
    };
    e.prototype._default_models = function() {
      var e;
      e = _.clone(this._rootModule().Objects);
      if (this._clusterize()) {
        return e;
      } else {
        e.Clusterer = Gmaps.Objects.NullClusterer;
        return e;
      }
    };
    e.prototype._capitalize = function(e) {
      return e.charAt(0).toUpperCase() + e.slice(1);
    };
    e.prototype._default_builders = function() {
      return _.clone(this._rootModule().Builders);
    };
    e.prototype._rootModule = function() {
      if (this.__rootModule == null) {
        this.__rootModule = Gmaps[this.type];
      }
      return this.__rootModule;
    };
    return e;
  })();
}.call(this));
(function() {
  this.Gmaps.Objects.NullClusterer = (function() {
    function e() {}
    e.prototype.addMarkers = function() {};
    e.prototype.addMarker = function() {};
    e.prototype.clear = function() {};
    e.prototype.removeMarker = function() {};
    return e;
  })();
}.call(this));
(function() {
  this.Gmaps.Google.Objects.Common = {
    getServiceObject: function() {
      return this.serviceObject;
    },
    setMap: function(e) {
      return this.getServiceObject().setMap(e);
    },
    clear: function() {
      return this.getServiceObject().setMap(null);
    },
    show: function() {
      return this.getServiceObject().setVisible(true);
    },
    hide: function() {
      return this.getServiceObject().setVisible(false);
    },
    isVisible: function() {
      return this.getServiceObject().getVisible();
    },
    primitives: function() {
      return this.constructor.PRIMITIVES;
    }
  };
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Builders.Bound = (function(e) {
    function n(e) {
      this.before_init();
      this.serviceObject = new (this.primitives().latLngBounds)();
      this.after_init();
    }
    t(n, e);
    return n;
  })(Gmaps.Objects.BaseBuilder);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Builders.Circle = (function(e) {
    function n(e, t) {
      this.args = e;
      this.provider_options = t != null ? t : {};
      this.before_init();
      this.serviceObject = this.create_circle();
      this.after_init();
    }
    t(n, e);
    n.prototype.create_circle = function() {
      return new (this.primitives().circle)(this.circle_options());
    };
    n.prototype.circle_options = function() {
      var e;
      e = {
        center: new (this.primitives().latLng)(this.args.lat, this.args.lng),
        radius: this.args.radius
      };
      return _.defaults(e, this.provider_options);
    };
    return n;
  })(Gmaps.Objects.BaseBuilder);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Builders.Clusterer = (function(e) {
    function n(e, t) {
      this.args = e;
      this.options = t;
      this.before_init();
      this.serviceObject = new (this.primitives().clusterer)(
        this.args.map,
        [],
        this.options
      );
      this.after_init();
    }
    t(n, e);
    return n;
  })(Gmaps.Objects.BaseBuilder);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Builders.Kml = (function(e) {
    function n(e, t) {
      this.args = e;
      this.provider_options = t != null ? t : {};
      this.before_init();
      this.serviceObject = this.create_kml();
      this.after_init();
    }
    t(n, e);
    n.prototype.create_kml = function() {
      return new (this.primitives().kml)(this.args.url, this.kml_options());
    };
    n.prototype.kml_options = function() {
      var e;
      e = {};
      return _.defaults(e, this.provider_options);
    };
    return n;
  })(Gmaps.Objects.BaseBuilder);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Builders.Map = (function(e) {
    function n(e, t) {
      var n;
      this.before_init();
      n = _.extend(this.default_options(), e.provider);
      this.internal_options = e.internal;
      this.serviceObject = new (this.primitives().map)(
        document.getElementById(this.internal_options.id),
        n
      );
      this.on_map_load(t);
      this.after_init();
    }
    t(n, e);
    n.prototype.build = function() {
      return new (this.model_class())(this.serviceObject, this.primitives());
    };
    n.prototype.on_map_load = function(e) {
      return this.primitives().addListenerOnce(this.serviceObject, "idle", e);
    };
    n.prototype.default_options = function() {
      return {
        mapTypeId: this.primitives().mapTypes("ROADMAP"),
        center: new (this.primitives().latLng)(0, 0),
        zoom: 8
      };
    };
    return n;
  })(Gmaps.Objects.BaseBuilder);
}.call(this));
(function() {
  var e = function(e, t) {
      return function() {
        return e.apply(t, arguments);
      };
    },
    t = {}.hasOwnProperty,
    n = function(e, n) {
      function i() {
        this.constructor = e;
      }
      for (var r in n) {
        if (t.call(n, r)) e[r] = n[r];
      }
      i.prototype = n.prototype;
      e.prototype = new i();
      e.__super__ = n.prototype;
      return e;
    };
  this.Gmaps.Google.Builders.Marker = (function(t) {
    function r(t, n, r) {
      this.args = t;
      this.provider_options = n != null ? n : {};
      this.internal_options = r != null ? r : {};
      this.infowindow_binding = e(this.infowindow_binding, this);
      this.before_init();
      this.create_marker();
      this.create_infowindow_on_click();
      this.after_init();
    }
    n(r, t);
    r.CURRENT_INFOWINDOW = void 0;
    r.CACHE_STORE = {};
    r.prototype.build = function() {
      return (this.marker = new (this.model_class())(this.serviceObject));
    };
    r.prototype.create_marker = function() {
      return (this.serviceObject = new (this.primitives().marker)(
        this.marker_options()
      ));
    };
    r.prototype.create_infowindow = function() {
      if (!_.isString(this.args.infowindow)) {
        return null;
      }
      return new (this.primitives().infowindow)({
        content: this.args.infowindow
      });
    };
    r.prototype.marker_options = function() {
      var e, t;
      t = this._randomized_coordinates();
      e = {
        title: this.args.marker_title,
        position: new (this.primitives().latLng)(t[0], t[1]),
        icon: this._get_picture("picture"),
        shadow: this._get_picture("shadow")
      };
      return _.extend(this.provider_options, e);
    };
    r.prototype.create_infowindow_on_click = function() {
      return this.addListener("click", this.infowindow_binding);
    };
    r.prototype.infowindow_binding = function() {
      var e;
      if (this._should_close_infowindow()) {
        this.constructor.CURRENT_INFOWINDOW.close();
      }
      this.marker.panTo();
      if (this.infowindow == null) {
        this.infowindow = this.create_infowindow();
      }
      if (this.infowindow == null) {
        return;
      }
      this.infowindow.open(
        this.getServiceObject().getMap(),
        this.getServiceObject()
      );
      if ((e = this.marker).infowindow == null) {
        e.infowindow = this.infowindow;
      }
      return (this.constructor.CURRENT_INFOWINDOW = this.infowindow);
    };
    r.prototype._get_picture = function(e) {
      if (!_.isObject(this.args[e]) || !_.isString(this.args[e].url)) {
        return null;
      }
      return this._create_or_retrieve_image(this._picture_args(e));
    };
    r.prototype._create_or_retrieve_image = function(e) {
      if (this.constructor.CACHE_STORE[e.url] === void 0) {
        this.constructor.CACHE_STORE[
          e.url
        ] = new (this.primitives().markerImage)(
          e.url,
          e.size,
          e.origin,
          e.anchor,
          e.scaledSize
        );
      }
      return this.constructor.CACHE_STORE[e.url];
    };
    r.prototype._picture_args = function(e) {
      return {
        url: this.args[e].url,
        anchor: this._createImageAnchorPosition(this.args[e].anchor),
        size: new (this.primitives().size)(
          this.args[e].width,
          this.args[e].height
        ),
        scaledSize: null,
        origin: null
      };
    };
    r.prototype._createImageAnchorPosition = function(e) {
      if (!_.isArray(e)) {
        return null;
      }
      return new (this.primitives().point)(e[0], e[1]);
    };
    r.prototype._should_close_infowindow = function() {
      return (
        this.internal_options.singleInfowindow &&
        this.constructor.CURRENT_INFOWINDOW != null
      );
    };
    r.prototype._randomized_coordinates = function() {
      var e, t, n, r, i;
      if (!_.isNumber(this.internal_options.maxRandomDistance)) {
        return [this.args.lat, this.args.lng];
      }
      i = function() {
        return Math.random() * 2 - 1;
      };
      n = this.internal_options.maxRandomDistance * i();
      r = this.internal_options.maxRandomDistance * i();
      e = parseFloat(this.args.lat) + (180 / Math.PI) * (r / 6378137);
      t =
        parseFloat(this.args.lng) +
        ((90 / Math.PI) * (n / 6378137)) / Math.cos(this.args.lat);
      return [e, t];
    };
    return r;
  })(Gmaps.Objects.BaseBuilder);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Builders.Polygon = (function(e) {
    function n(e, t) {
      this.args = e;
      this.provider_options = t != null ? t : {};
      this.before_init();
      this.serviceObject = this.create_polygon();
      this.after_init();
    }
    t(n, e);
    n.prototype.create_polygon = function() {
      return new (this.primitives().polygon)(this.polygon_options());
    };
    n.prototype.polygon_options = function() {
      var e;
      e = { path: this._build_path() };
      return _.defaults(e, this.provider_options);
    };
    n.prototype._build_path = function() {
      var e = this;
      return _.map(this.args, function(t) {
        return new (e.primitives().latLng)(t.lat, t.lng);
      });
    };
    return n;
  })(Gmaps.Objects.BaseBuilder);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Builders.Polyline = (function(e) {
    function n(e, t) {
      this.args = e;
      this.provider_options = t != null ? t : {};
      this.before_init();
      this.serviceObject = this.create_polyline();
      this.after_init();
    }
    t(n, e);
    n.prototype.create_polyline = function() {
      return new (this.primitives().polyline)(this.polyline_options());
    };
    n.prototype.polyline_options = function() {
      var e;
      e = { path: this._build_path() };
      return _.defaults(e, this.provider_options);
    };
    n.prototype._build_path = function() {
      var e = this;
      return _.map(this.args, function(t) {
        return new (e.primitives().latLng)(t.lat, t.lng);
      });
    };
    return n;
  })(Gmaps.Objects.BaseBuilder);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Objects.Bound = (function(e) {
    function n(e) {
      this.serviceObject = e;
    }
    t(n, e);
    n.include(Gmaps.Google.Objects.Common);
    n.prototype.extendWith = function(e) {
      var t,
        n = this;
      t = _.isArray(e) ? e : [e];
      return _.each(t, function(e) {
        return e.updateBounds(n);
      });
    };
    n.prototype.extend = function(e) {
      return this.getServiceObject().extend(
        this.primitives().latLngFromPosition(e)
      );
    };
    return n;
  })(Gmaps.Base);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Objects.Circle = (function(e) {
    function n(e) {
      this.serviceObject = e;
    }
    t(n, e);
    n.include(Gmaps.Google.Objects.Common);
    n.prototype.updateBounds = function(e) {
      e.extend(
        this.getServiceObject()
          .getBounds()
          .getNorthEast()
      );
      return e.extend(
        this.getServiceObject()
          .getBounds()
          .getSouthWest()
      );
    };
    return n;
  })(Gmaps.Base);
}.call(this));
(function() {
  this.Gmaps.Google.Objects.Clusterer = (function() {
    function e(e) {
      this.serviceObject = e;
    }
    e.prototype.addMarkers = function(e) {
      var t = this;
      return _.each(e, function(e) {
        return t.addMarker(e);
      });
    };
    e.prototype.addMarker = function(e) {
      return this.getServiceObject().addMarker(e.getServiceObject());
    };
    e.prototype.clear = function() {
      return this.getServiceObject().clearMarkers();
    };
    e.prototype.removeMarker = function(e) {
      return this.getServiceObject().removeMarker(e.getServiceObject());
    };
    e.prototype.getServiceObject = function() {
      return this.serviceObject;
    };
    return e;
  })();
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Objects.Kml = (function(e) {
    function n(e) {
      this.serviceObject = e;
    }
    t(n, e);
    n.prototype.updateBounds = function(e) {};
    n.prototype.setMap = function(e) {
      return this.getServiceObject().setMap(e);
    };
    n.prototype.getServiceObject = function() {
      return this.serviceObject;
    };
    n.prototype.primitives = function() {
      return this.constructor.PRIMITIVES;
    };
    return n;
  })(Gmaps.Base);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Objects.Map = (function(e) {
    function n(e) {
      this.serviceObject = e;
    }
    t(n, e);
    n.prototype.getServiceObject = function() {
      return this.serviceObject;
    };
    n.prototype.centerOn = function(e) {
      return this.getServiceObject().setCenter(
        this.primitives().latLngFromPosition(e)
      );
    };
    n.prototype.fitToBounds = function(e) {
      if (!e.isEmpty()) {
        return this.getServiceObject().fitBounds(e);
      }
    };
    n.prototype.primitives = function() {
      return this.constructor.PRIMITIVES;
    };
    return n;
  })(Gmaps.Base);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Objects.Marker = (function(e) {
    function n(e) {
      this.serviceObject = e;
    }
    t(n, e);
    n.include(Gmaps.Google.Objects.Common);
    n.prototype.updateBounds = function(e) {
      return e.extend(this.getServiceObject().position);
    };
    n.prototype.panTo = function() {
      return this.getServiceObject()
        .getMap()
        .panTo(this.getServiceObject().getPosition());
    };
    return n;
  })(Gmaps.Base);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Objects.Polygon = (function(e) {
    function n(e) {
      this.serviceObject = e;
    }
    t(n, e);
    n.include(Gmaps.Google.Objects.Common);
    n.prototype.updateBounds = function(e) {
      var t, n, r, i, s;
      i = this.serviceObject.getPath().getArray();
      s = [];
      for (n = 0, r = i.length; n < r; n++) {
        t = i[n];
        s.push(e.extend(t));
      }
      return s;
    };
    return n;
  })(Gmaps.Base);
}.call(this));
(function() {
  var e = {}.hasOwnProperty,
    t = function(t, n) {
      function i() {
        this.constructor = t;
      }
      for (var r in n) {
        if (e.call(n, r)) t[r] = n[r];
      }
      i.prototype = n.prototype;
      t.prototype = new i();
      t.__super__ = n.prototype;
      return t;
    };
  this.Gmaps.Google.Objects.Polyline = (function(e) {
    function n(e) {
      this.serviceObject = e;
    }
    t(n, e);
    n.include(Gmaps.Google.Objects.Common);
    n.prototype.updateBounds = function(e) {
      var t, n, r, i, s;
      i = this.serviceObject.getPath().getArray();
      s = [];
      for (n = 0, r = i.length; n < r; n++) {
        t = i[n];
        s.push(e.extend(t));
      }
      return s;
    };
    return n;
  })(Gmaps.Base);
}.call(this));
(function() {
  this.Gmaps.Google.Primitives = function() {
    var e;
    e = {
      point: google.maps.Point,
      size: google.maps.Size,
      circle: google.maps.Circle,
      latLng: google.maps.LatLng,
      latLngBounds: google.maps.LatLngBounds,
      map: google.maps.Map,
      mapTypez: google.maps.MapTypeId,
      markerImage: google.maps.MarkerImage,
      marker: google.maps.Marker,
      infowindow: google.maps.InfoWindow,
      listener: google.maps.event.addListener,
      clusterer: MarkerClusterer,
      listenerOnce: google.maps.event.addListenerOnce,
      polyline: google.maps.Polyline,
      polygon: google.maps.Polygon,
      kml: google.maps.KmlLayer,
      addListener: function(t, n, r) {
        return e.listener(t, n, r);
      },
      addListenerOnce: function(t, n, r) {
        return e.listenerOnce(t, n, r);
      },
      mapTypes: function(t) {
        return e.mapTypez[t];
      },
      latLngFromPosition: function(t) {
        if (_.isArray(t)) {
          return new e.latLng(t[0], t[1]);
        } else {
          if (_.isNumber(t.lat) && _.isNumber(t.lng)) {
            return new e.latLng(t.lat, t.lng);
          } else {
            if (_.isFunction(t.getServiceObject)) {
              return t.getServiceObject().getPosition();
            } else {
              return t;
            }
          }
        }
      }
    };
    return e;
  };
}.call(this));
