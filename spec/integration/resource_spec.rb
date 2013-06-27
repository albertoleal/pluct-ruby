require 'spec_helper'

describe Pluct::Resource, :integration do

  let(:resource){ Pluct::Resource.new('http://localhost:8888') }

  it 'creates a new instance' do
    app = resource.collection({context_name: 'baas', collection_name: 'apps'}).create({name: 'my_app', description: 'app_desc'})

    expect(app.response.code).to eq 201
    expect(app.response.headers[:location]).to_not be_nil
    expect(app.data).to be_empty
  end

  it 'expands uri template' do
    collection = resource.collection({context_name: 'baas', collection_name: 'apps'})
    expect(collection.uri).to eq 'http://localhost:8888/baas/apps'
  end

  it 'raises 404 for url not found' do
    expect {resource.resource({context_name: 'baas', collection_name: 'apps', resource_id: 'invalid'}) }.to raise_error(Pluct::Errors::UrlNotFound)
  end
end