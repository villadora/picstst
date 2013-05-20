require './picsts'
require 'test/unit'
require 'rack/test'

class MyAppTest < Test::Unit::TestCase
    include Rack::Test::Methods

    def app
        Sinatra::Application
    end

    def test_my_default
        get '/'
        assert_equal  "this is a image service to collecte projects' status", last_response.body
    end

    def test_coverage
        get '/com.dianping:map/coverage.png'
    end
    
end
