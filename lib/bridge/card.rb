module Bridge
  class Card < Struct.new(:rank, :suit)
    include Comparable

    def <=> other
      return rank <=> other.rank unless rank == other.rank
      suit <=> other.suit
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
        (suits.nil? || Array(suits).include?(card.suit)) && (ranks.nil? || Array(ranks).include?(card.rank))
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
      Pavlicek.new.hands_for_bridge_deal_number(rand(Pavlicek::BRIDGE_DEAL_COUNT)).values
    end

    # Inspired by jvenezia http://stackoverflow.com/questions/1931604/whats-the-right-way-to-implement-equality-in-ruby
    def ==(other)
      other.class == self.class && other.state == self.state
    end

    def state
      self.members.map { |member| self.send(member) }
    end
  end
end
