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

    def test_sonar
        get '/sonar/com.dianping:map/coverage.png'
    end

    def test_jenkins
        get '/jenkins/beta/AB-Test-jar.png'
    end
    
end
