class MunchiesController < ApplicationController

  def show
    if params[:start] == "" || params[:start] == nil ||
    params[:destination] == "" || params[:destination] == nil ||
    params[:food] == "" || params[:food] == nil
      bad_request
    else
      response = MunchieFacade.get_munchie(params[:start], params[:destination], params[:food])
      render json: response, status: 200
    end
  end
end
