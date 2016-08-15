require 'spec_helper'

describe ActionForm::Associations do
  describe 'has_many association' do
    it 'creates nested record' do
      post = Post.new
      post_form = PostForm.new(post)
      post_form.submit({
        title: 'First Post',
        slug: 'first-post',
        content: 'Hello World!',
        comments_attributes: {
          '0' => { body: 'Cool' }
        }
      })
      expect {
        post_form.save
        expect(post).to be_persisted
        comment = post.comments.first
        expect(comment.post).to eq(post)
        expect(comment.body).to eq('Cool')
      }.to change(Comment, :count).by(1)
    end
  end
end
