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
  validates :title, :sub_id, :author_id, presence: true
  validates :title, uniqueness: true

  has_many :post_subs, dependent: :destroy
  has_many :subs, through: :post_subs, source: :sub
  belongs_to :author, class_name: :User
end
