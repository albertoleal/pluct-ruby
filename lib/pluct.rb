require 'addressable/template'
require 'multi_json'
require 'json'
require 'pluct/extensions/json'
require 'pluct/version'

module Pluct
  autoload :Errors,   "pluct/errors"
  autoload :Helpers,  "pluct/helpers"
  autoload :JSON,     "pluct/extensions/json"
  autoload :LinkDescriptionObject, "pluct/link_description_object"
  autoload :Resource, "pluct/resource"
  autoload :Schema,   "pluct/schema"

  extend Pluct::Helpers::Request

  def self.root
    File.expand_path '../..', __FILE__
  end
end
