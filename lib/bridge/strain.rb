module Bridge
  class Strain < Struct.new(:order, :key)
    include Comparable

    def <=> other
      order <=> other&.order
    end

    def to_s
      key.to_s
    end


    Club    = new(0, :club     ).freeze
    Diamond = new(1, :diamond  ).freeze
    Heart   = new(2, :heart    ).freeze
    Spade   = new(3, :spade    ).freeze
    NoTrump = new(4, :no_trump ).freeze

    @all = [Club,Diamond,Heart,Spade,NoTrump].sort.freeze
    @suits = (@all - [NoTrump]).freeze

    def self.all
      @all
    end

    def self.suits # suits that can be used on cards
      @suits
    end

    def self.majors
      [Heart, Spade]
    end

    def self.minors
      [Club, Diamond]
    end

    @mapping = {}
    %w(Clubs Diamonds Hearts Spades NoTrumps
       Club  Diamond  Heart  Spade  NoTrump
       C     D        H      S      NT).each_with_index do |key, index|
      @mapping[key.to_sym] = all[index % 5]
      @mapping[key.downcase.to_sym] = all[index % 5]
      @mapping[key.upcase.to_sym] = all[index % 5]
    end
    %i(Nt nT Notrump Notrumps).each { |symbol| @mapping[symbol] = NoTrump}

    def self.for_symbol(symbol)
      return @mapping[symbol] if @mapping.has_key?(symbol)
      raise ArgumentError.new("Unrecognized strain symbol `#{symbol}'; permitted values are: #{@mapping.keys}")
    end

    def initialize(*args)
      raise NoMethodError, "Cannot initialize a new suit"
    end
  end
end
