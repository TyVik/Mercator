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
$connection.prepare('stm', 'INSERT INTO "Countries"("Name", "Polygon", "Answer") values ($1, ARRAY[$2], $3)')

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

# get south-west and north-east rectangle for answer
def getAnswer(node)
    s = nil
    w = nil
    n = nil
    e = nil
    init = false
    polygons = node.elements["MultiGeometry"]
    polygons.each_element('Polygon/outerBoundaryIs/LinearRing/coordinates') {
      |polygon|
        coordinates = polygon.text.split
        coordinates.each {
          |coord|
            arr = coord.split ","
            if (!init)
               s = arr[1].to_f
               w = arr[0].to_f
               n = s
               e = w
               init = true
             else
               if s > arr[1].to_f
                 s = arr[1].to_f
               end
               if n < arr[1].to_f
                 n = arr[1].to_f
               end
               if w > arr[0].to_f
                 w = arr[0].to_f
               end
               if e < arr[0].to_f
                 e = arr[0].to_f
               end
             end
        }
    }
    # give a human a chance to get into the square
    s = (s-1).round(4)
    w = (w-1).round(4)
    n = (n+1).round(4)
    e = (e+1).round(4)
    return "{#{s}, #{w},#{n},#{e}}"
end

# for each country
xmldoc.elements.each("kml/Document/Placemark"){
  |e|
    name = e.elements["name"].text
    puts "Processing " + name
    gmapPolygon = getPolygons(e)
    answer = getAnswer(e)
    $connection.exec_prepared('stm', [name, gmapPolygon, answer])
}
