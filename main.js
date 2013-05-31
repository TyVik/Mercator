var map;

function addCountries() {
  for (var i = countries.length - 1; i >= 0; i--) {
    country = Country(countries[i], answers[i]);
    country.shuffle();
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
