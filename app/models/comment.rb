class Comment < ActiveRecord::Base
	belongs_to :post, :counter_cache => true
	#belongs_to :posts_w_comment_counts, :foreign_key => "post_id", :primary_key => "posts_w_comment_counts_id"
end
