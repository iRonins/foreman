module Foreman
  module Renderer
    module Scope
      class Base
        include Foreman::Renderer::Scope::Variables
        include Foreman::Renderer::Scope::Macros::Base
        include Foreman::Renderer::Scope::Macros::TemplateLogging
        include Foreman::Renderer::Scope::Macros::SnippetRendering

        def initialize(host: nil, params: {}, variables: {})
          @host = host
          @params = params
          @variables_keys = variables.keys
          variables.each { |k, v| instance_variable_set("@#{k}", v) }
          load_variables
        end

        attr_reader :host, :params, :variables_keys

        def get_binding
          binding
        end

        def allowed_variables
          @allowed_variables ||= begin
            allowed = Foreman::Renderer.config.allowed_variables + variables_keys
            instance_values.symbolize_keys.slice(*allowed)
          end
        end

        def allowed_helpers
          @allowed_helpers ||= Foreman::Renderer.config.allowed_helpers
        end
      end
    end
  end
end
