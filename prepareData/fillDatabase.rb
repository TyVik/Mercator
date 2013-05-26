#!/usr/bin/env ruby

require 'rexml/document'
require './gmap.rb'
require 'pg'
include REXML

$encoder = GMapPolylineEncoder.new()
xmlfile = File.new("countries_world.xml")
xmldoc = Document.new(xmlfile)

$connection = PG::Connection.new( :host => '127.0.0.1', :port => 5432,
    :dbname => 'mercator', :user => 'mercator', :password => 'mercator')
$connection.prepare('stm', 'INSERT INTO "Countries"("Name", "Polygon") values ($1, ARRAY[$2])')

def processPolygon(str)
    coordinates = str.split
    data = []
    coordinates.each {
      |coord|
        arr = coord.split ","
        data.push([arr[1].to_f, arr[0].to_f])
    }
    return $encoder.encode(data)
end

def getPolygons(node)
    polygons = node.elements["MultiGeometry"]
    result = []
    polygons.each_element('Polygon/outerBoundaryIs/LinearRing/coordinates') {
      |polygon|
        result = result + [processPolygon(polygon.text)[:points]]
    }
    return result
end

def saveCountry(name, polygon)
  puts polygon.class
  $connection.exec_prepared('stm', [name, polygon])
end

# for each country
xmldoc.elements.each("kml/Document/Placemark"){
  |e|
    name = e.elements["name"].text
    puts "Processing " + name
    gmapPolygon = getPolygons(e)
    saveCountry(name, gmapPolygon)
}
