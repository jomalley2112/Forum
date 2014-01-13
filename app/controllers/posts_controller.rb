class PostsController < ApplicationController
  def index
    scope = Post.all
    if qry_str = params[:query]
      @searched = true #let the view know its from a search
      scope = Post.for_search(qry_str)
    end
    if current_user && current_user.is_member
      @member = true
      if request.fullpath.gsub(/\/\?.*/, "").split("/").length > 1 && params[:user_id].nil?
        #if there's anything passed to the root other than a ?-delimited param set then it must be trying to go to user-specific posts
        redirect_to user_posts_path(params) and return
      end
    elsif !@searched
      scope = Post.public_only
    else
      scope = scope.where(false) #catch all for security...probably not needed
    end
    if @for_user_id = params[:user_id]
      scope = scope.where(:user_id => @for_user_id) #Post.for_user(@for_user_id)
    end
    @posts = scope.ordered_by(params[:sort_by])
    @search_form_action = root_url
    flash.now.notice = view_context.pluralize(@posts.size, "post") + " matched your search" if @searched
  end

  def user_posts
    if qry_str = params[:query]
      @searched = true
      conditions = "title like '%#{qry_str}%' or body like '%#{qry_str}%' "
    else
      conditions = "1=1"
    end
    @user = current_user #this is used in view
    @posts = User.posts_ordered_by(current_user.id, params[:sort_by]).where(conditions)
    @search_form_action = user_posts_path
    flash.now.notice = view_context.pluralize(@posts.size, "post") + " matched your search" if @searched
    render :index
  end

  # def show
  # end

  def edit
    @post = Post.find(params[:id])
    redirect_to(posts_path, :notice => "You do not have access to this post.") and return unless @post.user == current_user
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params.require(:post).permit(:title, :body, :public))
      redirect_to user_posts_path(), :notice => "Post has been edited!"
    else
      flash_alert(@post, "Unable to edit post.")
      render :edit
    end
  end

  def new
    redirect_to(root_url, :alert => "You must login before you can create or manage posts") and return unless current_user
    @post = current_user.posts.build
  end

  def create
    redirect_to(root_url) and return if !current_user
    @post = current_user.posts.build(params.require(:post).permit(:title, :body, :public))
    if @post.save
      redirect_to posts_path, :notice => "Congratulations your post has been posted to the Forum!"
    else
      flash_alert(@post, "Unable to save new post.")
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])
    redirect_to(posts_path, :alert => "You don't have permission to delete the post") and return unless @post.user == current_user
    @post.destroy
    redirect_to user_posts_path(), :notice => "Post was deleted!"
  end

  

end
