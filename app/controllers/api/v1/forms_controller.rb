class Api::V1::FormsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_form, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  rescue_from SQLite3::ConstraintException do |e|
    render json: { error: e.message }, status: :failed_dependency
  end

  rescue_from Exception do |e|
    render json: { error: e.message }, status: :internal_error
  end

  def index
    @forms = Form.all.order(:name)
    if !params[:search].nil? && params[:search].present?
      @forms = SearchService.search_form(@forms, params[:search])
    end
    render json: @forms, status: :ok
  end

  def show
    render json: @form, status: :ok
  end

  def create
    @form = current_api_v1_user.forms.create!(create_params)
    if @form.save
      msg = { message: "Galaxy type created: #{@form.name}." }
      render json: msg, status: :created
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  def update
    if @form.update!(create_params)
      msg = { message: "Galaxy type updated: #{@form.name}." }
      render json: msg, status: :ok
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @form.user_id == current_api_v1_user.id
      @form.destroy!
      msg = { message: "Galaxy type deleted: #{@form.name}." }
      render json: msg, status: :ok
    else
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end
  end

  def set_form
    @form = Form.find(params[:id])
  end

  def create_params
    params.permit(:name, :description)
  end

end
