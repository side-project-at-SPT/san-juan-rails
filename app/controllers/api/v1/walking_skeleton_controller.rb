class Api::V1::WalkingSkeletonController < ApplicationController
  skip_before_action :reject_if_not_json_request

  def show
    respond_to do |format|
      format.json { render json: { message: "Walk" } }
      format.html { render plain: "Server is up and running -- #{Time.current}" }
    end
  end
end
