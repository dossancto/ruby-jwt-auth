# frozen_string_literal: true

## ProductModel
class ProductModel
  attr_accessor :id, :name, :category, :description, :price, :stock_quantity, :created_at, :updated_at

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @category = attributes[:category]
    @description = attributes[:description]
    @price = attributes[:price].to_f
    @stock_quantity = attributes[:stock_quantity].to_i
    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
  end
end
