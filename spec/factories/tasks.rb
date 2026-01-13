FactoryBot.define do
  factory :task do
    title { 'タスクのタイトル' }
    association :user
  end
end
