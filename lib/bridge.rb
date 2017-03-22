module Bridge
  %w{Game Card Strain Rank Hand Player Bid Pavlicek}.each do |c|
    autoload c.to_sym, File.expand_path("../bridge/#{c.downcase}", __FILE__)
  end
end
