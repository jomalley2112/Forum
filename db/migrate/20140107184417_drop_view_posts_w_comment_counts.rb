class DropViewPostsWCommentCounts < ActiveRecord::Migration
  def change
  	drop_view :posts_w_comment_counts
  end
end
