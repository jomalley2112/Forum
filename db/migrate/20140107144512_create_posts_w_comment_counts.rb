class CreatePostsWCommentCounts < ActiveRecord::Migration
  def change
    drop_view :posts_w_comment_counts
    create_view :posts_w_comment_counts, %Q{
    		SELECT posts.id as posts_w_comment_counts_id, posts.title, posts.body, posts.public,
				posts.created_at, posts.updated_at, posts.user_id,
				(select count(comments.id) from comments where comments.post_id = posts.id) as comment_count 
			FROM posts
    		}
  end
end
