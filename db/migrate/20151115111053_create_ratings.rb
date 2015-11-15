class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |r|
      r.integer :severity
    end
  end
end
