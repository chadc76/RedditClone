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
require "test_helper"

class VoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
