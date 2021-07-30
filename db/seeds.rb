# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('users')
Sub.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('subs')
Post.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('posts')
PostSub.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('post_subs')
Vote.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('vote')
Comment.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('comments')


User.create!(username: "chad", password: "password")
9.times do
  User.create!(username: Faker::Name.unique.first_name, password: "password" )
end

p 'Users created'

users = User.all.map(&:id)

description = Faker::Lorem.paragraph(sentence_count: 3)

10.times do 
  user_id = (1..10).to_a.sample
  Sub.create!(moderator_id: user_id, title: Faker::Superhero.unique.name, description: description)
end

p 'Subs Created'

subs = Sub.all.map(&:id)
content = Faker::Lorem.paragraph(sentence_count: 3)
times = 1
38.times do
  user_id = (1..10).to_a.sample
  sub_amount = (0...10).to_a
  sub_ids = subs.shuffle.take(sub_amount.sample)
  title = Faker::Movie.unique.title
  post = Post.new(author_id: user_id, title: title, sub_ids: sub_ids)
  post.save!
  
  users.each do |voter_id|
    Comment.create!(author_id: voter_id, post_id: post.id, content: content)
  end
  p "Gone through #{times} times "
  times += 1
end



users.each do |voter_id|
  Post.all.map(&:id).each do |post_id|
    val = [-1,1].sample
    Vote.create!(value: val, votable_id: post_id, user_id: voter_id, votable_type: "Post")
  end

  Comment.all.map(&:id).each do |comment_id|
    val = [-1,1].sample
    Vote.create!(value: val, votable_id: comment_id, user_id: voter_id, votable_type: "Comment")
  end

  p "User #{voter_id} votes Created"
end