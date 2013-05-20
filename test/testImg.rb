
require './lib/img'
require 'test/unit'

include Img

class TestImg < Test::Unit::TestCase
    def setup
    end

    def test_img_init
        img = GradientImage.new({:text=>'label', :width=>30, :height=>10, :gradient=>:red})
        assert_equal img.text, 'label'
        assert_equal img.color, 'white'


        assert_equal img.get_image.is_a?(Image), true
    end


    def test_imgList
        list = LabeledImage.new({:text=>'coverage:', :width=>40, :height=>20, :gradient=>:grey},
                                {:text=>'44.5%', :width=>40, :height=>20, :gradient=>:red});
        assert_equal list.get_image.is_a?(Image), true
    end
end
