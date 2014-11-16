class IdeasController < ApplicationController
  before_action :require_user
  
  def index
    @ideas = Idea.all
  end

  def new
    @idea = Idea.new
  end

  def create
    @idea = Idea.new(idea_params)
    @idea.user = current_user
    if @idea.save
      redirect_to ideas_path
    else
      render new_idea_path
    end
  end

  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy if current_user.ideas.include?(@idea)
    redirect_to ideas_path
  end

  private

  def idea_params
    params.require(:idea).permit!
  end
end