require 'spec_helper'

feature "Comments" do
  describe "The number of comments is displayed for each post" do
    it "shows the number of comments with each post", :js => false do
      posts = create_posts_w_random_comments
      create_and_login_member_user
      visit root_path
      page.should have_content("Current Posts")
      comm_cnt_elmnts = page.all("div.comments_count")
      posts.each_with_index do |post, i|
      	comm_cnt_elmnts[i].text.to_i.should eq(post.reload.comments.size)
      end
    end
  end
end
