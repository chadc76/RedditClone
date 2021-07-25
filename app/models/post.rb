# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  url        :string
#  content    :text
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  validates :title, :author_id, presence: true
  validates :title, uniqueness: true

  has_many :post_subs, dependent: :destroy, inverse_of: :post
  has_many :subs, through: :post_subs
  belongs_to :author, class_name: :User
  has_many :comments, dependent: :destroy

  def comments_by_parent_id
    comment_hash = Hash.new { |h,k| h[k] = [] }
    self.comments.each do |c|
      comment_hash[c.parent_comment_id] << c
    end

    comment_hash
  end
end
