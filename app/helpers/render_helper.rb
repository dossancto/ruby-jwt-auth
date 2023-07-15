# frozen_string_literal: true

## RenderHelper
module RenderHelper
  def render!(action)
    caller_file_path = caller_locations(1, 1)[0].path
    caller_file_name = File.basename(caller_file_path)
    folder = caller_file_name.sub(/_controller\.rb$/, '')

    erb :"#{folder}/#{action}"
  end

  def browser_request?
    user_agent = request.user_agent

    user_agent =~ /Mozilla|Chrome|Safari|Opera|Firefox/
  end

  def api_render_many(content)
    {
      data: content
    }.to_json
  end

  def api_render_one(content)
    content.to_json
  end
end
