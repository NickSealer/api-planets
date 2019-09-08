class Api::V1::HealthController < ApplicationController
  before_action :authenticate_api_v1_user!, except: [:health]

  def health
    render json:{message: "API OK"}, status: :ok
  end

  def user
    @user = current_api_v1_user
    render json: @user, status: :ok
  end
  
end
