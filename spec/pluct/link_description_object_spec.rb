require "spec_helper"

describe Pluct::LinkDescriptionObject do
  describe "#expand_href" do
    let(:raw_link) { {"href" => "http://example.org/{variable}", "rel" => "my-rel"} }
    subject(:ldo) { Pluct::LinkDescriptionObject.new(raw_link) }
    specify { expect(ldo.expand_href({variable: "my-variable"})).to eq("http://example.org/my-variable") }
  end

  describe "#unused_mapping" do
    let(:raw_link) { {"href" => "http://example.org/{variable}", "rel" => "my-rel"} }
    let(:mapping) { {variable: "my-variable", unused_variable: "my-unused-variable"} }
    subject(:ldo) { Pluct::LinkDescriptionObject.new(raw_link) }

    it "should return unused mapping" do
      expect(ldo.unused_mapping(mapping)).to eq({unused_variable: "my-unused-variable"})
    end

    it "should not change original mapping" do
      ldo.unused_mapping(mapping)
      expect(mapping).to eq({variable: "my-variable", unused_variable: "my-unused-variable"})
    end
  end
end
