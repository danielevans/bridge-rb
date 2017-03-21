module Bridge
  class Card < Struct.new(:rank, :suit)
    include Comparable

    def <=> other
      # note this ordering is not consistent with equals: <=> may return 0 when eq returns false
      rank <=> other.rank
    end

    @all = []

    Strain.suits.each do |suit|
      Rank.all.each do |rank|
        @all << new(rank, suit).freeze
      end
    end

    @all.freeze

    def self.for suits: nil, ranks: nil
      @all.select do |card|
        (suits.nil? || suits.include?(card.suit)) && (ranks.nil? || ranks.include?(card.rank))
      end
    end

    def self.specifically_for suit:, rank:
      self.for(suits: [suit], ranks: [rank])[0]
    end

    def self.all
      @all
    end

    def self.shuffled
      @all.shuffle
    end

    def self.deal
      shuffled.each_slice(13)
    end
  end
end
