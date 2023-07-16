# frozen_string_literal: true

MIN_PRICE = 15
MIN_NAME_SIZE = 5
MIN_DESCRIPTION_SIZE = 10

module ProductValidation
  ## Create
  class Create
    def initialize(params:)
      @params = params
    end

    def call
      empty_fields = check_presence(:price, :name, :category, :description, :stock_quantity)
      return empty_fields unless empty_fields.empty?

      errors = []

      error_msg = valid_price?
      errors.append(error_msg) if error_msg

      error_msg = valid_name?
      errors.append(error_msg) if error_msg

      error_msg = valid_description?
      errors.append(error_msg) if error_msg

      error_msg = valid_stock_quantity?
      errors.append(error_msg) if error_msg

      errors
    end

    def valid_price?
      price = @params[:price].to_f
      return "Price must be higher than #{MIN_PRICE}" unless price > MIN_PRICE
    rescue StandardError
      'Price format invalid'
    end

    def valid_stock_quantity?
      stock = @params[:stock_quantity].to_i
      return 'Stock must be higher than 0' if stock <= 0
    rescue StandardError
      'invalid stock format'
    end

    def valid_name?
      name = @params[:name]

      return "Name must have #{MIN_NAME_SIZE} letters or more" if name.size < MIN_NAME_SIZE
    end

    def valid_description?
      description = @params[:description]

      return "Description must have #{MIN_DESCRIPTION_SIZE} letters or more" if description.size < MIN_DESCRIPTION_SIZE
    end

    private

    def check_presence(*fields)
      empty_fields = []
      empty_fields = fields.map do |field|
        next if @params[field]

        "Place inform a #{field}"
      end

      return [] unless empty_fields.compact

      empty_fields.compact
    end
  end
end
