# frozen_string_literal: true

## OrderModel
class OrderModel
  attr_accessor :id, :user_id, :total_ammount, :state, :created_at, :updated_at

  def initialize(attributes = {})
    @id = attributes[:id]

    @user_id = attributes[:user_id]
    @total_ammount = attributes[:total_ammount]
    @state = attributes[:state]

    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
  end
end
