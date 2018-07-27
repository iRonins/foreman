module Foreman
  module Renderer
    module Source
      class Base
        def initialize(template)
          @template = template
        end

        def name
          @name ||= template.try(:name) || 'Unnamed'
        end

        def content
          raise NotImplementedError
        end

        private

        attr_reader :template
      end
    end
  end
end
