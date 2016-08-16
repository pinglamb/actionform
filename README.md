# ActionForm

Form object is not just a good way of refactoring Fat Model, but also useful for decoupling the form related logic from the ActiveRecord model. For this project, I have 4 goals to achieve:

- Free ActiveRecord from `accepts_nested_attributes_for`, nested form definition should be in ActionForm
- Auto permit params according to your form definition
- Form specific validations and callbacks to prevent polluting the model with `if/unless` cases
- Allow defining virtual attributes on form object for triggering form specific actions

## Installation

Put this in your `Gemfile` and run `bundle install`.

```RUBY
gem 'actionform', github: 'pinglamb/actionform'
```

## Form Definition

In `app/forms/post_form.rb`,

```RUBY
class PostForm < ActionForm::Base
  attributes :title, :content
  attribute :publish, virtual: true
  
  has_many :comments, allow_destroy: true, reject_if: :all_blank
end
```

In your controller (e.g. `app/controllers/posts_controller.rb`),

```RUBY
class PostsController < ApplicationController
  before_action :build_post, only: %i(new create)
  before_action :set_form, only: %i(new create)
  
  def new
  end
  
  def create
    @form.submit(params[:post])
    if @form.save
      redirect_to @post, notice: 'Post was created successfully.'
    else
      render action: 'new'
    end
  end
  
  private
  
  def build_post
    @post = Post.new
  end
  
  def set_form
    @form = PostForm.new(@post)
  end
end
```

In your view (e.g. `app/views/posts/_form.html.slim`),

```SLIM
= form_for @form do |f|
  = f.text_field :title
  = f.text_area :content
  = f.submit
```

## Dynamic Nested Form

This gem doesn't have the javascript for adding/removing nested fields. If you want that, the form object works well with [nathanvda/cocoon](https://github.com/nathanvda/cocoon).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pinglamb/actionform.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

