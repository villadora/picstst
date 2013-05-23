#
# Util Functions for hex color operator
#
module Color
    def Color.validate hex
        hex.strip!
        !(/^#[0-9a-fA-F]{3}$/ =~ hex.strip).nil? || !(/^#[0-9a-fA-F]{6}$/ =~ hex.strip).nil?
    end

    def Color.normalize hex 
        raise "Not valid hex color string" unless Color.validate hex
        hex = '#'+hex[1,1]*2+hex[2,1]*2+hex[3,1]*2 if hex.length == 4
        hex
    end

    def Color.contrast hex
        hex = Color.normalize hex
        val = [hex[1,2].hex, hex[3,2].hex, hex[5,2].hex].inject(0) {|sum,x| sum+x}
        (val > 382.5) ? "#000000":"#ffffff"
    end

    def Color.luminance hex, lum
        lum = lum || 0
        hex = Color.normalize hex
        lumL = lambda {|hx| ([255, [0, (hx.hex*(1+lum)).round].max].min).to_s(16).rjust(2,'0')}
        '#'+ lumL.call(hex[1,2])+lumL.call(hex[3,2])+lumL.call(hex[5,2])
    end
end
