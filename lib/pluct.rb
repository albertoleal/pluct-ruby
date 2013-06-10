require 'pluct/version'
require 'multi_json'
require 'pluct/extensions/hash'

module Pluct
  autoload :Errors,   "pluct/errors"
  autoload :Helpers,  "pluct/helpers"
  autoload :Resource, "pluct/resource"

  def self.root
    File.expand_path '../..', __FILE__
  end
end
