require 'minitest/autorun'
require './lib/img'

include Img

class TestImg < MiniTest::Unit::TestCase
    def setup
    end

    def test_img_init
        img = GradientImage.new({:text=>'label', :color=>'#ffcc00'})
        assert_equal img.text, 'label'
        assert_equal img.color, '#ffcc00'
        assert_equal img.get_image.is_a?(Image), true
    end


    def test_imgList
        list = LabeledImage.new({:text=>'coverage:', :color=>'#9d9d9d'},
                                {:text=>'44.5%', :color=>'#cc0000'})
        assert_equal list.get_image.is_a?(Image), true
    end
end
