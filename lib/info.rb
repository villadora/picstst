require 'rest-client'
require 'json'


module InfoQuery
    class BaseInfo
        def info
        end
    end

    class SonarInfo < BaseInfo
        attr_reader :url
        
        def initialize(url)
            @url = url
            @format = 'json'
        end
        
        def info(resource, metric='coverage')
            rsp = RestClient.get "#{@url}/api/resources", {:params => {:resource=>resource,:metrics=>metric,:format=>@format}}
            msr = JSON.parse(rsp.to_str)[0]["msr"][0]
            val = msr['val']
            frmt_val = msr['frmt_val']

            {:label=>metric, :frmt_val=>frmt_val, :val=>val,
                :level=>(val > 80)? :good : ((val > 35) ? :ok : :bad)}
        end
    end

    class JenkinsInfo < BaseInfo
        attr_reader :url
        COLOR_STATUS_MAPPING = {
            /^blue$/              => 'success',
            /^red$/               => 'failure',
            /.*anime$/            => 'building',
            /^disabled$/          => 'disabled',
            /^aborted$/           => 'aborted',
            /^yellow$/            => 'unstable', #rare
            /^grey$/              => 'disabled'
        }

        STATUS_LEVEL_MAPPING = {
            'success'  => :good,
            'building' => :good,
            'failure'  => :bad,
            'disabled' => :unknown,
            'aborted'  => :orange,
            'unstable' => :orange
        }

        def initialize(url)
            @url = url          
        end
        
        def info(job)           
            rsp = RestClient.get "#{@url}/job/#{job}/api/json"
            obj = JSON.parse(rsp.to_str)

            text = get_status_to(obj['color'])
            {:label=>'build', :frmt_val=>text, :val=>text,
                :level=>STATUS_LEVEL_MAPPING[text]}
        end

        private
            def get_status_to(color)
                result_color_key = COLOR_STATUS_MAPPING.keys.find { | color_regex | color_regex.match(color)}
                raise "This color '#{color}' and its corresponding status hasn't been added to library, pls contact author." if result_color_key.nil?
                COLOR_STATUS_MAPPING[result_color_key]
            end
        end
    end
