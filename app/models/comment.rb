# == Schema Information
#
# Table name: comments
#
#  id                :bigint           not null, primary key
#  content           :text             not null
#  author_id         :integer          not null
#  post_id           :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_comment_id :integer
#
class Comment < ApplicationRecord
  validates :content, :author_id, :post_id, presence: true

  belongs_to :post

  belongs_to :author, class_name: :User

  has_many :child_comments, 
    dependent: :destroy,
    foreign_key: :parent_comment_id,
    class_name: :Comment

  belongs_to :parent_comment, 
    optional: true,
    foreign_key: :parent_comment_id,
    class_name: :Comment

    has_many :votes, dependent: :destroy, as: :votable

    def score
      votes
        .map(&:value)
        .sum
    end
end
