class PostsController < ApplicationController
  def index
    if current_user && current_user.is_member
      if request.fullpath != "/"
        redirect_to user_posts_path(params) and return
      else
        conditions = "1=1"
      end
    else
      conditions = "public = 1"
    end
    @for_user_id = params[:user_id]
    conditions += @for_user_id ?  " and user_id = #{@for_user_id}" : ""
    if qry_str = params[:query]
      @searched = true
      conditions += " and (title like '%#{qry_str}%' or body like '%#{qry_str}%')"
    else
      conditions += " and 1=1"
    end
    @posts = Post.ordered_by(params[:sort_by]).where(conditions)
  end

  def user_posts
    if qry_str = params[:query]
      @searched = true
      conditions = "title like '%#{qry_str}%' or body like '%#{qry_str}%' "
    else
      conditions = "1=1"
    end
    #WE Should ALWAYS HAVE A REAL USER HERE
    @user = current_user #this is used in view
    @posts = User.posts_ordered_by(current_user.id, params[:sort_by]).where(conditions)
    flash.now.notice = view_context.pluralize(@posts.size, "post") + " matched your search" if @searched
    render :index
  end

  def show
  end

  def edit
    @post = Post.find(params[:id])
    redirect_to(posts_path, :notice => "You do not have access to this post.") and return unless @post.user == current_user
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params.require(:post).permit(:title, :body, :public))
      redirect_to user_posts_path(), :notice => "Post has been edited!"
    else
      flash.now.notice = "Unable to edit post."
      render :edit
    end
  end

  def new
    redirect_to(root_url, :alert => "You must login before you can create or manage posts") and return unless current_user
    @post = current_user.posts.build #Post.new
  end

  def create
    redirect_to(root_url) and return if !current_user
    @post = current_user.posts.build(params.require(:post).permit(:title, :body, :public))
    if @post.save
      redirect_to posts_path, :notice => "Congratulations your post has been posted to the Forum!"
    else
      flash.now.notice = "Unable to save new post."
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])
    redirect_to(posts_path, :alert => "You don't have permission to delete the post") and return unless @post.user == current_user
    @post.destroy
    redirect_to user_posts_path(), :alert => "Post was deleted!"
  end

  

end
