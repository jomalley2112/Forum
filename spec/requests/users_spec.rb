require 'spec_helper'

feature "Users" do
  describe "Public posts and any responses to them can be viewed by members and non members alike" do
    it "allows non-members on the site", :js => false do
     	visit root_path
     	page.should have_content("Current Posts")
    end

    it "shows public posts only on the posts page when user is not a member", :js => false do
      create_posts
      visit posts_index_path
      #binding.pry
      page.should have_content("Current Posts")
      page.should have_content("Post 1")
      page.should have_content("Post 3")
      page.should have_no_content("Post 2")
      
    end

    it "shows public post comments (responses) only... to non-members", :js => false do
    	create_posts_w_comments
    	visit posts_index_path
    	page.should have_content("This is a comment for post 'Post 1'")
    	page.should have_content("This is a comment for post 'Post 3'")
    	page.should have_no_content("This is a comment for post 'Post 2'")
    end

    it "has a way for members to view only their own posts" do
      posts = "cannot be edited by anyone other than the member that posted it"
      create_and_login_member_user
      @user.posts.create(:title => "#{@username}'s Test Post", :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Debitis, nihil")
      click_link("View your Posts")
      #visit user_posts_path(:id => @user.id)
      page.should have_content("Posted by #{@username}")
      page.should have_content("Lorem ipsum dolor sit amet")
      page.should have_no_content("In Post 1 we talk about")
    end

    it "shows only the posts belonging to a member when they first log in and also when they explicitly visit the posts index page" do
      create_and_login_member_user
      page.should have_content("Posted by #{@username}")
      visit posts_path #/index
      page.should have_content("Posted by #{@username}")
      visit root_url #/
      page.should have_content("Current Posts")
    end
    it "allows a logged-in member to view all posts" do
      create_and_login_member_user
      click_link("View all Posts")
      page.should have_content("Current Posts")
    end

  end

  

  describe "users can sign up to become members", :js => false do
  	it "has a member signup form" do
      visit root_url
      click_link("Become a member")
  		#visit signup_path
  		fill_in("Username", :with => "jomalley2112")
  		fill_in("Email", :with => "jom@nycap.rr.com")
  		fill_in("Password", :with => "password")
  		fill_in("Password confirmation", :with => "password")
  		click_button("Create User")
  		page.should have_content("Member signed up!")
  	end

  	it "forces user to confirm password when signing up", :js => false do
  		visit signup_path
  		
  		#First leave confirmation field blank
  		fill_in("Username", :with => "jomalley2112")
  		fill_in("Email", :with => "jom@nycap.rr.com")
  		fill_in("Password", :with => "password")
  		click_button("Create User")
  		page.should have_no_content("Member signed up!")
  		page.should have_content("Password confirmation can't be blank")
  		
  		#next enter a non-matching password
  		fill_in("Password", :with => "password")
  		fill_in("Password confirmation", :with => "wrong_password")
  		click_button("Create User")
  		page.should have_no_content("Member signed up!")
  		page.should have_content("Password confirmation doesn't match Password")

  		#now enter a matching password
  		fill_in("Password", :with => "password")
  		fill_in("Password confirmation", :with => "password")
  		click_button("Create User")
  		page.should have_content("Member signed up!")
  	end
  end

  describe "Members can log in" do
  	it "won't allow an invalid user to log in", :js => false do
  		visit login_path
  		fill_in("Username", :with => "invalid_user") 
  		fill_in("Password", :with => "invalid_user_password") 
  		click_button("Log in")
  		page.should have_content("Username or password was invalid")
  	end
  	it "won't allow a valid user to log in if they specify an invalid password", :js => false do
  		create_member_user
  		visit login_path
  		fill_in("Username", :with => "valid_user") 
  		fill_in("Password", :with => "invalid_password")
  		click_button("Log in")
  		page.should have_content("Username or password was invalid")
  	end
    it "will allow a member to login with the correct credentials" do
      create_member_user
      visit login_path
      fill_in("Username", :with => "valid_user") 
      fill_in("Password", :with => "valid_user_password")
      click_button("Log in")
      page.should have_content("Logged in!")
    end
  end

  describe "members can log out" do
  	it "allows a logged-in member to logout" do
    	create_posts
      create_and_login_member_user
    	page.should have_content("Posted by #{@username}")
  		click_link("Member log out")
  		page.should have_content("Logged out")
  		page.should have_content("Post 1") #now we're back to the public level 
  		page.should have_no_content("Post 2")
  	end
  end

  describe "Private posts and any responses to them can only be viewed by logged-in members" do
  	it "shows both public and private posts and comments to members", :js => false do
      create_posts_w_comments
      create_and_login_member_user
    	page.should have_content("Posted by #{@username}")
      click_link("View all Posts")
  		page.should have_content("Post 1")
  		page.should have_content("Post 3")
  		page.should have_content("Post 2")
  		page.should have_content("Comment 1:This is a comment for post 'Post 2'")
	 end
  end

  describe "Members can edit their email and password", :js => false do
  	it "allows members to update their email address" do
	  	create_and_login_member_user
	  	click_link("edit")
	  	fill_in("Email", :with => "updated_email@email.com")
	  	click_button("Save Email")
	  	page.should have_content("Member info updated")
	  	click_link("edit")
	  	page.first("input#email").value.should eq("updated_email@email.com")
    end
    it "allows members to change their password", :js => false do
	  	create_and_login_member_user
	  	click_link("edit")
	  	fill_in("New Password", :with => "new_password")
	  	fill_in("Confirm Password", :with => "new_password")
	  	click_button("Save Password")
	  	page.should have_content("Member info updated")
	  	#NOW LOG OUT AND TRY TO LOG BACK IN WITH NEW PWORD
	  	click_link("Member log out")
	  	click_link("Member log in")
	  	fill_in("Username", :with => @username)
	  	fill_in("Password", :with => "new_password")
	  	click_button("Log in")
	  	page.should have_content("Logged in!")
    end
  end

end
