require 'spec_helper'

RSpec.describe Bridge::Rank do
  describe ".all" do
    it "has one for each possible rank" do
      expect(described_class.all.map(&:order)).to match_array (2..14).to_a
    end
  end
  describe "#pretty_print" do
    it "passes the call through" do
      pp = double
      expect(pp).to receive(:pp).with('#<Bridge::Rank ace>')
      described_class.all.first.pretty_print pp
    end
  end
  describe ".initialize" do
    it "throws an error" do
      expect {subject.initialize}.to raise_error(NoMethodError, /Cannot initialize/)
    end
  end

  describe ".honors" do
    it "returns 10-A" do
      expect(described_class.honors).to match_array [Bridge::Rank::Ten, Bridge::Rank::Jack, Bridge::Rank::Queen, Bridge::Rank::King, Bridge::Rank::Ace]
    end
  end

  describe ".spot" do
    it "returns 2-9" do
      expect(described_class.spot).to match_array [Bridge::Rank::Two, Bridge::Rank::Three, Bridge::Rank::Four,
                                                   Bridge::Rank::Five, Bridge::Rank::Six, Bridge::Rank::Seven,
                                                   Bridge::Rank::Eight, Bridge::Rank::Nine]
    end
  end
end
