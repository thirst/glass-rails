module Glass
  mattr_accessor :han_dle_bars_directory
  @@han_dle_bars_directory = ""
  def self.setup
    yield self
  end
end