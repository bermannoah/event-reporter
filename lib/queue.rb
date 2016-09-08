require './lib/loader'
require 'rubygems'
require 'terminal-table'
require 'csv'
require 'date'
require 'geocoder'
require 'congress'
require 'pry'

class QueueHolder < Loader
  
  attr_accessor :queue, :api_key, :client, :queue_district, :found_district, :district, :queue_count, :queue_results, :rows, :table, :table_printer
  
  HEADER_ROW = ["LAST NAME", "FIRST NAME", "EMAIL", "ZIPCODE", "CITY", "STATE", "ADDRESS", "PHONE", "DISTRICT"]
  
  def initialize
    @api_key = File.read "./config/api_key.txt"
    @client = Congress::Client.new(@api_key)
    @data = []
    @contents = nil
    @queue_results = []
    @final_table = nil
    @district = district
  end
  
  def all_entries(filename="./event_attendees.csv")
    l = Loader.new
    l.open_file
    @queue_results = l.attendee_collector
  end
  
  def queue_count
    queue_count = @queue_results.count 
  end
    
  def queue_clear
    @queue_results = []
  end
  
  def queue_district(zipcode=queue_results[0].zipcode)
    if @queue_results.count < 10
      found_district = @client.districts_locate(zipcode)[:results][0][:district].to_s
      found_district
      @district = found_district
    else
      "Sorry, too many entries."
    end
  end
  
  def queue_print
    table = Terminal::Table.new 
    table.headings = [HEADER_ROW]
    table.title = "Queue Printout on #{Time.now.strftime("%d/%m/%Y at %H:%M")}"
    if @queue_results.count < 10
      table.align_column(0..8, :left)
      table.rows = @queue_results.map do |row|
        [row.last_name, row.first_name, row.email, row.zipcode, 
          row.city, row.state, row.street_address, row.phone_number, row.district]
      end
      puts table
    else
      table.align_column(0..7, :left)
      table.rows = @queue_results.map do |row|
        [row.last_name, row.first_name, row.email, row.zipcode, 
          row.city, row.state, row.street_address, row.phone_number]
      end
      puts table
    end
  end
  
  
  
  
  
end