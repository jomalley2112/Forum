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
      #binding.pry
      #TODO: This is really ugly. Can't seem to sort an array by two dimensions in descending order...therefore I'm not sure how to simulate
      # SQL's "comments_count desc, created_at desc" syntax for an array...so I just worry about the first dimension which is comments_count
  		#Post.ordered_by("comments").pluck(:comments_count).to_a.should eq(posts.sort_by{ |p| [p.comments_count, p.created_at] }.reverse.map {|p| p.comments_count})
      ordered_posts = Post.ordered_by("comments")
      prev_comm_cnt = Integer
        ordered_posts.each_with_index do |post, i|
          curr_comm_cnt = post.comments_count
          curr_comm_cnt.should be <= prev_comm_cnt if i > 0
          prev_comm_cnt = curr_comm_cnt
        end
    end
  end

  describe "Only allows non-members to view the public ones when they aren't searching" do
    it "displays just the public ones" do
      create_posts
      posts = Post.public_only
      #binding.pry
      posts.any? {|p| p[:public] != true }.should eq(false)
    end
  end
  describe "Is searchable by title and body text" do
    it "displays the ones where the search criteria is found within the title or the body" do
      create_posts
      Post.for_search("Post").length.should eq(3)
      Post.for_search("Post 1").length.should eq(1)
    end
  end
end
