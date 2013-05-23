require 'sinatra/base'
require 'restclient'
require 'jsonpath'

require './config'
require './lib/ext'

module Cfg
    # Sonar Settings
    def self.sonar 
        {
            :url => "http://sonar.dianpingoa.com",
            :vals => {:label=>:metric, :val=>'jsonpath:$[0].msr[0].val',:frmt_val=>'jsonpath:$[0].msr[0].frmt_val', :color=> lambda do |data| 
                    val = JsonPath.new('$[0].msr[0].val').first(data)
                    unless val.nil?
                        if val > 85.0
                            return '#00DB07'
                        elsif val > 60.0
                            return '#FFA719'
                        elsif val > 30
                            return '#002E91'
                        else
                            return '#6C00BF'
                        end
                    end
                end
            }
        }
    end
end


module Sinatra
    module Sonar
        # include Extension

        # register plugin to Sinatra
        def self.registered(app)

            # Handle Get request for image
            app.get "/sonar/:resource/:metric.#{Cfg.image_format}" do |resource, metric|
                content_type  "image/#{Cfg.image_format}"
                data = RestClient.get("#{Cfg.sonar[:url]}/api/resources", {:params => {:resource=>resource, :metrics=>metric, :format=>'json'}}).to_str
                rs = {}
                Cfg.sonar[:vals].each do |key, val|
                    if val.is_a? Proc # a lambda
                        rs[key] = val.call(data)
                    elsif val.is_a? Symbol
                        rs[key] = params[val]
                    elsif val.is_a? String
                        if /^text:.*/ =~ val
                            rs[key] = /^text:(.*)/.match(val)[1]
                        elsif /^jsonpath:.*/ =~ val
                            val = /^jsonpath:(.*)/.match(val)[1]
                            rs[key] = JsonPath.new(val).first(data)
                        end
                    end
                end

                Extension.info2Img(rs).to_blob
            end
        end
    end
    
    register Sonar
end
