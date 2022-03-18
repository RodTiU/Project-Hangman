class FormatColor
  require "rainbow"

  def self.color(word, color)
    Rainbow(word.to_s).color(color.to_sym)
  end

  def self.underline(word)
    Rainbow(word).underline
  end
end
