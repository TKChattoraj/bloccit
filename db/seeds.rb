include RandomData

#Create tables
15.times do
  Topic.create!(
    name: RandomData.random_sentence,
    description: RandomData.random_paragraph
    )
  end
topics = Topic.all

# Create posts
50.times do
  Post.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph,
    topic: topics.sample
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

puts "Seed finished"
puts "#{Topic.count} topics created"
puts "#{Post.count} posts created and associated to a topic"
puts "#{Comment.count} comments created and associated to a post"
