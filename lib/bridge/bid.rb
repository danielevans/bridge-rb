module Bridge
  class Bid < Struct.new(:level, :strain, :player)
    include Comparable

    def <=> other
      r = strain <=> other.strain
      return r unless r == 0
      return level <=> other.level
    end
  end
end
