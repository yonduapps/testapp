class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def self.error_handler(status)
    lambda do |error|
      body = { error: error.class.name.demodulize }
      body.merge! error.extra if error.respond_to? :extra
      render json: body, status: status
    end
  end
end
