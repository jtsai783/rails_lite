require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'
require 'byebug'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
    	file_name = "views/#{self.class.name.underscore}/#{template_name}.html.erb"
    	template = ERB.new(File.read(file_name))
    	render_content(template.result(binding), "text/html" )
    end
  end
end
