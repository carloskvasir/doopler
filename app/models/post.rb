class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  before_create { self.expires_at = 2.hours.from_now }

  def active?
    expires_at > Time.current
  end
end
