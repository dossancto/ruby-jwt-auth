# frozen_string_literal: true

## RenderHelper
module RenderHelper
  def render!(action)
    folder = caller_locations(1, 1)[0].path
                                      .then { File.basename _1 }
                                      .then { _1.sub(/_controller\.rb$/, '') }
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
