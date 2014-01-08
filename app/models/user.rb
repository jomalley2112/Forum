class User < ActiveRecord::Base
	has_many :posts

	#attr_accessible :email, :password, :password_confirmation, :is_member
	authenticates_with_sorcery!

	validates :username,                presence: true, uniqueness: true, on: :create
	validates :email,                   presence: true, uniqueness: true
    
    validates :password,                presence: true, confirmation: true, length: { minimum: 3}
    validates :password_confirmation,   presence: true

    def self.posts_ordered_by(user_id, param)
    	Post.ordered_by(param).where(:user_id => user_id)
    end

end
