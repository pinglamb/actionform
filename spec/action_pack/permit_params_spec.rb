require 'spec_helper'

describe 'With ActionPack' do
  it 'permits params according to attribute definition' do
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

  it 'permits nested params according to association definition' do
    params = ActionController::Parameters.new({
      comments_attributes: {
        '1471373511437' => { body: 'comment', _destroy: false }
      }
    })
    form = PostForm.new(Post.new)
    form.submit(params)
    expect(form.comments.size).to eq(1)
    expect(form.comments.first.body).to eq('comment')
  end
end
