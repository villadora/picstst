require './config'
require './lib/img'

module Extension
    #
    # Get an _info_ hash to an _image_ with label and value
    #
    def self.info2Img(info)
        Img::LabeledImage.new({:text=>info[:label]}, {:text=>info[:frmt_val], :color=>info[:color]}).get_image Cfg.image_format
    end
end
