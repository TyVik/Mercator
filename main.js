var map;
var polys = [];

function addPoly(id, start, answer) {
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
  var paths = [];
  for (var i = 0; i < start.length; i++) {
    paths.push(google.maps.geometry.encoding.decodePath(start[i]));
  }
  options.paths = paths;

  var poly = new google.maps.Polygon(options);
  google.maps.event.addListener(poly, 'dragend', function() {
    if (boundsContains(answer, poly)) {
      replacePiece(poly, paths);
    }
  });
  poly.moveTo(new google.maps.LatLng(25, -25));
  polys.push(poly);
}

function replacePiece(poly, paths) {
  var options = {
    strokeColor: '#00FF00',
    fillColor: '#00FF00',
    draggable: false,
    zIndex: 1,
    path: paths,
  };
  poly.setOptions(options);
}

function boundsContains(bounds, poly) {
  var paths = poly.getPaths().getArray();
  for (var i = 0; i < paths.length; i++) {
    var p = paths[i].getArray();
    for (var j = 0; j < p.length; j++) {
      if (!bounds.contains(p[j])) {
        return false;
      }
    }
  }
  return true;
}

function addCountries() {
  for (var i = countries.length - 1; i >= 0; i--) {
    addPoly(i, countries[i], answers[i]);
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
