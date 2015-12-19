class Api::V1::PostsController < Api::V1::BaseController
  before_filter :authenticate_user, except: [:index, :show]
  before_filter :authorize_for_update_destroy_post, except: [:index, :show]

  # def update
  #   post = Post.find(params[:id])
  #   if post.update_attributes(post_params)
  #     puts post.title
  #     puts post.to_json
  #     render json: post.to_json, status: 200
  #   else
  #     render json: {error: "Update of Post '#{post.name}' failed", status: 400}, status: 400
  #   end
  # end

  def update
    post = Post.find(params[:id])

    if post.update_attributes(post_params)
      render json: post.to_json, status: 200
    else
      render json: {error: "Post update failed", status: 400}, status: 400
    end
  end







  def destroy
    @post = Post.find(params[:id])
    title = @post.title
    if @post.destroy
      render json: {message: "Post '#{title}' was deleted", status: 200}, status: 200
    else
      render json: {error: "Post '#{title}' was NOT deleted", status: 400}, status: 400
    end
  end


  private
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
