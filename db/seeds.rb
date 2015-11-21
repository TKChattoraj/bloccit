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
  post = Post.new(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph,
    topic: topics.sample,
    user: users.sample
  )
  post.update_attribute(:created_at, rand(10.minutes..1.year).ago)
  rand(1..5).times {post.votes.create!(value: [-1, 1].sample, user: users.sample)}
  post.update_rank
  post.save
end
posts = Post.all

# Create Create Comments
100.times do
  Comment.create!(
    post: posts.sample,
    body: RandomData.random_paragraph,
    user: users.sample
  )
end

user = User.first
user.update_attributes!(email: 'kumar.chattoraj@gmail.com', password: 'hellowworld')

#create an admin
admin = User.create!(
  name:  'Admin User',
  email: 'admin@example.com',
  password: 'helloworld',
  role: 'admin'
)

#create a member
member = User.create!(
  name:  "Member User",
  email:  "member@example.com",
  password:  "helloworld",
  role:  "member"
)


puts "Seed finished"
puts "#{Topic.count} topics created"
puts "#{User.count} users created"
puts "#{Post.count} posts created and associated to a topic and user"
puts "#{Comment.count} comments created and associated to a post"
puts "#{Vote.count} votes created"
