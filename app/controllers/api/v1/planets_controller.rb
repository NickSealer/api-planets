class Api::V1::PlanetsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_planet, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: e.message}, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end

  rescue_from SQLite3::ConstraintException do |e|
    render json: {error: e.message}, status: :failed_dependency
  end

  rescue_from Exception do |e|
    render json: {error: e.message}, status: :internal_error
  end

  def index
    @planets = Planet.all.order(:name)
    if !params[:search].nil? && params[:search].present?
      @planets = SearchService.search_planet(@planets, params[:search])
    end
    render json: @planets, status: :ok
  end

  def show
    render json: @planet, status: :ok
  end

  def create
    @planet = current_api_v1_user.planets.create!(create_params)
    if @planet.save
      msg = {:message => "Planet created: #{@planet.name}."}
      render json: msg, status: :created
    else
      render json: @planet.errors, status: :unprocessable_entity
    end
  end

  def update
    if @planet.update°(create_params)
      msg = {:message => "Planet updated: #{@planet.name}."}
      render json: msg, status: :ok
    else
      render json: @planet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @planet.user_id == current_api_v1_user.id
      @planet.destroy!
      msg = {:message => "Planet deleted: #{@planet.name}."}
      render json: msg, status: :ok
    else
      render json: {message: "Unauthorized"}, status: :unauthorized
    end
  end

  def set_planet
    @planet = Planet.find(params[:id])
  end

  def create_params
    params.permit(:name, :description, :orbital_period, :rotation_period, :mass, :density, :diameter, :gravity, :galaxy_id)
  end

end
