require 'spec_helper'

describe Pluct::Resource do
  let(:schema) { mock(Pluct::Schema) }

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

  context 'schema on header' do
    it 'has resource data' do
      resource = Pluct::Resource.new('www.example.com/users/1')
      resource_data = JSON.parse(File.read('spec/assets/user.json'), {symbolize_names: true})

      expect(resource.data).to eq resource_data
    end

    it 'retrieves the schema' do
      resource = Pluct::Resource.new('www.example.com/users/1')

      expect(resource.schema).to_not be_nil
      expect(resource.schema.to_s).to eq 'http://www.example.com/schemas/user'
    end

    it 'adds methods dynamically' do
      resource = Pluct::Resource.new('www.example.com/users/1')

      methods = [:rel_edit, :rel_replace, :rel_self, :rel_delete, :rel_create]
      methods.each do |method|
        expect(resource.class.instance_methods(false)).to include(method)
      end
    end

  end

  context 'invalid header' do
    it 'does not have content type' do
      resource = Pluct::Resource.new('www.example.com/users/2')

      expect(resource.data).to_not be_nil
      expect(resource.schema).to be_nil
    end

    it 'does not have profile on content type' do
      resource = Pluct::Resource.new('www.example.com/users/3')

      expect(resource.data).to_not be_nil
      expect(resource.schema).to be_nil
    end
  end
end