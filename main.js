var map;
var polys = [];

function pathStringsToArray(paths) {
  var result = [];
  for (var i = 0; i < paths.length; i++) {
    result.push(google.maps.geometry.encoding.decodePath(paths[i]));
  }
  return result;
}

function replacePiece(poly) {
var options = {
    strokeColor: '#00FF00',
    fillColor: '#00FF00',
    draggable: false,
    zIndex: 1,
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillOpacity: 0.35,
    geodesic: true,
    map: map,
  };
  options.paths = pathStringsToArray(countries[poly.index]);
  poly.setOptions(options);
}

function boundsContains(poly) {
  var paths = poly.getPaths().getArray();
  for (var i = 0; i < paths.length; i++) {
    var p = paths[i].getArray();
    for (var j = 0; j < p.length; j++) {
      if (!answers[poly.index].contains(p[j])) {
        return false;
      }
    }
  }
  return true;
}

function addCountries() {
  var options = {
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      geodesic: true,
      map: map,
      draggable: true,
      zIndex: 2,
    };
  for (var i = countries.length - 1; i >= 0; i--) {
    options.paths = pathStringsToArray(countries[i]);

    var poly = new google.maps.Polygon(options);
    poly.index = i;
    google.maps.event.addListener(poly, 'dragend', function() {
      if (boundsContains(this)) {
        replacePiece(this);
      }
    });
    poly.moveTo(new google.maps.LatLng(25, -25));
    polys.push(poly);
  };
}

function initialize() {
  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 2,
    center: new google.maps.LatLng(40, -20),
    mapTypeId: google.maps.MapTypeId.TERRAIN
  });
  addCountries();
}

google.maps.event.addDomListener(window, 'load', initialize);
