class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end
end
