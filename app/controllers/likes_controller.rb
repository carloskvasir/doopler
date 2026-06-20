class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post.likes.create!(user: current_user)
  rescue ActiveRecord::RecordNotUnique
    # already liked — no-op
  end

  private

  def like_params
    params.permit(:post_id)
  end
end
