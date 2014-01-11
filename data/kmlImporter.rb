#!/usr/bin/env ruby
# coding: utf-8

require 'rexml/document'
require './gmap.rb'
require 'pg'
include REXML

$connection = PG::Connection.new(:host => '127.0.0.1', :port => 5432, :dbname => 'mercator', :user => 'mercator', :password => 'mercator')
$encoder = GMapPolylineEncoder.new()

class KmlWriter
  @fileName     # name of file for import
  @tableName    # name of table for kml
  @name         # name of map for menu
  @center       # center map
  @position     # default regions position
  @zoom         # zoom map
  @precision    # accuracy answer

  def initialize(file)
    @fileName = file
    parts = file.match('^kml\/(?<name>\S+)\.kml$')
    @tableName = "map_#{parts['name']}".downcase # postgres dosn`t like upper case

    puts "Process file %s" % [@fileName]
    puts "Enter name of maps"
    @name = STDIN.gets.chomp
    puts "Enter center (format %f, %f)"
    @center = STDIN.gets.chomp
    puts "Enter default region position (format %f, %f)"
    @position = STDIN.gets.chomp
    puts "Enter zoom"
    @zoom = STDIN.gets.chomp
    puts "Enter precision"
    @precision = STDIN.gets.chomp.to_f
  end

  def run()
    createTable()
    fillTable()
    registerTable()
  rescue RuntimeError => error
    puts "Exception rised while process file %s" % [file]
    puts error.message
    puts error.backtrace
  end

  def createTable()
    $connection.exec('CREATE SEQUENCE "%s_seq"
      INCREMENT 1
      MINVALUE 1
      MAXVALUE 9223372036854775807
      START 1
      CACHE 1;' % [@tableName])
    $connection.exec('CREATE TABLE "%s"(
      "id" integer NOT NULL DEFAULT nextval(\'%s_seq\'),
      "name" character varying(50) NOT NULL,
      "polygon" character varying[],
      "available" boolean,
      "answer" character varying(50),
      CONSTRAINT "%s_id" PRIMARY KEY ("id" )
      ) WITH (
        OIDS=FALSE
      );' % [@tableName, @tableName, @tableName])
  end

  def fillTable()
      def getPolygons(polygons)
          def processPolygon(str)
              coordinates = str.split
              data = []
              coordinates.each do |coord|
                  arr = coord.split ","
                  data.push([arr[1].to_f, arr[0].to_f])
              end
              return $encoder.encode(data)
          end

          result = []
          polygons.elements.each do |polygon|
              result = result + [processPolygon(polygon.text)[:points]]
          end
          return result
      end

      # get south-west and north-east rectangle for answer
      def getAnswer(polygons, precision)
          s = nil
          w = nil
          n = nil
          e = nil
          init = false
          polygons.elements.each do |polygon|
              coordinates = polygon.text.split
              coordinates.each do |coord|
                  arr = coord.split ","
                  if (!init)
                      s = arr[1].to_f
                      w = arr[0].to_f
                      n = s
                      e = w
                      init = true
                  else
                      s = s > arr[1].to_f ? arr[1].to_f : s
                      n = n < arr[1].to_f ? arr[1].to_f : n
                      w = w > arr[0].to_f ? arr[0].to_f : w
                      e = e < arr[0].to_f ? arr[0].to_f : e
                   end
              end
          end
          # give a human a chance to get into the square
          s = (s-precision).round(4)
          w = (w-precision).round(4)
          n = (n+precision).round(4)
          e = (e+precision).round(4)
          return "{#{s},#{w},#{n},#{e}}"
      end

    xmlFile = File.new(@fileName)
    insertStm = 'insertStm_%s' % [@tableName]
    $connection.prepare(insertStm, 'INSERT INTO %s (name, polygon, answer) values ($1, ARRAY[$2], $3)' % [@tableName])
    xmlDoc = Document.new(xmlFile)

    # for each region
    xmlDoc.elements.each("kml/Document/Placemark") do |region|
        name = region.elements["name"].text
        puts "Processing " + name
        polygons = region.elements["MultiGeometry"] ? region.elements["MultiGeometry"] : region
        coordinates = polygons.elements['Polygon/outerBoundaryIs/LinearRing']
        gmapPolygon = getPolygons(coordinates)
        answer = getAnswer(coordinates, @precision)
        $connection.exec_prepared(insertStm, [name, gmapPolygon, answer])
    end

    # activate all regions
    $connection.exec("UPDATE %s set available=True" % [@tableName])
  end

  def registerTable()
    $connection.exec("INSERT INTO maps (table_name, name, center, zoom, default_position) values ('%s', '%s', point(%s), %d, point(%s))" % 
      [@tableName, @name, @center, @zoom, @position])
  end
end


files = ARGV.empty? ? Dir.glob('kml/*.kml') : ARGV
files.each do |file|
  kml = KmlWriter.new(file)
  kml.run()
end
