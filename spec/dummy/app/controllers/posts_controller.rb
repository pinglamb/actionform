class PostsController < ApplicationController
  before_action :build_post, only: %i(new create)
  before_action :set_post, only: %i(show edit update)
  before_action :set_form, only: %i(new create edit update)

  def index
    @posts = Post.all
  end

  def new
  end

  def create
    @form.assign_attributes(post_params)
    if @form.save
      redirect_to @post, notice: 'Post was created successfully.'
    else
      render action: 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    @form.assign_attributes(post_params)
    if @form.save
      redirect_to @post, notice: 'Post was updated successfully.'
    else
      render action: 'edit'
    end
  end

  private

  def build_post
    @post = Post.new
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_form
    @form = PostForm.new(@post)
  end

  def post_params
    params[:post]
  end
end
