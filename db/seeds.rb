include RandomData

#Create tables
15.times do
  Topic.create!(
    name: RandomData.random_sentence,
    description: RandomData.random_paragraph
    )
  end
topics = Topic.all

5.times do
  User.create!(name: RandomData.random_name, email: RandomData.random_email, password: RandomData.random_password)
end
users = User.all

# Create posts
50.times do
  Post.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph,
    topic: topics.sample,
    user: users.sample
  )
end
posts = Post.all

# Create Create Comments
100.times do
  Comment.create!(
    post: posts.sample,
    body: RandomData.random_paragraph
  )
end

user = User.first
user.update_attributes!(email: 'kumar.chattoraj@gmail.com', password: 'hellowworld')


puts "Seed finished"
puts "#{Topic.count} topics created"
puts "#{User.count} users created"
puts "#{Post.count} posts created and associated to a topic and user"
puts "#{Comment.count} comments created and associated to a post"
