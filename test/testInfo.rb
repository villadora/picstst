require 'test/unit'
require './lib/info'

include InfoQuery

class TestInfo < Test::Unit::TestCase
    def setup
    end

    def testSonar
        info = SonarInfo.new('http://sonar.dianpingoa.com')
        rs = info.info('com.dianping.swallow:swallow-all', 'coverage')
        assert_equal rs[:label], 'coverage'
        assert_equal rs[:val].is_a?(Float), true
        assert_equal rs[:frmt_val].is_a?(String), true
    end

    def testJenkins
        info = JenkinsInfo.new('http://alpha.ci.dp', 'master')
        rs = info.info('AB-Test')
        assert_equal rs[:label], 'build'
        assert_equal rs[:val], rs[:frmt_val]
    end
    
end



