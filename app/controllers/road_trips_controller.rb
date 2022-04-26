class RoadTripsController < ApplicationController

  before_action :require_api_key

  def show
  
    if params[:origin] == "" || params[:origin] == nil ||
    params[:destination] == "" || params[:destination] == nil
      bad_request
    else
      response = RoadTripFacade.get_road_trip(params[:origin], params[:destination])
      render json: response, status: 200
    end
  end
end
