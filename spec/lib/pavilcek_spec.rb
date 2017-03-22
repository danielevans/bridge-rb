require 'spec_helper'

module Bridge

  RSpec.describe Bridge::Pavlicek do
    context "with 2 aces" do
      let(:ace_of_spades) { Card.specifically_for(suit: Strain::Spade, rank: Rank::Ace) }
      let(:ace_of_hearts) { Card.specifically_for(suit: Strain::Heart, rank: Rank::Ace) }
      context "with them ordered downard in suit and just N and E hands" do
        let(:pavlicek) do
          described_class.new({e: 1, n: 1},
                              [ace_of_spades, ace_of_hearts])
        end
        describe("#possible_deal_count") do
          it "indicates the number of possible deals is 2" do
            expect(pavlicek.possible_deal_count).to eq 2
          end
        end
        describe("#hands_for_bridge_deal_number") do
          context "for deal number 0" do
            let(:deal) { pavlicek.hands_for_bridge_deal_number(0) }
            context "the hash it returns" do
              it "matches cards from order in NESW order" do
                expect(deal[:n][0]).to eq ace_of_spades
                expect(deal[:e][0]).to eq ace_of_hearts
              end
            end
          end
          context "for deal number 1" do
            let(:deal) { pavlicek.hands_for_bridge_deal_number(1) }
            context "the hash it returns" do
              it "matches cards from order backwards in NESW order" do
                expect(deal[:n][0]).to eq ace_of_hearts
                expect(deal[:e][0]).to eq ace_of_spades
              end
            end
          end
        end
        context "#bridge_deal_number_for_hands" do
          context "for the AS in N and the AH in E" do
            let(:deal) { {n: [ace_of_spades], e: [ace_of_hearts]} }
            it "should return 0" do
              expect(pavlicek.bridge_deal_number_for_hands deal).to eq 0
            end
          end
          context "for the AH in E and the AS in N" do
            let(:deal) { {n: [ace_of_hearts], e: [ace_of_spades]} }
            it "should return 1" do
              expect(pavlicek.bridge_deal_number_for_hands deal).to eq 1
            end
          end
        end
      end

      context "with another ace" do
        let(:ace_of_diamonds) { Card.specifically_for(suit: Strain::Diamond, rank: Rank::Ace) }
        context "ordered downward and with two hands" do
          let(:hand_lengths) { {n: 1, e: 2} }
          let(:pavlicek) do
            described_class.new(hand_lengths,
                                [ace_of_spades, ace_of_hearts, ace_of_diamonds])
          end
          describe "#possible_deal_count" do
            it "indicates the number of possible deals is 3" do
              expect(pavlicek.possible_deal_count).to eq 3
            end
          end
          describe "#bridge_deal_number_for_hands" do
            context "with hand 0" do
              let(:hands) { {n: [ace_of_spades], e: [ace_of_hearts, ace_of_diamonds]} }
              it "returns 0 for the hand" do
                expect(pavlicek.bridge_deal_number_for_hands(hands)).to eq 0
              end
            end
            context "with hand 1" do
              let(:hands) { {n: [ace_of_hearts], e: [ace_of_spades, ace_of_diamonds]} }
              it "returns 1 for the hand" do
                expect(pavlicek.bridge_deal_number_for_hands(hands)).to eq 1
              end
            end
            context "with hand 2" do
              let(:hands) { {n: [ace_of_diamonds], e: [ace_of_hearts, ace_of_spades]} }
              it "returns 2 for the hand" do
                expect(pavlicek.bridge_deal_number_for_hands(hands)).to eq 2
              end
            end
          end
        end
        context "ordered downard and with three hands" do
          let(:pavlicek) do
            described_class.new({n: 1, e: 1, s: 1},
                                [ace_of_spades, ace_of_hearts, ace_of_diamonds])
          end
          describe "#possible_deal_count" do
            it "indicates the number of possible deals is 6" do
              expect(pavlicek.possible_deal_count).to eq 6
            end
          end
          describe "#hands_for_bridge_deal_number" do
            context "for deal number 0" do
              let(:deal) { pavlicek.hands_for_bridge_deal_number(0) }
              context "the hash it returns" do
                it "is the same size as the hand lengths array" do
                  expect(deal.size).to eq 3
                end
                it "has the same keys as the hand lengths array" do
                  expect(deal.keys).to eq [:n, :e, :s]
                end
                it "matches cards in sorted order (for genericity, since hash key orders aren't guaranteed)" do
                  expect(deal[:n][0]).to eq ace_of_spades
                  expect(deal[:e][0]).to eq ace_of_hearts
                  expect(deal[:s][0]).to eq ace_of_diamonds
                end
              end
            end
          end

          describe "#hands_for_bridge_deal_number" do
            context "for deal number 1" do
              let(:deal) { pavlicek.hands_for_bridge_deal_number(1) }
              it "reverses e and s" do
                expect(deal[:n][0]).to eq ace_of_spades
                expect(deal[:e][0]).to eq ace_of_diamonds
                expect(deal[:s][0]).to eq ace_of_hearts
              end
            end
            context "for deal number 5" do
              let(:deal) { pavlicek.hands_for_bridge_deal_number(5) }
              it "fully reverses deal 0" do
                expect(deal[:n][0]).to eq ace_of_diamonds
                expect(deal[:e][0]).to eq ace_of_hearts
                expect(deal[:s][0]).to eq ace_of_spades
              end
            end
          end
        end
      end
    end
    context "with default construction" do
      let(:pavlicek) { described_class.new }
      describe "#hands_for_bridge_deal_number" do
        context "with deal number 0" do
          let (:deal) { pavlicek.hands_for_bridge_deal_number(0) }
          it "has results expecting the direction symbols' ordering is as encoded in original Pavlicek algorithm" do
            expect(deal[:n].length).to eq 13
            deal[:n].each { |card| expect(card.suit).to eq Strain::Club }
            expect(deal[:e].length).to eq 13
            deal[:e].each { |card| expect(card.suit).to eq Strain::Diamond }
            expect(deal[:s].length).to eq 13
            deal[:s].each { |card| expect(card.suit).to eq Strain::Heart }
            expect(deal[:w].length).to eq 13
            deal[:w].each { |card| expect(card.suit).to eq Strain::Spade }
          end
        end
        context "with the maximum deal number" do
          let (:deal) { pavlicek.hands_for_bridge_deal_number(Pavlicek::BRIDGE_DEAL_COUNT-1) }
          it "has the reverse results" do
            expect(deal[:n].length).to eq 13
            deal[:n].each { |card| expect(card.suit).to eq Strain::Spade }
            expect(deal[:e].length).to eq 13
            deal[:e].each { |card| expect(card.suit).to eq Strain::Heart }
            expect(deal[:s].length).to eq 13
            deal[:s].each { |card| expect(card.suit).to eq Strain::Diamond }
            expect(deal[:w].length).to eq 13
            deal[:w].each { |card| expect(card.suit).to eq Strain::Club }
          end
        end
      end

      context "with a random deal number" do
        let(:random_deal_index) { Random.rand(Pavlicek::BRIDGE_DEAL_COUNT) }
        let(:deal) { pavlicek.hands_for_bridge_deal_number(random_deal_index) }
        it "should get the same number back again" do
          expect(pavlicek.bridge_deal_number_for_hands(deal)).to eq(random_deal_index)
        end
      end
    end
  end
end