require 'spec_helper'

describe Pluct, :acceptance do
  
    it '', :vcr, cassette_name: 'acceptance/pluct_resource' do
    resource = Pluct.get_resource 'http://repos.example.com/interatividade/famosos'
    resource_self = MultiJson.decode(resource.self)

    expect(resource_self).to have_key("items")
    expect(resource_self["item_count"]).to eq 2
  end

  it 'creates a new app', :vcr, cassette_name: 'acceptance/creates_new_app' do
    resource = Pluct.get_resource 'http://localhost:8888/baas/apps'   
    response = resource.create(nil, {name: 'New App', description: 'My Awesome App'})

    expect(response.code).to eq 201
    expect(response.headers[:location]).to_not be_nil
  end
end