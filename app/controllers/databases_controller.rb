# frozen_string_literal: true

# CRUD actions for database configurations.
class DatabasesController < ApplicationController
  before_action :authorize_admin

  def index
    @databases = Database.order(created_at: :desc)
  end

  def show
    @database = Database.find(params[:id])
  end

  def new
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
  end

  def update
    @database = Database.find(params[:id])
    if @database.update(database_params)
      render :show
    else
      render :edit
    end
  end

  private

  def database_params
    params.require(:database).permit(:name, :adapter, :username, :password, :host, :port, :database, :description)
  end
end
