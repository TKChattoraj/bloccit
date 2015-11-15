class IncludeForeignKeysInTopicsAndPosts < ActiveRecord::Migration

  def change
    add_column :topics, :rating_id, :integer
    add_column :posts, :rating_id, :integer

    add_index :topics, :rating_id
    add_index :posts, :rating_id

    add_foreign_key :topics, :ratings
    add_foreign_key :posts, :ratings
  end
end
