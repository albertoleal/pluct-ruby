require "spec_helper"

describe "following a link with DELETE method", :vcr, cassette_name: "integration/delete" do
  it "should DELETE resource" do
    root = Pluct::Resource.new("http://localhost:8888")
    resource = root.rel_collection({
      context_name: "pluct",
      collection_name: "people"
    }).rel_add({name: "Alice"})

    expect(resource.response.code).to eq(201)

    location = Addressable::URI.parse(resource.response.headers[:location])
    resource_id = location.path.split("/")[3]

    root = Pluct::Resource.new("http://localhost:8888")
    resource = root.rel_resource({
      context_name: "pluct",
      collection_name: "people",
      resource_id: resource_id
    }).rel_delete

    expect(resource.response.code).to eq(204)

    expect { root.rel_resource({
      context_name: "pluct",
      collection_name: "people",
      resource_id: resource_id
    }) }.to raise_error(Pluct::Errors::UrlNotFound)
  end
end
