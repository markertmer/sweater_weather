class ApplicationController < ActionController::API

  def bad_request
    render json: BadRequestSerializer.response, status: 400
  end
end
