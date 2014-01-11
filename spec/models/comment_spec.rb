require 'spec_helper'

describe Comment do
  it "has comment counter assigned to Post" do
  	posts = create_posts
  	Post.all.length.should eq(3)
  	Post.where("comments_count > 0").length.should eq(0)
  	posts[0].comments.create(:body => "Body text for comment.")
  	Post.where("comments_count > 0").length.should eq(1)
  end
end
