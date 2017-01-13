

module Bridge
  class Hand
    attr_reader :cards
    attr_reader :played

    def initialize cards
      raise ArgumentError unless cards && cards.length == 13
      @cards = cards.freeze
    end

    def high_card_points
      @high_card_points ||= begin
                              by_rank = cards.group_by(&:rank)
                              Array(by_rank[Rank::Ace]).length * 4 +
                                Array(by_rank[Rank::King]).length * 3 +
                                Array(by_rank[Rank::Queen]).length * 2 +
                                Array(by_rank[Rank::Jack]).length
                            end
    end

    def play card
      @played ||= []
      fail ArgumentError, "hand cannot play a card it does not have" unless cards.include? card
      fail ArgumentError, "hand cannot play a card it has already played" if @played.include? card
      @played << card
    end

    def remaining
      cards - Array(played)
    end

    def long_points
      @long_points ||= begin
                         by_suit = cards.group_by(&:suit)
                         by_suit.values.reduce(0) do |memo,suit|
                           memo + [suit.length - 4, 0].max
                         end
                       end
    end

    def short_points trump=nil
      by_suit = cards.group_by(&:suit)

      Strain.suits.reduce(0) do |memo, suit|
        if suit == trump # don't count short in trump
          memo
        else
          memo + Hash.new(0).merge({ 0 => 5, 1 => 3, 2 => 1 })[Array(by_suit[suit]).length]
        end
      end
    end
  end
end
