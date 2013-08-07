require 'spec_helper'

describe Pluct::Resource, :integration do

  let(:resource){ Pluct::Resource.new('http://localhost:8888') }

  it 'creates a new instance', :vcr, cassette_name: 'integration/creates_new_app' do
    app = resource.rel_collection({context_name: 'baas', collection_name: 'apps'}).rel_create({name: 'my_app', description: 'app_desc'})

    expect(app.response.code).to eq 201
    expect(app.response.headers[:location]).to_not be_nil
    expect(app.data).to be_empty
  end

  it 'expands uri template', :vcr, cassette_name: 'integration/expands_uri' do
    collection = resource.rel_collection({context_name: 'baas', collection_name: 'apps'})
    expect(collection.uri).to eq 'http://localhost:8888/baas/apps'
  end

  it 'raises 404 for url not found', :vcr, cassette_name: 'integration/page_not_found' do
    expect {resource.rel_resource({context_name: 'baas', collection_name: 'apps', resource_id: 'invalid'}) }.to raise_error(Pluct::Errors::UrlNotFound)
  end

  it 'reads instance info', :vcr, cassette_name: 'integration/instance_info' do
    app = resource.rel_resource({context_name: 'baas', collection_name: 'apps', resource_id: '9b0d0333302a42d3bc8ee00b0afa2121'})

    expect(app.data).to_not be_empty
    expect(app.name).to eq 'New App'
    expect(app.description).to eq 'My Awesome App'
  end
end