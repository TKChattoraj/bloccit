class VotesController < ApplicationController
  before_action :require_sign_in

  def up_vote
    # @post = Post.find(params[:post_id])
    # @vote = @post.votes.find_or_initialize_by(user_id: current_user.id, post_id: @post.id)
    # @vote.value = 1
    # @vote.save
    # redirect_to :back
    vote(1)
  end

  def down_vote
    # @post = Post.find(params[:post_id])
    # @vote = @post.votes.find_or_initialize_by(user_id: current_user.id, post_id: @post.id)
    # @vote.value = -1
    # @vote.save
    # redirect_to :back
    vote(-1)
  end

  private
  def vote(vote_value)
    @post = Post.find(params[:post_id])
    @vote = @post.votes.find_or_initialize_by(user_id: current_user.id, post_id: @post.id)
    @vote.value = vote_value
    @vote.save
    redirect_to :back
  end


end
