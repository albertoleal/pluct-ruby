require 'spec_helper'

describe Pluct::Resource do
  let(:schema) { mock(Pluct::Schema) }
  let(:user) { Pluct::Resource.new 'www.example.com/users/1', schema }
  let(:user_without_content_type) { Pluct::Resource.new 'www.example.com/users/2' }
  let(:user_without_schema) { Pluct::Resource.new 'www.example.com/users/3' }
  let(:user_schema) { MultiJson.decode(File.read('spec/assets/user_schema.json')) }

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
    
    schema.stub(:links).and_return(user_schema["links"])
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
  
  it "does something", :focus do
    a = Pluct.get_resource 'http://localhost:8888'
    a.collection({context_name: 'baas', collection_name: 'apps'}).create({name: 'josefina', description: 'mehhh'}).edit({name: 'daeeelhe', description: 'daeeelhe'})
    # a.resource({context_name: 'baas', collection_name: 'apps', resource_id: 'a91ccc92d638499bbe1291f69c32dacd'}).edit({name: 'joaaaa', description: 'mmmmmm'})
  end
end 
