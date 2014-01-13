class Post < ActiveRecord::Base
	belongs_to :user
	has_many :comments
	validates_presence_of :user
	validates :title, :length => {in: 1..75, :allow_nil => false}


	def self.ordered_by(param=nil)
		if param.nil?
			@posts = self.order('created_at desc, title')
		elsif param.downcase.eql?("title")
			@posts = self.order('title, created_at desc')
		elsif param.downcase.eql?("comments")
			@posts = self.order("comments_count desc, created_at desc")
		else
			@posts = self.order('created_at desc, title')
		end
    end

    def self.public_only
    	where(:public => 1)
    end

	# def self.for_user(id)
	# 	where(:user_id => id)
	# end

	def self.for_search(qry_str)
		where("(title like '%#{qry_str}%' or body like '%#{qry_str}%')")
	end


end
