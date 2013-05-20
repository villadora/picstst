#!/usr/bin/env ruby

require 'sinatra'
require 'rest-client'
require 'RMagick'
require 'fileutils'
require 'json'
require './lib/img'
require './lib/info'

include Magick
include Img
include InfoQuery

LEVEL2COLOR = {:good => :green, :ok => :orange, :bad => :red, :unknown => :grey}

def info2Img(info)
    LabeledImage.new({:text=>info[:label]}, {:text=>info[:frmt_val], :gradient=>LEVEL2COLOR[info[:level]]}).get_image
end


get '/' do
    [200, "this is a image service to collecte projects' status"]
end

get '/:job/:env/build.png' do |job, env|
    content_type  "image/png"
    info2Img(JenkinsInfo.new("http://#{env}.ci.dp").info(job)).to_blob
end

get '/:resource/coverage.png' do |resource|
    content_type  "image/png"

    info2Img(SonarInfo.new('http://sonar.dianpingoa.com').info(resource)).to_blob
end
