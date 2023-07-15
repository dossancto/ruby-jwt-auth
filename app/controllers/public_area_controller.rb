# frozen_string_literal: true


## AdminAreaController
class PublicAreaController < ApplicationController
  get '/' do
    render! :index
  end
end
