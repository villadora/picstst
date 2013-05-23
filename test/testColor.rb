require 'minitest/autorun'
require './lib/color'

class ColorTest < MiniTest::Unit::TestCase

    def test_validate
        assert_equal Color.validate("#ffffff"), true
        assert_equal Color.validate("#fafaFA"), true
        assert_equal Color.validate("#fff"), true

        assert_equal Color.validate("#3f3f3g"), false
        assert_equal Color.validate("#ff"), false
        assert_equal Color.validate("#ffaa"), false
        assert_equal Color.validate("34f4fA"), false
    end

    def test_normalize
        assert_equal Color.normalize("#fae"), "#ffaaee"
        assert_raises RuntimeError do
            Color.normalize "#fada"
        end
    end
    
    def test_contrast 
        white = "#ffffff"
        dark = "#000000"
        assert_equal Color.contrast("#000000"), white
        assert_equal Color.contrast("#43455f"), white
        assert_equal Color.contrast("#ffffff"), dark
    end
    
    def test_luminance
        assert_equal Color.validate(Color.luminance("#ffffff",0.4)), true
        assert_equal Color.luminance("#ffffff",-1.3), "#000000"
        assert_equal Color.luminance("#0a0a0a",44), "#ffffff"
    end
end
