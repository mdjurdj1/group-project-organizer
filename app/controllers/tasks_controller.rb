class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_project, except: %i[assign index]
  before_action :check_if_team_member, except: %i[assign index]

  def index
    @tasks = current_user.tasks
  end

  def new
    @task = Task.new
  end

  def edit() end

  def create
    return render :new unless @project.tasks.build(task_params).save
    redirect_to @project, notice: 'Task was successfully created.'
  end

  def update
    @task.assign_attributes(task_params)
    notice = 'Task was successfully updated.'
    @task.save ? (redirect_to @project, notice: notice) : (render :edit)
  end

  def destroy
    @task.destroy
    notice = 'Task was successfully destroyed.'
    redirect_to request.env['HTTP_REFERER'], notice: notice
  end

  def assign
    task = Task.find(params[:task_id])
    current_user.tasks << task
    notice = "You have successfully assigned yourself to #{task.title}"
    redirect_to project_path(task.project), notice: notice
  end

  def unassign
    task = Task.find(params[:task_id])
    current_user.tasks.pop
  end


  private

  def set_task
    @task = Task.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :due_date, :completed)
  end
end
