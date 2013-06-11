require 'spec_helper'

describe Pluct::Resource do
  before(:each) do
    stub_request(:get, 'www.example.com/users/1').to_return(body: File.read('spec/assets/user.json'), 
                                                           status: 200, 
                                                           headers: {'content-type' => 'application/json; charset=utf-8; profile=http://www.example.com/schemas/user'})


    stub_request(:get, 'www.example.com/users/2').to_return(body: File.read('spec/assets/user.json'), 
                                                           status: 200)
    
    stub_request(:get, 'www.example.com/users/3').to_return(body: File.read('spec/assets/user.json'), 
                                                           status: 200,
                                                           headers: {'content-type' => 'application/json; charset=utf-8;'})
    
    stub_request(:get, 'www.example.com/schemas/user').to_return(body: File.read('spec/assets/user_schema.json'),
                                                                 status: 200)
    
  end

  let(:user) { Pluct::Resource.new 'www.example.com/users/1' }
  let(:user_without_content_type) { Pluct::Resource.new 'www.example.com/users/2' }
  let(:user_without_schema) { Pluct::Resource.new 'www.example.com/users/3' }

  #FIXME
  xit 'return "nil" when missing schema url' do
    expect(user_without_content_type.schema).to be_nil
    expect(user_without_schema.schema).to be_nil
  end

  it 'has a schema url' do
    expect(user.schema).to eq 'http://www.example.com/schemas/user'
  end

  it 'has a schema data' do
    schema = MultiJson::decode(File.read('spec/assets/user_schema.json'))
    user_schema = user.schema(false)

    expect(user_schema).to be_instance_of Hash
    expect(user_schema).to eq schema
  end

  it 'has resource data' do
    resource_data = File.read('spec/assets/user.json')
    expect(user.data).to eq resource_data
  end

  it 'adds methods' do
    methods = [:edit, :replace, :self, :delete, :create]
    methods.each do |method|
      expect(user.class.instance_methods(false)).to include(method)
    end
  end
end 
