require 'RMagick'
require './lib/color'

include Magick

module Img
    
    class LabeledImage
        attr_accessor :label, :value

        def initialize(label, value)
            @label = label
            @value = value
            puts @label, @value
        end
        
        def get_image(format='png')
            imgList = ImageList.new
            imgList << GradientImage.new(@label).get_image(format)
            imgList << GradientImage.new(@value).get_image(format)

            # Calculate height
            maxHeight = 0
            imgList.each do |img|
                maxHeight = img.rows if img.rows > maxHeight
            end

            # Rebase the images' height
            imgList.map! do |img|
                img.resize(img.columns, maxHeight)
            end
            
            # Merge horizontal
            img = imgList.append false
            img.format = format

            return img
        end
    end

    class GradientImage
        attr_accessor :text, :color, :font_size, :padding, :bg_rate

        def initialize args
            # If args is hash
            if args.is_a?(Hash)
                args.each do |k,v|
                    instance_variable_set("@#{k}", v) unless v.nil?
                end
            end

            @font_size = @font_size || 12
            @color = @color || '#4a4a4a'
            @padding = @padding || 4
            @bg_rate= @bg_rate || 1.2
        end


        def get_image(format='png')
            # Draw text
            draw = Magick::Draw.new
            draw.font_family = "verdana"
            draw.font_weight = 700
            draw.pointsize = @font_size
            draw.gravity = Magick::CenterGravity
            draw.fill = Color.contrast @color

            # Calculate width&height
            metrics = draw.get_type_metrics(@text)
            width = metrics.width + 2*@padding # this one is ok by default
            height = (metrics.bounds.y2 - metrics.bounds.y1).round + 2*@padding # this is the actual height

            # Draw background
            gradient = GradientFill.new(0,0,width,0, Color.luminance(@color, @bg_rate), @color)

            img = Image.new(width, height, gradient)
            img.format = format
            
            # draw text
            draw.annotate(img, width, height,0, 0, @text)
            return img
        end
    end
end
