class Api::V1::WalkingSkeletonController < ApplicationController
  def show
    render json: { message: "Walk" }
  end
end
