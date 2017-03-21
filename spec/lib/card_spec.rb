require 'spec_helper'

module Bridge
  RSpec.describe Card do
    subject(:card) { Card.new }
    describe ".all" do
      it "returns 52 cards" do
        expect(Card.all.length).to eq(52)
      end
    end
    context "with two aces of differing suits" do
      let(:ace_of_hearts) { Card.specifically_for(suit: Strain::Heart, rank: Rank::Ace) }
      let(:ace_of_spades) { Card.specifically_for(suit: Strain::Spade, rank: Rank::Ace) }
      describe "==" do
        it "includes suit in card equality" do
          expect(ace_of_spades).not_to eq ace_of_hearts
        end
      end
      describe "<=>" do
        it "provides a natural ordering that is consistent with equals" do
          expect(ace_of_spades <=> ace_of_hearts).not_to eq 0
          expect(ace_of_spades <=> ace_of_spades).to eq 0
        end
      end
    end
  end
end
