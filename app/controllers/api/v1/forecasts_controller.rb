class Api::V1::ForecastsController < ApplicationController

  def show
    if params[:location] == "" || params[:location] == nil
      bad_request
    else
      response = ForecastFacade.get_forecast(params[:location])
      if response[:results] == []
        render json: response, status: 404
      else
        render json: response, status: 200
      end
    end
  end
end
