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
  include Votable

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

  def short_content
    if self.content.length > 40    
      self.content[0..40] + "..."
    else
      self.content
    end
  end
end
