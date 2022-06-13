# frozen_string_literal: true

# CRUD actions for database configurations.
class DatabasesController < ApplicationController
  before_action :authorize_admin
  rescue_from ActiveRecord::RecordNotFound, with: -> { render :index }

  def index
    @databases = Database.order(created_at: :desc)
  end

  def show
    @database = Database.find(params[:id])
  end

  def new
    @database = Database.new
  end

  def create
    @database = Database.new(user: current_user, **database_params)
    if @database.save
      render :show
    else
      render :new
    end
  end

  def edit
    @database = Database.find(params[:id])
  end

  def update
    @database = Database.find(params[:id])
    if @database.update(database_params)
      render :show
    else
      render :edit
    end
  end

  def destroy
    Database.find(params[:id]).destroy
    flash[:notice] = 'Database configuration deleted.'
    render :index
  end

  private

  def database_params
    params.require(:database).permit(:name, :adapter, :username, :password, :host, :port, :database, :description)
  end
end
