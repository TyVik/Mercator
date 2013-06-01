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
