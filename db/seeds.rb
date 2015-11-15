include RandomData

# Create Ratings
pg_rating = Rating.create!(severity: :PG)
pg13_rating = Rating.create!(severity: :PG13)
r_rating = Rating.create!(severity: :R)

ratings = Rating.all

#Create tables
15.times do
  Topic.create!(
    name: RandomData.random_sentence,
    description: RandomData.random_paragraph,
    rating:  ratings.sample
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
    user: users.sample,
    rating: ratings.sample
  )
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
puts "#{pg_rating.severity} Rating created."
puts "#{pg13_rating.severity} Rating created."
puts "#{r_rating.severity} Rating created."
