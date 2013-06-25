require 'addressable/template'
require 'multi_json'
require 'pluct/version'

module Pluct
  autoload :Errors,   "pluct/errors"
  autoload :Helpers,  "pluct/helpers"
  autoload :Resource, "pluct/resource"
  autoload :Schema,   "pluct/schema"

  extend Pluct::Helpers::Request
  
  def self.get_resource(path)
    request = get(path)
    schema = Schema.from_header(request.headers)
    resource = Resource.new(path, schema, request.body)
  end
  
  def self.root
    File.expand_path '../..', __FILE__
  end
end