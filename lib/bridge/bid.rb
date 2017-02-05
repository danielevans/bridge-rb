module Bridge
  class Bid < Struct.new(:level, :strain)
    include Comparable

    def <=> other
      r = strain <=> other.strain
      return r unless r == 0
      return level <=> other.level
    end

    @all = []

    Strain.all.each do |suit|
      (1..7).each do |level|
        @all << new(level, suit).freeze
      end
    end

    @all.freeze

    def self.all
      @all
    end
  end
end
