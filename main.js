var map;

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
    var country = new google.maps.Polygon(options);
    country.polygon = countries[i];
    country.answer = answers[i];
    country.setPaths(country.pathStringsToArray(country.polygon));
    google.maps.event.addListener(country, 'dragend', function() {
        if (this.boundsContains()) {
            this.replacePiece();
        }
    });
    country.moveTo(new google.maps.LatLng(25, -25));
    country = null;
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
