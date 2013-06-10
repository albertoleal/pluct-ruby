require 'spec_helper'

class Client
  include Pluct::Helpers::Request
end

describe Pluct::Helpers::Request do
  let(:client) { Client.new }

  request = [
              { http_code: 401, body: 'Unauthorized.', url: 'http://www.example.com/unauthorized', exception: Pluct::Errors::Unauthorized },
              { http_code: 404, body: 'Not found.',    url: 'http://www.example.com/invalid-url',  exception: Pluct::Errors::UrlNotFound},
            ]

  request.each do |req|
    it "raises an exception #{req[:http_code]}" do
      stub_request(:get, req[:url]).to_return(body: req[:body], status: req[:http_code])
      # expect { client.get req[:url] }.to raise_exception(req[:exception], {http_code: req[:http_code], error_description: req[:body]})
      expect { client.send(:get, req[:url]) }.to raise_exception(req[:exception], {http_code: req[:http_code], error_description: req[:body]})
    end
  end

    it 'returns 200 for valid request' do
    body = File.read('spec/assets/user.json')
    stub_request(:get, 'http://www.example.com/success').to_return(body: body, status: 200)
    response = client.send(:get, 'http://www.example.com/success')

    WebMock.should have_requested(:get, "http://www.example.com/success").with(headers: {'Content-Type' => 'application/json'})
    expect(response.code).to eq 200
    expect(response.body).to eq body
  end
end
