require 'spec_helper'

describe 'With ActiveRecord' do
  it 'validates both the form object and underlying object and merges the errors' do
    post = Post.new
    post_form = PostForm.new(post)
    post_form.submit(title: 'First Post')
    post_form.save
    expect(post).not_to be_persisted
    expect(post_form.errors.size).to eq(2)
    expect(post_form.errors.details[:content]).to eq([{error: :blank}])
    expect(post_form.errors.details[:slug]).to eq([{error: :blank}])
  end
end
