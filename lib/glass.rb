module Glass
  mattr_accessor :han_dle_bars_directory
  @@han_dle_bars_directory = ""
  mattr_accessor :han_dle_bars_extension
  @@han_dle_bars_extension = "*.han"
  
  def self.setup
    yield self
  end
end