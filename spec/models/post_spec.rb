require 'spec_helper'

describe Post do
  it "validates the existence of user before it gets saved" do
  	post = Post.new(:title => "Test Post", :body => "Test post body.")
  	post.save.should eq(false)
  	user = FactoryGirl.create(:user)
  	post.update_attribute(:user_id, user.id)
  	post.save.should eq(true)
  	post.update_attribute(:user_id, nil)
  	post.save.should eq(false)
  end

  describe "can be sorted by different attributes" do

  	it "sorts by age descending by default" do
  		posts = create_desc_timed_posts
  		Post.ordered_by().to_a.to_s.should == posts.sort_by { |p| p[:created_at]}.reverse.to_s
	end

  	

  	it "allows them to be sorted by title." do
  		posts = create_posts_unordered_by_title #array is ordered by created_at desc
  		Post.ordered_by("title").to_a.to_s.should eq(posts.sort_by(&:title).to_s)
  	end

  	it "allows them to be sorted by number of comments." do 
		posts = create_posts_w_rand_comments
		Post.ordered_by("comments").to_a.to_s.should eq(posts.sort_by{ |p| [p.comments_count, p.created_at] }.reverse.to_s)
    end
  
  end
end
