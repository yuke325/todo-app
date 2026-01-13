require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { FactoryBot.build(:task) }

  describe '#title' do
    context '空白のとき' do
      before { task.title = '' }
      it '無効であること' do
        expect(task).to be_invalid
        expect(task.errors[:title]).to include("can't be blank")
      end
    end

    context '51文字以上のとき' do
      before { task.title = 'a' * 51 }
      it '無効であること' do
        expect(task).to be_invalid
        expect(task.errors[:title]).to include('is too long (maximum is 50 characters)')
      end
    end
  end

  describe '#user' do
    context '紐づくユーザーがいないとき' do
      before { task.user = nil }
      it '無効であること' do
        expect(task).to be_invalid
        expect(task.errors[:user]).to include('must exist')
      end
    end
  end
end
