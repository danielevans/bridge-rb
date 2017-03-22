module Bridge
  ##
  # See http://www.rpbridge.net/7z68.htm
  class Pavlicek
    attr_accessor :possible_deal_count
    # (52!/(13!)^4); important to / below giving non-rounded results
    BRIDGE_DEAL_COUNT = 53_644_737_765_488_792_839_237_440_000

    def initialize(hand_lengths = {n: 13, e: 13, w: 13, s: 13}, ordering = Card.all)
      # non-side-affected variables
      @hand_lengths = hand_lengths
      @ordering = ordering
      @total_cards = hand_lengths.values.reduce(0) { |sum, length| sum + length }
      @possible_deal_count = calculate_deal_count
    end

    def hands_for_bridge_deal_number(deal_number)
      validate_deal_number deal_number
      initialize_scratch_variables deal_number

      enum = @ordering.each
      to_return = {}
      @slots_left_per_hand.keys.each { |direction| to_return[direction] = [] }
      while @cards_left_to_deal > 0
        to_return[hand_key_for_next_card] << enum.next
      end
      to_return
    end

    def bridge_deal_number_for_hands(hands)
      validate_hands hands
      to_return = 0
      initialize_scratch_variables to_return

      @ordering.each do |card|
        to_return += count_deals_in_subdomains_prior_to card, hands
      end
      to_return
    end

    private
    def validate_deal_number deal_number
      throw ArgumentError("deal_number > possible_deal_count: #{possible_deal_count}") unless
          deal_number < possible_deal_count
    end

    def validate_hands hands
      @hand_lengths.each_pair do |direction, hand_length|
        throw ArgumentError("wrong suit lengths in hands") unless hands[direction].length == hand_length
      end
    end

    def initialize_scratch_variables(deal_number)
      @slots_left_per_hand = @hand_lengths.clone # N, S, E, W
      @cards_left_to_deal = @total_cards # C
      @deal_count_in_remaining_subdomain = @possible_deal_count # K = D
      @deal_index_within_remaining_subdomain = deal_number # I
      @deal_count_remaining_if_card_dealt = nil # X
    end

    def hand_key_for_next_card
      @slots_left_per_hand.keys.sort do |x, y|
        return x <=> y unless (special_sort_keys.include?(x) && special_sort_keys.include?(y))
        sort_index_of(x) <=> sort_index_of(y)
      end.each do |direction|
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

    def count_deals_in_subdomains_prior_to(card, hands)
      deal_count = 0
      hands.keys.sort do |x, y|
        return x <=> y unless (special_sort_keys.include?(x) && special_sort_keys.include?(y))
        sort_index_of(x) <=> sort_index_of(y)
      end.each do |direction|
        @deal_count_remaining_if_card_dealt = @deal_count_in_remaining_subdomain *
            @slots_left_per_hand[direction] / @cards_left_to_deal # X = K * <dir> / C
        if hands[direction].include?(card)
          @slots_left_per_hand[direction] -= 1
          @deal_count_in_remaining_subdomain = @deal_count_remaining_if_card_dealt
          @cards_left_to_deal -= 1
          return deal_count
        else
          deal_count += @deal_count_remaining_if_card_dealt
        end
      end
      deal_count
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

    def sort_index_of(special_sort_key)
      special_sort_keys.index special_sort_key
    end

    def special_sort_keys
      [:n, :e, :s, :w]
    end

  end
end
