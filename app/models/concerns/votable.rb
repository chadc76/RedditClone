module Votable
  extend ActiveSupport::Concern

  included do 
    has_many :votes, dependent: :destroy, as: :votable
  end

  def score
    votes
      .map(&:value)
      .sum
  end

  def has_recent_votes
    return true if votes.any?{|vote| vote.created_at >= 60.minutes.ago && vote.value == 1 }
    false
  end

  def hotness
    votes.map do |vote|
      if vote.created_at >= 60.minutes.ago && vote.value == 1
        vote.value * 3
      else
        vote.value
      end
    end.sum
  end
end