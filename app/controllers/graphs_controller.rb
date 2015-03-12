class GraphsController < ApplicationController
  def show
    @gnis_id = params[:id]
  end
end
