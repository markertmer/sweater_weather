class UsersController < ApplicationController

  def create
    user = User.new(user_params)

    if user.save
      user.update(api_key: generate_api_key)
      render json: UserSerializer.new_user_response(user), status: 201
    else
      render json: { message: user.errors.full_messages.join(', ') }, status: 400
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def generate_api_key
    characters = ("A".."Z").to_a + ("0".."9").to_a
    key = ""
    69.times { key += characters.sample }
    key
  end
end
