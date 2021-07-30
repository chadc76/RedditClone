# == Schema Information
#
# Table name: subscriptions
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  sub_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Subscription < ApplicationRecord
  validates :user_id, :sub_id, presence: true
  validates :user_id, uniqueness: { scope: :sub_id }
  validate :not_users_sub

  belongs_to :user
  belongs_to :sub

  private

  def not_users_sub
    if self.sub.moderator.id == user_id
      errors.add(:user_id, "can't subscribe to own sub")
    end
  end
end
