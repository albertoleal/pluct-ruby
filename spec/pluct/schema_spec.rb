require 'spec_helper'

describe Pluct::Schema do

  let(:schema) { Pluct::Schema.new 'www.example.com/schemas/user' }
 
  before (:each) do
    stub_request(:get, 'www.example.com/schemas/user').to_return(body: File.read('spec/assets/user_schema.json'),
                                                                 status: 200)
  end
 
  it { expect(schema.to_s).to eq 'www.example.com/schemas/user' }

  it 'has a schema data' do
    jsonschema = MultiJson::decode(File.read('spec/assets/user_schema.json'))

    expect(schema.data).to be_instance_of Hash
    expect(schema.data).to eq jsonschema
  end

  it 'has links' do
    expect(schema.links).to have(5).items
  end
end
