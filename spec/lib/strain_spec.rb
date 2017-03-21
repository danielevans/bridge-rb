require 'spec_helper'

RSpec.describe Bridge::Strain do
  all = %i{Club Diamond Heart Spade NoTrump}.map { |c| described_class.const_get c }

  describe ".new" do
    it "raises an error" do
      expect {
        described_class.new
      }.to raise_error NoMethodError
    end
  end

  describe ".all" do
    it "gives an array of suits" do
      result = described_class.all
      expect(result).to be_a Array
      expect(result.map(&:class).uniq).to match_array [Bridge::Strain]
    end
  end

  describe ".suits" do
    it "gives an array of suits" do
      result = described_class.suits
      expect(result).to be_a Array
      expect(result.map(&:class).uniq).to match_array [Bridge::Strain]
    end

    it "does not include notrump" do
      expect(described_class.suits).not_to include Bridge::Strain::NoTrump
    end
  end

  describe ".majors" do
    it "returns hearts and spades" do
      expect(described_class.majors).to match_array [Bridge::Strain::Heart, Bridge::Strain::Spade]
    end
  end

  describe ".minors" do
    it "returns clubs and diamonds" do
      expect(described_class.minors).to match_array [Bridge::Strain::Club, Bridge::Strain::Diamond]
    end
  end

  describe ".for_symbol" do
    %i(Club Clubs club clubs CLUB CLUBS C c).each do |symbol|
      it "Returns Club for symbol #{symbol}" do
        expect(described_class.for_symbol symbol).to be Bridge::Strain::Club
      end
    end

    %i(Diamond Diamonds diamond diamonds DIAMOND DIAMONDS D d).each do |symbol|
      it "Returns Diamond for symbol #{symbol}" do
        expect(described_class.for_symbol symbol).to be Bridge::Strain::Diamond
      end
    end

    %i(Heart Hearts heart hearts HEART HEARTS H h).each do |symbol|
      it "Returns Heart for symbol #{symbol}" do
        expect(described_class.for_symbol symbol).to be Bridge::Strain::Heart
      end
    end

    %i(Spade Spades spade spades SPADE SPADES S s).each do |symbol|
      it "Returns Spade for symbol #{symbol}" do
        expect(described_class.for_symbol symbol).to be Bridge::Strain::Spade
      end
    end

    %i(NoTrump NoTrumps notrump notrumps NOTRUMP NOTRUMPS Notrump Notrumps NT Nt nT nt).each do |symbol|
      it "Returns NoTrump for symbol #{symbol}" do
        expect(described_class.for_symbol symbol).to be Bridge::Strain::NoTrump
      end
    end
  end

  describe "#>" do
    described_class.all.each do |strain|
      context "with #{strain} as the receiver" do
        subject(:left) { strain }

        lower = all.take_while { |x| x != strain }.each do |right|
          it "is true for #{right}" do
            expect(left > right).to be true
          end
        end

        (all - lower).each do |right|
          it "is false for #{right}" do
            expect(left > right).to be false
          end
        end
      end
    end
  end

  describe "#<" do
    described_class.all.each do |strain|
      context "with #{strain} as the receiver" do
        subject(:left) { strain }

        lower = (all.take_while { |x| x != strain } + [strain]).each do |right|
          it "is false for #{right}" do
            expect(left < right).to be false
          end
        end

        (all - lower).each do |right|
          it "is true for #{right}" do
            expect(left < right).to be true
          end
        end
      end
    end
  end
end
