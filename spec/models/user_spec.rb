require 'spec_helper'

describe User do
  describe "orders it's posts by days old (default), number of comments,  or title by members" do
  	it "orders it's posts by age by default" do
  		posts = create_desc_timed_posts() #array is ordered by created_at desc
      	ordered_posts = Post.ordered_by()
      	ordered_posts.to_a.to_s.should == posts.to_s
    end
    it "orders it's posts by title" do
  		posts = create_posts_unordered_by_title
      	ordered_posts = Post.ordered_by("title")
      	ordered_posts.to_a.to_s.should == posts.sort_by(&:title).to_s
    end
    it "orders it's posts by number of comments" do
  		posts = create_posts_w_rand_comments
      	ordered_posts = Post.ordered_by("comments")
      	prev_comm_cnt = Integer
      	ordered_posts.each_with_index do |post, i|
	        curr_comm_cnt = post.comments_count
	        curr_comm_cnt.should be <= prev_comm_cnt if i > 0
	        prev_comm_cnt = curr_comm_cnt
      	end
    end
  end
end
