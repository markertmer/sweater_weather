class ApplicationController < ActionController::API

  def bad_request
    render json: BadRequestSerializer.response, status: 400
  end

  def require_api_key
    user = User.find_by(api_key: params[:api_key])
    if user == nil || params[:api_key] == nil || params[:api_key] == ""
      render json: { message: 'Invalid credentials' }, status: 401
    end
  end
end
