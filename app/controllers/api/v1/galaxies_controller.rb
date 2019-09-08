class Api::V1::GalaxiesController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_galaxy, only: [:show, :update, :destroy]

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
    @galaxies = Galaxy.all.order(:name)
    if !params[:search].nil? && params[:search].present?
      @galaxies = SearchService.search_galaxy(@galaxies, params[:search])
    end
    render json: @galaxies, status: :ok
  end

  def show
    render json: @galaxy, status: :ok
  end

  def create
    @galaxy = current_api_v1_user.galaxies.create!(create_params)
    if @galaxy.save
      msg = {:message => "Galaxy created: #{@galaxy.name}."}
      render json: msg, status: :created
    else
      render json: @galaxy.errors, status: :unprocessable_entity
    end
  end

  def update
    if @galaxy.update!(create_params)
      msg = {:message => "Galaxy updated: #{@galaxy.name}."}
      render json: msg, status: :ok
    else
      render json: @galaxy.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @galaxy.user_id == current_api_v1_user.id
      @galaxy.destroy!
      msg = {:message => "Galaxy deleted: #{@galaxy.name}."}
      render json: msg, status: :ok
    else
      render json: {message: "Unauthorized"}, status: :unauthorized
    end
  end

  def set_galaxy
    @galaxy = Galaxy.find(params[:id])
  end

  def create_params
    params.permit(:name, :description, :right_ascension, :declination, :distance, :form_id)
  end

end
