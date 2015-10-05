class Post < ActiveRecord::Base
  has_many :comments

  def self.create! *args
    super
    if self.count % 5 == 0
      p = self.last
      p.title = "SPAM"
      p.save

      #ost.last.title = "SPAM"
      #Post.last.save


      #This didn't work:
        #self.last.title = "SPAM"
        #self.last.save
      #Initially, I only had:
        #self.last.title = "SPAM"
      #Then I realized I need to save the updated model,
      #but self.last.save gave me an undefined method.
      #I think this might be because calling self.last goes back
      #to the database and retrievs the last post, which is as it
      #was before I changed the name.  Calling self.last.save does not
      #save the post whose name I just changed.  I don't understand
      #the undefined method error.  Seems like that line should just
      #save the last post which it just retrieved fromt the database.

    end
  end

end
