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
    it "returns #{req[:http_code]}" do
      stub_request(:get, req[:url]).to_return(body: req[:body], status: req[:http_code])
      expect { client.get req[:url] }.to raise_exception(req[:exception], {http_code: req[:http_code], error_description: req[:body]})
    end
  end
end
