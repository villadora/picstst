#!/usr/bin/env ruby

require 'sinatra'
require 'rest-client'
require 'RMagick'
require 'fileutils'
require 'json'

require './lib/sonar'
require './lib/jenkins'

enable :logging


get '/' do
    "this is a image service to collecte projects' status"
end
