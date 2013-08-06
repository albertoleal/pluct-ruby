require "spec_helper"

describe Pluct::LinkDescriptionObject do
  describe "#expand_href" do
    let(:raw_link) { {"href" => "http://example.org/{variable}", "rel" => "my-rel"} }
    subject(:ldo) { Pluct::LinkDescriptionObject.new(raw_link) }
    specify { expect(ldo.expand_href({variable: "my-variable"})).to eq("http://example.org/my-variable") }
  end
end
