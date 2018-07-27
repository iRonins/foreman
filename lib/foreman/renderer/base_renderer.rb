module Foreman
  module Renderer
    class BaseRenderer
      include Foreman::Renderer::Errors

      def initialize(source, scope)
        @source = source
        @scope = scope
        @scope.instance_variable_set('@template_name', source_name)
      end

      def render
        raise NotImplementedError
      end

      def self.render(source, scope)
        result = new(source, scope).render
        digest = Digest::SHA256.hexdigest(result)
        Foreman::Logging.blob("Unattended render of '#{source.name}' = '#{digest}'", result,
          template_digest: digest,
          template_name: source.name,
          template_host_name: scope.host.try(:name),
          template_host_id: scope.host.try(:id))
        result
      end

      private

      attr_reader :source, :scope
      delegate :name, :content, to: :source, prefix: true
    end
  end
end
