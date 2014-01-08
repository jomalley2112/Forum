class AddColumnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :comments_count, :integer, :default => 0

	Post.reset_column_information
	Post.find(:all).each do |p|
		Post.update_counters p.id, :comments_count => p.comments.length
	end

  end

end
