require "spec_helper"

describe "following a link with POST method", :vcr, cassette_name: "integration/post" do
  it "should POST resource" do
    root = Pluct::Resource.new("http://localhost:8888")
    collection = root.collection({context_name: "pluct", collection_name: "people"})
    resource = collection.add({name: "Alice"})

    expect(resource.response.code).to eq(201)

    location = Addressable::URI.parse(resource.response.headers[:location])
    path_components = location.path.split("/")
    context_name, collection_name, resource_id = path_components[1], path_components[2], path_components[3]

    resource = root.resource({context_name: context_name, collection_name: collection_name, resource_id: resource_id})

    expect(resource.data[:name]).to eq("Alice")
  end
end
