module Asaas
  class Balance < Model
    attribute :balance, Types::Coercible::Float
  end
end