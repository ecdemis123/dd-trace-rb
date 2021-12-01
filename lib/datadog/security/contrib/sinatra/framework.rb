module Datadog
  module Security
    module Contrib
      # Instrument Sinatra.
      module Sinatra
        # Sinatra framework code, used to essentially:
        # - handle configuration entries which are specific to Datadog tracing
        # - instrument parts of the framework when needed
        module Framework
          # Configure Rack from Sinatra, but only if Rack has not been configured manually beforehand
          def self.setup
            Datadog::Security.configure do |datadog_config|
              sinatra_config = config_with_defaults(datadog_config)
              unless Datadog.configuration.instrumented_integrations.key?(:rack)
                activate_rack!(datadog_config, sinatra_config)
              end
            end
          end

          def self.config_with_defaults(datadog_config)
            datadog_config[:sinatra]
          end

          # Apply relevant configuration from Sinatra to Rack
          def self.activate_rack!(datadog_config, sinatra_config)
            datadog_config.use(
              :rack,
            )
          end
        end
      end
    end
  end
end