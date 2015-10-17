class SponsoredPostsController < ApplicationController

  def new
    @topic = Topic.find(params[:topic_id])
    @sponsored_post = SponsoredPost.new
  end

  def show
    @sponsored_post = SponsoredPost.find(params[:id])
  end

  def edit
    @sponsored_post = SponsoredPost.find(params[:id])
  end

  def create
    @sponsored_post = SponsoredPost.new
    @sponsored_post.title = params[:sponsored_post][:title]
    @sponsored_post.body = params[:sponsored_post][:body]
    @sponsored_post.price = params[:sponsored_post][:price]
    @topic = Topic.find(params[:topic_id])
    @sponsored_post.topic_id = @topic

    if @sponsored_post.save
      flash[:notice] = "Sponsored Post was saved."
      redirect_to [@topic, @sponsored_post]
    else
      flash[:error] = "There was an error in saving Sponsored Post"
      render :new
    end

  end

  def update
    @sponsored_post = SponsoredPost.find(params[:id])
    @sponsored_post.title = params[:sponsored_post][:title]
    @sponsored_post.body = params[:sponsored_post][:body]
    @sponsored_post.price = params[:sponsored_post][:price]

    if @sponsored_post.save
      flash[:notce] = "Sponsored Post was successfully updated"
      redirect_to [@sponsored_post.topic, @sponsored_post]
    else
      flash[:error] = "There was an error in updating the Sponsored Post"
      render :edit
    end
  end

  def destroy
    @sponsored_post = SponsoredPost.find(params[:id])
    if @sponsored_post.destroy
      flash[:notice] = "The Sponsored Post was successfully destroyed"
      redirect_to Topic.find(params[:topic_id])
    else
      flash[:error] = "There was an error in deleting the Sponsored Post.  Try again."
      render [@sponsored_post.topic, @sponsored_post]
    end
  end
end
