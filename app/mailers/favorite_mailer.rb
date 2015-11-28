class FavoriteMailer < ApplicationMailer
  default from: "kumar.chattoraj@gmail.com"

  def new_comment(user, post, comment)

    headers["Message-ID"] = "<comments/#{comment.id}@your-app-name.example>"
    headers["In-Reply-To"] = "<post/#{post.id}@your-app-name.example>"
    headers["References"] = "<post/#{post.id}@your-app-name.example>"

    @user = user
    @post = post
    @comment = comment

    mail(to: @user.email, subject: "New comment on #{@post.title}")
  end

  def new_post(post)
    headers["Message-ID"] = "<new post:  #{post.title}>"
    headers["In-Reply_To"] = "<post #{post.title} is under topic #{post.topic.name}>"
    headers["References"] = "<post #{post.title} was created by #{post.user}>"

    @post = post
    @user = @post.user
    @message = "You just created a post on Bloccit, #{@post.title} and automatically favorited it!  You'll receive email updates when someone comments on your post."

    mail(to: @user.email, subject: "New Post #{@post.title} on Bloccit")

  end

end
