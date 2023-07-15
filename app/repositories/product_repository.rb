# frozen_string_literal: true

require 'sinatra/activerecord'

## ProductRepository
class ProductRepository < ActiveRecord::Base
  validates_presence_of :name, :description, :price, :stock_quantity
  self.table_name = 'product'
end
