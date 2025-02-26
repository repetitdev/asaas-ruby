require 'typhoeus'
require 'asaas/version'
require 'json'
require 'hashie'


module Asaas
  autoload :Configuration, 'asaas/configuration'
  autoload :Api, 'asaas/api'
  autoload :Client, 'asaas/client'

  class << self

    def setup(&block)
      Asaas::Configuration.setup(&block)
    end

  end


end
