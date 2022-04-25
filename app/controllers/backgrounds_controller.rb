class BackgroundsController < ApplicationController

  def show
    if params[:location] == "" || params[:location] == nil
      bad_request
    else
      response = BackgroundFacade.get_background(params[:location])
      if response[:results] == []
        render json: response, status: 404
      else
        render json: response, status: 200
      end
    end
  end
end
