require 'RMagick'


include Magick

module Img
    
    class LabeledImage
        attr_accessor :label, :value

        def initialize(label, value)
            @label = label
            @value = value

            @imgList = ImageList.new

            @imgList << GradientImage.new(@label).get_image
            @imgList << GradientImage.new(@value).get_image
        end
        
        def get_image
            maxHeight = 0
            @imgList.each do |img|
                maxHeight = img.rows if img.rows > maxHeight
            end

            @imgList.map! do |img|
                img.resize(img.columns, maxHeight)
            end
            
            img = @imgList.append false
            img.format = 'png'
            img
        end
    end

    class GradientImage
        attr_accessor :text, :width, :height, :gradient, :color, :font_size, :padding

        GRADIENTS = {:grey => ['#CFCFCF','#5E5E5E'],
            :green => ['#00FF26','#00AB1A'],
            :red => ['#FF1414','#B00000'],
            :orange => ['#FFAB36', '#E38400']
        }
        

        def initialize args
            # If args is hash
            if args.is_a?(Hash)
                args.each do |k,v|
                    instance_variable_set("@#{k}", v) unless v.nil?
                end
            end

            @gradient = @gradient || :grey
            @font_size = @font_size || 12
            @color = @color || 'white'
            @padding = @padding || 4
        end


        def get_image
            draw = Magick::Draw.new
            draw.font_family = "helvetica"
            draw.font_weight = 700
            draw.pointsize = @font_size
            draw.gravity = Magick::CenterGravity
            draw.fill = @color

            metrics = draw.get_type_metrics(@text)
            box_width = metrics.width # this one is ok by default
            box_height = (metrics.bounds.y2 - metrics.bounds.y1).round # this is the actual height

            width = @width || box_width + 2*@padding
            height = @height || box_height + 2*@padding
            gradient
            
            unless @gradient.nil?
                gradient = GradientFill.new(0,0,width,0, @gradient[0], @gradient[1]) if @gradient.is_a?(Array)
                gradient = GradientFill.new(0,0,width,0, GRADIENTS[@gradient][0], GRADIENTS[@gradient][1]) if GRADIENTS.has_key? @gradient
            end
            
            img = Image.new(@width || box_width+2*@padding, @height ||  box_height+2*@padding, gradient)
            img.format = 'png'
            
            # draw text
            draw.annotate(img, 0,0,0,0, @text)
            
            img
        end
    end
end
