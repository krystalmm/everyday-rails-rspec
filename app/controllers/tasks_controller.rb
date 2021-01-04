class TasksController < ApplicationController
    before_action :set_project
    before_action :project_owner?
    before_action :set_task, only: [:show, :edit, :update, :destroy, :toggle]
  
    # GET /tasks
    # GET /tasks.json
    def index
      @tasks = Task.all
    end
  
    # GET /tasks/1
    # GET /tasks/1.json
    def show
    end
  
    # GET /tasks/new
    def new
      @task = @project.tasks.new
    end
  
    # GET /tasks/1/edit
    def edit
    end
  
    # POST /tasks
    # POST /tasks.json
    def create
      @task = @project.tasks.new(task_params)
  
      respond_to do |format|
        if @task.save
          format.html { redirect_to @project, notice: 'Task was successfully created.' }
          format.json { render :show, status: :created, location: [@task.project, @task] }
        else
          format.html { render :new }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    end
  