require 'spec_helper'

describe 'With ActionPack' do
  it 'permits params according to form definition' do
    params = ActionController::Parameters.new({
      title: 'Hello',
      content: 'Hello World!',
      secret: 'xxxxxx'
    })
    form = PostForm.new(Post.new)
    form.submit(params)
    expect(form.title).to eq('Hello')
    expect(form.content).to eq('Hello World!')
  end
end
