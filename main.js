var map;
var polys = [];

function addPoly(id, start) {
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
    paths: [],
  };
  for (var i = 0; i < start.length; i++) {
    options.paths.push(google.maps.geometry.encoding.decodePath(start[i]));
  }

  var poly = new google.maps.Polygon(options);
  poly.moveTo(new google.maps.LatLng(25, -25));
  polys.push(poly);
}

function addCountries() {
  for (var i = countries.length - 1; i >= 0; i--) {
    addPoly(i, countries[i]);
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
