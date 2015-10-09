class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new
    @question.title = params[:question][:title]
    @question.body = params[:question][:body]
    @question.resolved = params[:question][:resolved]

    if @question.save
      flash[:notice]="Question was successfully creeated."
      redirect_to @question
    else
      flash[:error] = "There was an error with creating this question."
      render :new
    end
  end

  def edit
    @question = Question.find(params[:id])
  end




  def destroy
  end

end
