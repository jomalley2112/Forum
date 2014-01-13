class CommentsController < ApplicationController
  def new
    redirect_to(root_url, :alert => "You must login before you can add comments.") and return unless current_user
  	@post = Post.find(params[:post_id])
  	@comment = @post.comments.build
  end

  def create
    redirect_to(root_url, :alert => "You must login before you can add comments.") and return unless current_user
  	@post = Post.find(params[:post_id])
  	@comment = @post.comments.build(params.require(:comment).permit(:body))
  	if @comment.save
  		redirect_to root_url, :notice => "Your comment has been added"
  	else
  		flash.now.alert = "Unable to save your comment"
  		render :new
  	end
  end

  def edit
  end
end
