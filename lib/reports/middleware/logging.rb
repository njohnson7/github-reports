require 'logger'

module Reports
  module Middleware
    class Logging < Faraday::Middleware
      def initialize(app)
        super(app)
        @logger = Logger.new STDOUT
        @logger.formatter = proc { |severity, datetime, program, message| "#{message}\n" }
      end

      def call(env)
        start_time = Time.now
        @app.call(env).on_complete do
          duration = Time.now - start_time
          url, method, status = env.url.to_s, env.method.to_s.upcase, env.status
          @logger.debug { '-> %s %s %d (%.3f s)' % [url, method, status, duration] }
        end
      end
    end
  end
end
