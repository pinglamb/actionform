require 'spec_helper'

describe 'With ActiveRecord' do
  it 'persists the underlying object when saving the form' do
    post = Post.new
    post_form = PostForm.new(post)
    post_form.submit(title: 'First Post', content: 'Hello World!')
    post_form.save
    expect(post).to be_persisted
    post.reload
    expect(post.title).to eq('First Post')
    expect(post.content).to eq('Hello World!')
  end
end
