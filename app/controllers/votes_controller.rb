class VotesController < ApplicationController
  before_action :require_sign_in
  #before_action :respond_to_html_and_js

  def up_vote
    # @post = Post.find(params[:post_id])
    # @vote = @post.votes.find_or_initialize_by(user_id: current_user.id, post_id: @post.id)
    # @vote.value = 1
    # @vote.save
    # redirect_to :back
    vote(1)
    #@points = @post.points
    # redirect_to :back
    respond_to do |format|

      format.js {render :file => "votes/votes_count.js.erb"}
    end

  end

  def down_vote
    # @post = Post.find(params[:post_id])
    # @vote = @post.votes.find_or_initialize_by(user_id: current_user.id, post_id: @post.id)
    # @vote.value = -1
    # @vote.save
    # redirect_to :back
    vote(-1)
    #@points = @post.points
    # redirect_to :back
    respond_to do |format|
      format.js {render :file => "votes/votes_count.js.erb"}
    end
  end

 private
    def vote(vote_value)
      @post = Post.find(params[:post_id])
      @vote = @post.votes.find_or_initialize_by(user_id: current_user.id, post_id: @post.id)
      @vote.value = vote_value
      @vote.save
    end

    # def respond_to_html_and_js
    #   self.respond_to do |format|
    #     format.js {render :file => "votes/votes_count.js.erb"}
    #   end
    # end

end
