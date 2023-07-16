# frozen_string_literal: true

require 'sinatra/activerecord'

## OrderRepository
class OrderRepository < ActiveRecord::Base
  validates_presence_of :user_id, :total_ammount, :state
  self.table_name = 'order'
end
