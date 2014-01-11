module InitMacros
	def create_posts(user=nil)
		create_member_user unless user
		user ||= @user
		posts = []
		posts << FactoryGirl.create(:post, :user_id => user.id, :title => "Post 1", :body => "In Post 1 we talk about...", :public => true) 
	    posts << FactoryGirl.create(:post, :user_id => user.id, :title => "Post 2", :body => "In Post 2 we talk about...", :public => false) 
	    posts << FactoryGirl.create(:post, :user_id => user.id, :title => "Post 3", :body => "In Post 3 we talk about...", :public => true) 
	end

	def create_lengthy_post(user=nil)
		create_member_user unless user
		user ||= @user
		body_text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eum, eos, ad, natus iste sunt molestiae 
		architecto quas cupiditate harum culpa ipsa fuga consequuntur quibusdam non tempore eius laborum placeat voluptas?"
		body_text += "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eum, eos, ad, natus iste sunt molestiae 
		architecto quas cupiditate harum culpa ipsa fuga consequuntur quibusdam non tempore eius laborum placeat voluptas?"
		body_text += "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eum, eos, ad, natus iste sunt molestiae 
		architecto quas cupiditate harum culpa ipsa fuga consequuntur quibusdam non tempore eius laborum placeat voluptas?"
		FactoryGirl.create(:post, :user_id => user.id, :title => "Lengthy Post", :body => body_text, :public => true)
	end

	# def create_anon_posts
	# 	posts = []
	# 	posts << FactoryGirl.create(:post, :title => "Post 1", :body => "In Post 1 we talk about...", :public => true) 
	#     posts << FactoryGirl.create(:post, :title => "Post 2", :body => "In Post 2 we talk about...", :public => false) 
	#     posts << FactoryGirl.create(:post, :title => "Post 3", :body => "In Post 3 we talk about...", :public => true) 
	# end

	def create_other_members_posts
		posts = []
		other_user = create_other_member_user
		posts << FactoryGirl.create(:post, :user_id => other_user.id, :title => "Post 1", :body => "In Post 1 we talk about...", :public => true) 
	    posts << FactoryGirl.create(:post, :user_id => other_user.id, :title => "Post 2", :body => "In Post 2 we talk about...", :public => false) 
	    posts << FactoryGirl.create(:post, :user_id => other_user.id, :title => "Post 3", :body => "In Post 3 we talk about...", :public => true)
	end

	def create_other_member_user
		username = "other_valid_user"
	    password = "valid_user_password"
	    user = User.new :username => username, :email => "Testing@other123.com", :password => password, :password_confirmation => password
	    user.save
	    return user
	end

	def create_posts_w_comments(user=nil)
		create_member_user unless user
		user ||= @user
		posts = create_posts(user) #TODO: We may need to come back to this when we add coments belong_to user
		posts.each do |post|
			post.comments.create(:body => "This is a comment for post '#{post.title}'")
		end
	end

	def create_posts_w_random_comments(user=nil)
		create_member_user unless user
		user ||= @user
		posts = create_posts(user) #TODO: We may need to come back to this when we add coments belong_to user
		posts.each do |post|
			rand(0..10).upto(10).each_with_index do |n, i|
				post.comments.create(:body => "This comment #{i} for post '#{post.title}'")
			end
		end
		return posts
	end

	def create_member_user
		#@user = FactoryGirl.create(:user)
		@username = "valid_user"
	    @password = "valid_user_password"
	    @user = User.new :username => @username, :email => "Testing@123.com", :password => @password, :password_confirmation => @password
	    @user.save
	    
	end

	

	def create_and_login_member_user
		create_member_user
		#login_user() #This is a Sorcery method that doesn't seem to work
		login_forum_user 
	end

	def login_forum_user #so no name clash with the non-working sorcery "login_user" method
		visit login_path
  		fill_in("Username", :with => @username) 
  		fill_in("Password", :with => @password) 
  		click_button("Log in")
	end

	def create_desc_timed_posts(user=nil)
		create_member_user unless user
		user ||= @user
		posts = []
		4.downto(0).each do |i|
			rand_num = SecureRandom.hex(5).to_s #r.rand(1..100)
			posts[i] = FactoryGirl.create(:post, :user_id => user.id, :title => "Post #{rand_num}", :body => "In Post #{rand_num} we talk about...", :public => true)
			sleep 1
		end
		return posts
	end

	def create_posts_unordered_by_title(user=nil)
		create_member_user unless user
		user ||= @user
		posts = []
		posts << FactoryGirl.create(:post, :user_id => user.id, :title => "Post 5", :body => "In Post 5 we talk about...", :public => true) 
	    posts << FactoryGirl.create(:post, :user_id => user.id, :title => "Post 3", :body => "In Post 3 we talk about...", :public => true) 
	    posts << FactoryGirl.create(:post, :user_id => user.id, :title => "Post 6", :body => "In Post 6 we talk about...", :public => true) 
	    posts << FactoryGirl.create(:post, :user_id => user.id, :title => "Post 1", :body => "In Post 1 we talk about...", :public => true) 
	    posts << FactoryGirl.create(:post, :user_id => user.id, :title => "Post 2", :body => "In Post 2 we talk about...", :public => true) 
	    posts << FactoryGirl.create(:post, :user_id => user.id, :title => "Post 4", :body => "In Post 4 we talk about...", :public => true)
	end

	def create_posts_w_rand_comments(user=nil)
		create_member_user unless user
		user ||= @user
		posts = []
		1.upto(5) do |i|
			post = FactoryGirl.build(:post, :user_id => user.id, :title => "Post #{i}", :body => "In Post #{i} we talk about...", :public => true)
			r = rand(1..7)
			r.upto(5).each do |i|
				post.comments.build(:body => "This comment #{i} for post '#{post.title}'")
			end
			post.save
			posts << post.reload
		end
		return posts
	end
	
		
	
end