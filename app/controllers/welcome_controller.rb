class WelcomeController < ApplicationController
  def index
  end

  def about
  end

  def contact
    @link="http://www.baseball-reference.com/teams/CIN/1975.shtml"
  end
end
