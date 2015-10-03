include RandomData

# Create posts
50.times do
  Post.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
  )
end
specific_post = Post.find_or_create_by(title: "Specific Title", body: "Specific Body")
posts = Post.all

# Create Create Comments
100.times do
  Comment.create!(
    post: posts.sample,
    body: RandomData.random_paragraph
  )
end
Comment.find_or_create_by(post: specific_post, body: "Specific Comment Body")

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
