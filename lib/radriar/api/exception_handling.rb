module Radriar::API
  module ExceptionHandling
    module Grape
      extend ActiveSupport::Concern

      included do
        if defined?(Mongoid)
          rescue_from Mongoid::Errors::DocumentNotFound do |e|
            error_response(message: e.message, status: 404)
          end
        end

        rescue_from Grape::Exceptions::ValidationErrors do |e|
          Rack::Response.new({
            status: 422,
            message: e.message,
            errors: e.errors
          }.to_json, 422, { "Content-Type" => "application/json"})
        end

        rescue_from Mongoid::Errors::Validations do |e|
          Rack::Response.new({
            message: "Validation failed",
            status: 422,
            errors: e.document.errors.messages
          }.to_json, 422, {"Content-Type" => "application/json"})
        end

        rescue_from Mongoid::Errors::DocumentNotFound do |e|
          error_response(
            message: "There was a problem finding a requested or associated record",
            status: 404
          )
        end

        rescue_from :all do |e|
          if Rails.env.development? || Rails.env.test?
            raise e
          else
            Bugsnag.notify(e) if defined?(Bugsnag)
            error_response(message: "Internal server error", status: 500)
          end
        end
      end
    end
  end
end
