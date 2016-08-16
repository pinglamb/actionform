require 'spec_helper'

describe ActionForm::Associations do
  describe 'has_many association' do
    it 'creates nested record' do
      @post = Post.new
      @post_form = PostForm.new(@post)
      @post_form.submit({
        title: 'First Post',
        slug: 'first-post',
        content: 'Hello World!',
        comments_attributes: {
          '0' => { body: 'Cool' }
        }
      })
      expect {
        @post_form.save
        expect(@post).to be_persisted
        @comment = @post.comments.first
        expect(@comment.post).to eq(@post)
        expect(@comment.body).to eq('Cool')
      }.to change(Comment, :count).by(1)
    end

    describe 'with existing nested records' do
      before :each do
        @post = Post.create title: 'First Post', slug: 'first-post', content: 'Hello World!'
        @comment = @post.comments.create body: 'Nice!'
        @post_form = PostForm.new(@post)
      end

      it 'updates that if found' do
        @post_form.submit({
          comments_attributes: {
            @comment.id.to_s => { id: @comment.id.to_s, body: 'Awesome!' }
          }
        })
        expect {
          @post_form.save
          expect(@comment.reload.body).to eq('Awesome!')
        }.not_to change(Comment, :count)
      end

      it 'deletes that if _destroy' do
        @post_form.submit({
          comments_attributes: {
            @comment.id.to_s => { id: @comment.id.to_s, _destroy: '1' }
          }
        })
        expect {
          @post_form.save
          expect(@comment).to be_destroyed
        }.to change(@post.comments, :count).by(-1)
      end

      it 'works fine while mixing with different operations' do
        @comment2 = @post.comments.create body: 'Awesome!'
        @post_form.submit({
          comments_attributes: {
            @comment.id.to_s => { id: @comment.id.to_s, body: 'Nice! Yeah' },
            @comment2.id.to_s => { id: @comment2.id.to_s, _destroy: '1' },
            '1471373511437' => { body: 'New Comment 1' },
            '1471373511438' => { body: 'Another New Comment 2' }
          }
        })
        expect {
          @post_form.save
          expect(@post.comments.pluck(:body)).to match_array([
            'Nice! Yeah',
            'New Comment 1',
            'Another New Comment 2'
          ])
          expect(@comment2).to be_destroyed
        }.to change(@post.comments, :count).by(1)
      end
    end
  end
end
