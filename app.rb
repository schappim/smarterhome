#!/usr/bin/env ruby

require 'rubygems'
require 'wiringpi'
require 'sinatra'
require 'json'

set :bind, '0.0.0.0'
set :port, 80

# Creating a new GPIO objcet
gpio = WiringPi::GPIO.new

# name the pins, for easier reference:
button = 4
led = 1

# initialize the pin functions:
gpio.mode button, INPUT
gpio.mode led, OUTPUT

temp_sensor_id = "28-001412927aff"

# turn off the led, just in case:
gpio.write led, 0

get '/' do
	erb :index
end


get '/camera' do
  `raspistill -w 640 -h 480 -t 50 -o ./public/image.jpg`
  erb :camera
end

get '/switch' do
	erb :switch
end

get '/button' do
	erb :button
end

post '/button' do
  state = gpio.readAll;
  "#{state.to_json}"
end

get '/switch/on' do
	gpio.write led, 1
	erb :switch
end

get '/switch/off' do
	 gpio.write led, 0
	erb :switch
end

post "/temp" do
  string = `cat /sys/bus/w1/devices/#{temp_sensor_id}/w1_slave`
  temp_value =  string.split('=').last.to_f / 1000
  hash = {}
  hash["temp"] = temp_value
  "#{hash.to_json}"
end