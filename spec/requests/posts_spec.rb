require 'spec_helper'

feature "Posts" do
  describe "posts can only be created or commented on by members", :js => false do
    it "redirects non-members and shows them a message when they attempt to create a post ", :js => false do
    	visit new_post_path
    	page.current_path.should_not eq(new_post_path)
    	page.should have_content("You must login before you can create or manage posts")
    end
    it "redirects non-members and shows them a message when they attempt to create a comment", :js => false do
    	posts = create_posts
    	visit new_post_comment_path(posts[0])
		  page.current_path.should_not eq(new_post_comment_path(posts[0]))
    	page.should have_content("You must login before you can add comments.")
    end
    it "can be created by a logged-in member" do
    	create_and_login_member_user
    	click_link("Create new Post")
    	fill_in("Title", :with => "Post Title")
    	fill_in("Body", :with => "This is the main body of the post")
    	uncheck("Public")
    	click_button("Submit Post")
    	page.should have_content("Congratulations your post has been posted to the Forum!")
    	page.should have_content("This is the main body of the post")
    end
    it "displays an error message when a user tries to submit one with more than 75 characters in the title" do
      create_and_login_member_user
      click_link("Create new Post")
      fill_in("Title", :with => "This is more than 75 characters. This is more than 75 characters. This is more than 75 characters. This is more than 75 characters.")
      fill_in("Body", :with => "This is the main body of the post")
      check("Public")
      click_button("Submit Post")
      page.should have_content("Unable to save new post.")
      page.should have_content("is too long (maximum is 75 characters)")
      fill_in("Title", :with => "This is less than 75 characters.")
      click_button("Submit Post")
      page.should have_content("Congratulations your post has been posted to the Forum!")
    end
    it "can be commented on by a logged-in member", :js => false do
    	#pending "Will need a comment link next to each post"
    	posts = create_posts
    	create_and_login_member_user
    	click_link("View all Posts")
    	all(:link, "add a comment")[0].click
      #binding.pry
    	page.should have_content("Add a comment to Post: '" + posts[0].title + "'")
    	fill_in("Comments", :with => "I have something to say about post #{posts[0].title}") 
    	click_button("Add comment")
    	page.should have_content("Your comment has been added")
    	#make sure its shown within (or just after) the correct post?
    end
  end

  describe "posts can only be deleted by the member that created them", :js => false do
  	

  	it "allows members to delete their own existing posts", :js => false do
  		create_and_login_member_user
    	click_link("Create new Post")
    	fill_in("Title", :with => "Post Title")
    	fill_in("Body", :with => "This is the main body of the post")
    	click_button("Submit Post")
    	click_link("View your Posts")
    	page.should have_content("This is the main body of the post")
    	click_link("delete post")
    	page.should have_no_content("This is the main body of the post")
    	page.should have_content("Posted by #{@username}") #make sure we go back to the user-specific post index page
    end

    it "redirects and shows a message when anyone but the post's owner attempts to delete it", :js => false do
    	posts = create_other_members_posts #posts by a different member
  		create_and_login_member_user
  		visit destroy_post_path(:id => posts[0].id)
  		page.should have_no_content("Post was deleted!")
  		page.should have_content("You don't have permission to delete the post")
    end

  end

  describe "posts can only be edited by the member that created them", :js => false do
  	it "can be edited by the member that posted it" do
    	create_and_login_member_user
    	click_link("Create new Post")
    	fill_in("Title", :with => "Post Title")
    	fill_in("Body", :with => "This is the main body of the post")
    	click_button("Submit Post")
    	click_link("View your Posts")
    	click_link("edit post")
    	fill_in("Title", :with => "Post Title... edited")
    	fill_in("Body", :with => "This is the main body of the post... edited")
    	uncheck("Public")
    	click_button("Submit Post")
    	page.should have_content("Post has been edited!")
    	page.should have_content("Posted by #{@username}") #make sure we go back to the user-specific post index page
    	page.should have_content("Post Title... edited")
    	page.should have_content("Private")
    	page.should have_content("This is the main body of the post... edited")
    end

    it "cannot be edited by anyone other than the member that posted it" do
    	posts = create_other_members_posts #posts by a different member
    	create_and_login_member_user
    	visit edit_post_path(posts[0])
    	page.should have_content("You do not have access to this post.")
    end
  end

  describe "Posts can be sorted by days old (default), number of responses,  or title by non-members" do
  	it "sorts by age descending by default for non-member", :js => false do
  		posts = create_desc_timed_posts #array is ordered by created_at desc
  		visit root_path
      page.should have_content("Current Posts")
  		post_elmnts = page.all(".post")
  		posts.each_with_index do |post, i|
  			post.title.should eq(post_elmnts[i].first("h4").text)
  		end
  	end
  	it "allows them to be sorted by title by non-member", :js => true do
  		posts = create_posts_unordered_by_title #array is ordered by created_at desc
  		visit root_path
      page.should have_content("Current Posts")
  		select("Title", :from => "Sort by")
  		post_elmnts = page.all(".post")
  		posts.sort_by!(&:title)
      posts.each_with_index do |post, i|
  			post.title.should eq(post_elmnts[i].first("h4").text)
  		end
  	end
  	it "allows them to be sorted by number of comments by non-member", :js => true do #NOTE: this test requires :js => true
  		posts = create_posts_w_rand_comments
      visit root_path
      page.should have_content("Current Posts")
      select("Comments", :from => "Sort by")
      #sleep 2
      post_elmnts = page.all("div.post")
      prev_comm_cnt = Integer
      post_elmnts.each_with_index do |pe, i|
        curr_comm_cnt = pe.first("div.comments_count").text.to_i
        curr_comm_cnt.should be <= prev_comm_cnt if i > 0
        prev_comm_cnt = curr_comm_cnt
      end
  	end
  end

  describe "Posts on the member-specific post index can be sorted by days old (default), number of responses,  or title by members" do
    it "sorts by age descending by default for member", :js => false do
      create_and_login_member_user
      posts = create_desc_timed_posts(@user) #array is ordered by created_at desc
      visit posts_path
      page.should have_content("Posted by #{@username}")
      post_elmnts = page.all(".post")
      posts.each_with_index do |post, i|
        post.title.should eq(post_elmnts[i].first("h4").text)
      end
    end
    it "allows them to be sorted by title by member", :js => true do
      create_and_login_member_user
      posts = create_posts_unordered_by_title(@user) #array is ordered by created_at desc
      visit posts_path
      page.should have_content("Posted by #{@username}")
      select("Title", :from => "Sort by")
      post_elmnts = page.all(".post")
      posts.sort_by!(&:title)
      posts.each_with_index do |post, i|
        post.title.should eq(post_elmnts[i].first("h4").text)
      end
    end
    it "allows them to be sorted by number of comments by member", :js => true do #NOTE: this test requires :js => true
      create_and_login_member_user
      posts = create_posts_w_rand_comments(@user)
      visit posts_path
      page.should have_content("Posted by #{@username}")
      select("Comments", :from => "Sort by")
      #sleep 2
      post_elmnts = page.all("div.post")
      prev_comm_cnt = Integer
      post_elmnts.each_with_index do |pe, i|
        curr_comm_cnt = pe.first("div.comments_count").text.to_i
        curr_comm_cnt.should be <= prev_comm_cnt if i > 0
        prev_comm_cnt = curr_comm_cnt
      end
    end
  end

  describe "Each member’s posts will display their username " do
    it "displays it's creators username" do
      create_and_login_member_user
      posts = create_posts_unordered_by_title(@user) #array is ordered by created_at desc
      visit root_path
      page.should have_content("Current Posts")
      post_elmnts = page.all("div.post")
      post_elmnts.each do |pe|
        pe.first("div.posted_by").text.should eq("posted by #{@username}")
      end
      
    end
  end

  describe "wherever usernames are displayed they should be links which, when clicked show all that member's posts", :js => false do
    it "links each post to it's creator's 'posted by' page" do
      create_and_login_member_user
      create_posts_unordered_by_title(@user)
      click_link("Member log out")
      page.should have_content("Current Posts")
      post_elmnts = page.all("div.post")
      post_elmnts.each do |pe|
        pe.first("div.posted_by").find(:link, "posted by #{@username}").click
        page.should have_content("Posted by #{@username}")
        visit root_path
      end
    end
  end

  describe "Searching Posts" do

    describe "The titles and bodies of posts can be searched" do
      describe "when a member searches... all matching posts (and comments) are searched, displayed and can be clicked on" do
        it "searches all post titles and bodies for the text entered", :js => true do
          create_other_members_posts #posts created by other user
          create_and_login_member_user
          click_link("View all Posts")
          fill_in('query', :with=> "Post 3" )
          find('#query').native.send_keys(:return)
          page.should have_content("1 post matched your search")
          fill_in('query', :with=> "we talk about" )
          find('#query').native.send_keys(:return)
          page.should have_content("3 posts matched your search")
        end
      end
      
      describe "When a non-member searches... all posts are searched, but just the titles are displayed for the private ones." do
        it "searches all post titles and bodies for the text entered", :js => true do
          create_posts
          visit(root_path)
          fill_in('query', :with=> "Post" )
          find('#query').native.send_keys(:return)
          page.should have_content("3 posts matched your search")
        end
        it "displays only the titles of private posts", :js => true do
          create_posts
          visit(root_path)
          fill_in('query', :with=> "Post" )
          find('#query').native.send_keys(:return)
          page.should have_content("In Post 1 we talk about...")
          page.should have_content("In Post 3 we talk about...")
          page.should have_content("Post 2")
          page.should have_no_content("In Post 2 we talk about...")
        end

        it "clears the search text and reloads the page when the clear 'X' button is clicked", :js => true do
          create_posts
          visit(root_path)
          fill_in('query', :with=> "3" )
          find('#query').native.send_keys(:return)
          page.should have_content("Post 3")
          page.should have_no_content("Post 1")
          page.should have_no_content("Post 2")
          page.first("i.close").click
          page.should have_content("Post 1")
          page.should have_content("Post 2")
          page.should have_content("Post 3")
        end

      end

    end
  end

  describe "When posts are over a certain length they get truncated with a link that allows 
            the rest of it to be displayed (in page) and re-hidden" do
    it "only shows the first X characters of the body text", :js => true do #:js needs to be true
      create_lengthy_post
      visit(root_path)
      #binding.pry
      full_body = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eum, eos, ad, natus iste sunt molestiae architecto quas cupiditate harum culpa ipsa fuga consequuntur quibusdam non tempore eius laborum placeat voluptas?"
      full_body += "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eum, eos, ad, natus iste sunt molestiae architecto quas cupiditate harum culpa ipsa fuga consequuntur quibusdam non tempore eius laborum placeat voluptas?"
      full_body += "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eum, eos, ad, natus iste sunt molestiae architecto quas cupiditate harum culpa ipsa fuga consequuntur quibusdam non tempore eius laborum placeat voluptas?"
      page.should have_no_css('div.body_text', :text => full_body, :visible => true)
    end

    it "allows the user to see the entire body text", :js => true do #:js needs to be true
      create_lengthy_post
      visit(root_path)
      full_body = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eum, eos, ad, natus iste sunt molestiae architecto quas cupiditate harum culpa ipsa fuga consequuntur quibusdam non tempore eius laborum placeat voluptas?"
      full_body += "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eum, eos, ad, natus iste sunt molestiae architecto quas cupiditate harum culpa ipsa fuga consequuntur quibusdam non tempore eius laborum placeat voluptas?"
      full_body += "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eum, eos, ad, natus iste sunt molestiae architecto quas cupiditate harum culpa ipsa fuga consequuntur quibusdam non tempore eius laborum placeat voluptas?"
      page.should have_no_css('div.body_text', :text => 'full_body', :visible => true)
      click_link("[more]")
      page.should have_css('div.body_text', :text => full_body, :visible => true)
    end

  end

end
