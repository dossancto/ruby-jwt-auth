# frozen_string_literal: true

require 'sinatra/activerecord'

## OrderRepository
class OrderItemsRepository < ActiveRecord::Base
  validates_presence_of :product_id, :order_id, :quantity, :price_per_unit, :subtotal
  self.table_name = 'order_items'
end
