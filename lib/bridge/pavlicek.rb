module Bridge
  ##
  # See http://www.rpbridge.net/7z68.htm
  class Pavlicek
    attr_accessor :possible_deal_count
    # (52!/(13!)^4); important to / below giving non-rounded results
    BRIDGE_DEAL_COUNT = 53_644_737_765_488_792_839_237_440_000

    def initialize(hand_lengths = { n: 13, e: 13, w: 13, s: 13 }, ordering = Card.all)
      # non-side-affected variables
      @hand_lengths = hand_lengths
      @ordering = ordering
      @total_cards = hand_lengths.values.reduce(0) { |sum, length| sum + length }
      @possible_deal_count = calculate_deal_count
    end

    def hands_for_bridge_deal_number(deal_number)
      # side-affected variables
      initialize_scratch_variables deal_number

      enum = @ordering.each
      to_return = {}
      @slots_left_per_hand.keys.each { |direction| to_return[direction] = [] }
      while @cards_left_to_deal > 0
        to_return[hand_key_for_next_card] << enum.next
      end
      to_return
    end

    def initialize_scratch_variables(deal_number)
      @slots_left_per_hand = @hand_lengths.clone
      @cards_left_to_deal = @total_cards # C
      @deal_count_in_remaining_subdomain = @possible_deal_count # K
      @deal_index_within_remaining_subdomain = deal_number # I
      @deal_count_remaining_if_card_dealt = nil # X
    end

    private

    def hand_key_for_next_card
      @slots_left_per_hand.keys.sort.each do |direction|
        @deal_count_remaining_if_card_dealt = @deal_count_in_remaining_subdomain *
                                              @slots_left_per_hand[direction] / @cards_left_to_deal # X = K * <dir> / C
        if @deal_index_within_remaining_subdomain < @deal_count_remaining_if_card_dealt # if I < X
          @slots_left_per_hand[direction] -= 1 # <dir> = <dir> - 1
          @deal_count_in_remaining_subdomain = @deal_count_remaining_if_card_dealt # K = X
          @cards_left_to_deal -= 1 # C = C - 1
          return direction
        else
          @deal_index_within_remaining_subdomain -= @deal_count_remaining_if_card_dealt # I = I - X
        end
      end
    end

    def calculate_deal_count
      product = factorial @total_cards
      @hand_lengths.each_value { |hand_length| product /= factorial hand_length }
      product
    end

    def factorial(n)
      product = 1
      n.times { |i| product *= (i + 1) }
      product
    end
  end
end
