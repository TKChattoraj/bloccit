class Api::V1::TopicsController < Api::V1::BaseController

  before_filter :authenticate_user, except: [:index, :show]
  before_filter :authorize_user, except: [:index, :show, :create_post]

  def index
    topics = Topic.all
    render json: topics.to_json, status: 200
  end

  def show
    topic = Topic.find(params[:id])
    render json: topic.to_json, status: 200
  end

  def create
    topic = Topic.new(topic_params)

    if topic.valid?
      topic.save!
      render json: topic.to_json, status: 201
    else
      render json: {error: "Topic is invalid", status: 400}, status: 400
    end
  end

  def update
    topic = Topic.find(params[:id])

    if topic.update_attributes(topic_params)
      render json: topic.to_json, status: 200
    else
      render json: {error: "Topic update failed", status: 400}, status: 400
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    name = @topic.name

    if @topic.destroy
      render json: {message: "Topic #{name} destroyed", status: 200}, status: 200
    else
      render json: {error: "Topic destroy failed", status: 400}, status: 400
    end
  end

  def create_post

    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    @post.update_rank
    @post.user = @current_user


    #
    # post_parameters = post_params
    # puts post_parameters
    # @post = Post.new(post_parameters)
    # @post.topic_id = params[:topic]
    if @post.valid?
      @post.save!
      render json: @post.to_json, status: 200
    else
      puts @post.title
      puts @post.body
      puts @post.user.name
      puts "Topic: #{@post.topic}"
      puts "post not valid"
      render json: {error: "The Post is invalid", status: 400}, status: 400
    end
  end


  private
  def topic_params
    params.require(:topic).permit(:name, :description, :public)
  end
  def post_params
    params.require(:post).permit(:title, :body)
  end

end
