# frozen_string_literal: true

## RenderHelper
module RenderHelper
  def render!(action)
    caller_file_path = caller_locations(1, 1)[0].path
    caller_file_name = File.basename(caller_file_path)
    puts caller_file_name
    folder = caller_file_name.sub(/_controller\.rb$/, '')
    puts folder

    puts @current_user

    erb :"#{folder}/#{action}"
  end
end
