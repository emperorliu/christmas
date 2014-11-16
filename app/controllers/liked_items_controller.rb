class LikedItemsController < ApplicationController

  before_action :require_user

  def index
    @liked_items = LikedItem.where(user_id: current_user.id)
  end

  def create
    idea = Idea.find(params[:idea_id])
    LikedItem.create(idea_id: idea.id, user_id: current_user.id)
    redirect_to home_path
  end

end