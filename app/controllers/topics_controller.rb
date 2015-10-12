class TopicsController < ApplicationController

  def index
    @topics = Topic.all
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new
    @topic.name = params[:topic][:name]
    @topic.description = params[:topic][:description]
    @topic.public = params[:topic][:public]

    if @topic.save
      flash[:notice] = "The topic was saved successfully!"
      redirect_to @topic, notice: "The topic was saved successfully!"
    else
      flash[:error] = "There was an error in saving the topic.  Please try again."
      render :new
    end
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.name = params[:topic][:name]
    @topic.description = params[:topic][:description]
    @topic.public = params[:topic][:public]

    if @topic.save
      flash[:notice] = "The topic was successfully updated"
      redirect_to @topic
    else
      flash[:error] = "There was an error in updating the topic. Try again"
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    if @topic.destroy
      flash[:notice] = "The topic was successfully deleted"
      redirect_to action: :index
    else
      flash[:error] = "There was an error in deleting the topic.  Try again."
      render :show
    end
  end


end
