require 'addressable/template'
require 'pluct/version'
require 'multi_json'
require 'pluct/extensions/hash'

module Pluct
  autoload :Errors,   "pluct/errors"
  autoload :Helpers,  "pluct/helpers"
  autoload :Resource, "pluct/resource"
  autoload :Schema,   "pluct/schema"

  extend Pluct::Helpers::Request
  
  def self.get_resource(path)
    request = get(path)
    schema = schema_from_header(request.headers)
    resource = Resource.new(path, schema)
  end
  
  def self.root
    File.expand_path '../..', __FILE__
  end
  
  private
  def self.schema_from_header(headers)
    return nil unless headers[:content_type] 
    
    schema = headers[:content_type].match('.*profile=([^;]+);?')
    return nil unless schema

    Schema.new(schema[1])    
  end  
end
