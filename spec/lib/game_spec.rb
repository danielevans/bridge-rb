require 'spec_helper'


RSpec.describe Bridge::Game do
  subject(:game) { described_class.random }
  describe ".random" do
    it 'has four members' do
      expect(game.length).to eq(4);
    end
    context 'with each player' do
      it 'has 13 out of 52 all distinct cards' do
        cards_seen = Set.new
        game.each do |player|
          total_cards = Bridge::Strain::suits.reduce(0) { |sum, suit| sum + player.hand.length(suit) }
          expect(total_cards).to eq 13
          player.hand.cards_by_suit.each_value do |card|
            expect(cards_seen.include? card).not_to eq true
            cards_seen.add(card)
          end
        end
      end
    end
  end

end
