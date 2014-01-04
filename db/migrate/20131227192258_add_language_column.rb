class AddLanguageColumn < ActiveRecord::Migration
  def up
  	add_column :posts, :language, :string
  end

  def down
  	remove_column :posts, :language
  end
end
