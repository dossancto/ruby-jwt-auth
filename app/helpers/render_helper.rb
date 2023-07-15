# frozen_string_literal: true

## RenderHelper
module RenderHelper
  def render!(action)
    caller_file_path = caller_locations(1, 1)[0].path
    caller_file_name = File.basename(caller_file_path)
    folder = caller_file_name.sub(/_controller\.rb$/, '')

    erb :"#{folder}/#{action}"
  end
end
