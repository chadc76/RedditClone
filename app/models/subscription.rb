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

  belongs_to :user
  belongs_to :sub
end
