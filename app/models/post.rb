class Post < ActiveRecord::Base
	belongs_to :user
	has_many :comments
	validates_presence_of :user

	def self.ordered_by(param=nil)
		if param.nil?
			@posts = self.order('created_at desc, title')
		elsif param.downcase.eql?("title")
			@posts = self.order('title, created_at desc')
		elsif param.downcase.eql?("comments")
			@posts = self.order("comments_count desc")
		else
			@posts = self.order('created_at desc, title')
		end
    end
end
