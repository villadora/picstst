require 'sinatra/base'
require 'restclient'
require 'jsonpath'

require './config'
require './lib/ext'

module Cfg
    def self.jenkins
        {
            :vals => {
                :label => 'text:build', :val=> lambda do |data|
                    case JsonPath.new('$.color').first(data)
                    when /^blue$/
                        return "success"
                    when /^red$/
                        return 'failure'
                    when /^.*anime$/
                        return 'building'
                    when /^disabled$/
                        return 'disabled'
                    when /^aborted$/
                        return 'aborted'
                    when /^yellow$/
                        return 'unstable'
                    when /^grey$/
                        return 'disabled'
                    end
                end,
                :frmt_val=> lambda do |data|
                    case JsonPath.new('$.color').first(data)
                    when /^blue$/
                        return 'success'
                    when /^red$/
                        return '#failure'
                    when /^.*anime$/
                        return 'building'
                    when /^disabled$/
                        return 'disabled'
                    when /^aborted$/
                        return 'aborted'
                    when /^yellow$/
                        return 'unstable'
                    when /^grey$/
                        return 'disabled'
                    end
                end,
                :color => lambda do |data| 
                    case JsonPath.new('$.color').first(data)
                    when /^blue$/
                        return '#319C0B'
                    when /^red$/
                        return '#FA1807'
                    when /^.*anime$/
                        return '#FA8107'
                    when /^disabled$/
                        return '#4D4D4D'
                    when /^aborted$/
                        return '#005EFF'
                    when /^yellow$/
                        return '#FFC400'
                    when /^grey$/
                        return '#4D4D4D'
                    end
                end
            }
        }
    end
end

module Sinatra
    module Jenkins
        # include Extension
        
        def self.registered(app)

            app.get "/jenkins/:env/:job.png" do |env, job|
                content_type  "image/#{Cfg.image_format}"
                data = RestClient.get("http://#{env}.ci.dp/job/#{job}/api/json").to_str
                rs = {}
                Cfg.jenkins[:vals].each do |key, val|
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

    register Jenkins
end
