require 'awesome_print'
require 'active_support'
require 'active_support/inflector'
require 'rest-client'
require 'typhoeus'
require 'dry-types'
require 'dry-struct'
require 'asaas/version'
require 'asaas/types'
require 'virtus'
require 'json'


module Asaas
  autoload :Entity, 'asaas/entity'
  autoload :Configuration, 'asaas/configuration'
  autoload :Api, 'asaas/api'
  autoload :Client, 'asaas/client'

  autoload :Model, 'asaas/models/model'
  autoload :Customer, 'asaas/models/customer'
  autoload :Notification, 'asaas/models/notification'
  autoload :Payment, 'asaas/models/payment'
  autoload :Discount, 'asaas/models/discount'
  autoload :Interest, 'asaas/models/interest'
  autoload :Fine, 'asaas/models/fine'
  autoload :Webhook, 'asaas/models/webhook'
  autoload :Account, 'asaas/models/account'
  autoload :Transfer, 'asaas/models/transfer'
  autoload :Balance, 'asaas/models/balance'
  autoload :IdentificationField, 'asaas/models/identification_field'
  autoload :PixQrCode, 'asaas/models/pix_qr_code'
  autoload :Documents, 'asaas/models/documents'
  autoload :DocumentRequest, 'asaas/models/document_request'
  autoload :DocumentResponsible, 'asaas/models/document_responsible'
  autoload :DocumentFile, 'asaas/models/document_file'

  class << self

    def setup(&block)
      Asaas::Configuration.setup(&block)
    end

  end


end
