if (!google.maps.Polygon.prototype.polygon) {
    google.maps.Polygon.prototype.polygon = "";
}

if (!google.maps.Polygon.prototype.answer) {
    google.maps.Polygon.prototype.answer = "";
}

if (!google.maps.Polygon.prototype.pathStringsToArray) {
    google.maps.Polygon.prototype.pathStringsToArray = function(paths) {
        var result = [];
        for (var i = 0; i < paths.length; i++) {
            result.push(google.maps.geometry.encoding.decodePath(paths[i]));
        }
        return result;
    }
}

if (!google.maps.Polygon.prototype.boundsContains) {
    google.maps.Polygon.prototype.boundsContains = function() {
        var paths = this.getPaths().getArray();
        for (var i = 0; i < paths.length; i++) {
            var p = paths[i].getArray();
            for (var j = 0; j < p.length; j++) {
                if (!this.answer.contains(p[j])) {
                    return false;
                }
            }
        }
        return true;
    }
}

if (!google.maps.Polygon.prototype.replacePiece) {
    google.maps.Polygon.prototype.replacePiece = function() {
        var options = {
            strokeColor: '#00FF00',
            fillColor: '#00FF00',
            draggable: false,
            zIndex: 1,
        };
        options.paths = this.pathStringsToArray(this.polygon);
        this.setOptions(options);
    }
}

function Country(polygon, answer) {
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
    this.map = new google.maps.Polygon(options);
    this.map.polygon = polygon;
    this.map.answer = answer;
    this.map.setPaths(this.map.pathStringsToArray(this.map.polygon));
    google.maps.event.addListener(this.map, 'dragend', function() {
        if (this.boundsContains()) {
            this.replacePiece();
        }
    });

    this.shuffle = function() {
        this.map.moveTo(new google.maps.LatLng(25, -25));
    }

    return this;
}
