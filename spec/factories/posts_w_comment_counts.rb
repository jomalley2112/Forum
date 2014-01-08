# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :posts_w_comment_count, :class => 'PostsWCommentCounts' do
    title "MyString"
    body "MyText"
    public false
    user_id 1
    comment_count 1
  end
end
