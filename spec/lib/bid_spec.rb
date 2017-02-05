require 'spec_helper'


RSpec.describe Bridge::Bid do
  subject(:bid) { described_class.all.sample }
  describe ".all" do
    it "returns 35 possible bids" do
      expect(described_class.all.length).to eq(35)
    end
  end

  describe "<=>" do
    it "is zero for identical bids" do
      expect(bid <=> bid).to eq 0
    end
    it "is greater than zero if the strain is higher" do
      expect(described_class.new(1, Bridge::Strain::Diamond) <=> described_class.new(1, Bridge::Strain::Club)).to be > 0
      expect(described_class.new(1, Bridge::Strain::NoTrump) <=> described_class.new(1, Bridge::Strain::Heart)).to be > 0
    end

    it "is less than zero if the strain is lower" do
      expect(described_class.new(1, Bridge::Strain::Club) <=> described_class.new(1, Bridge::Strain::Diamond)).to be < 0
      expect(described_class.new(1, Bridge::Strain::Heart) <=> described_class.new(1, Bridge::Strain::NoTrump)).to be < 0
    end

    it "is greater than zero if the level is higher" do
      expect(described_class.new(3, Bridge::Strain::Diamond) <=> described_class.new(1, Bridge::Strain::Club)).to be > 0
      expect(described_class.new(3, Bridge::Strain::NoTrump) <=> described_class.new(1, Bridge::Strain::Heart)).to be > 0
    end

    it "is less than zero if the level is lower" do
      expect(described_class.new(1, Bridge::Strain::Club) <=> described_class.new(2, Bridge::Strain::Club)).to be < 0
      expect(described_class.new(1, Bridge::Strain::Heart) <=> described_class.new(2, Bridge::Strain::Heart)).to be < 0
    end
  end
end
