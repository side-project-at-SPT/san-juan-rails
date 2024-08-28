class Api::V1::WalkingSkeletonController < ApplicationController
  def show
    respond_to do |format|
      format.json { render json: { message: "Walk" } }
      format.html { render plain: "Server is up and running -- #{Time.now}" }
    end
  end
end
