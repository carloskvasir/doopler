class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  after_create_commit :extend_post_lifetime

  private

  def extend_post_lifetime
    post.update_columns(expires_at: post.expires_at + 1.hour)
    broadcast_replace_to "post_clock_#{post_id}",
      target: "post_clock_#{post_id}",
      partial: "posts/post_clock",
      locals: { post: post.reload }
  end
end
