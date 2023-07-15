# frozen_string_literal: true

## AdminAreaController
class AdminAreaController < ApplicationController
  before do
    authenticate!
    authorize! [:admin]
  end

  get '/' do
    @current_user.to_json
  end
end
