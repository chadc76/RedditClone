# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  value        :integer          not null
#  votable_type :string
#  votable_id   :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          not null
#
class Vote < ApplicationRecord
  before_validation :delete_previous_vote
  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }
  validates :votable_type, inclusion: {in: %w(Post Comment)}
  validates :value, inclusion: {in: [-1, 1]}

  belongs_to :votable, polymorphic: true

  private

  def delete_previous_vote
    vote = Vote.where(user_id: self.user_id, votable_type: self.votable_type, votable_id: self.votable_id).first
    vote.destroy unless vote.nil?
    true
  end
end
