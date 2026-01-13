require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#name' do
    let(:user) { FactoryBot.build(:user, name: name) }

    context '正常な値のとき' do
      let(:name) { 'Test User' }
      it '有効であること' do
        expect(user).to be_valid
      end
    end

    context '空白のとき' do
      let(:name) { '' }
      it '無効であること' do
        expect(user).to be_invalid
        expect(user.errors[:name]).to include("can't be blank")
      end
    end

    context '51文字以上のとき' do
      let(:name) { 'a' * 51 }
      it '無効であること' do
        expect(user).to be_invalid
        expect(user.errors[:name]).to include('is too long (maximum is 50 characters)')
      end
    end
  end

  describe '#email' do
    let(:user) { FactoryBot.build(:user, email: email) }

    context '空白のとき' do
      let(:email) { '' }
      it '無効であること' do
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("can't be blank")
      end
    end

    context '256文字以上のとき' do
      let(:email) { 'a' * 244 + '@example.com' }
      it '無効であること' do
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('is too long (maximum is 255 characters)')
      end
    end

    context 'フォーマットが不正なとき' do
      let(:email) { 'user@example,com' }
      it '無効であること' do
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('is invalid')
      end
    end

    context '重複しているとき' do
      let(:email) { 'duplicate@example.com' }

      before do
        FactoryBot.create(:user, email: email)
      end

      it '無効であること' do
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('has already been taken')
      end
    end

    context '大文字や前後の空白が含まれるとき' do
      let(:email) { '  UseR@ExAMPle.CoM  ' }

      it '小文字化され、空白が除去されること' do
        expect(user.email).to eq 'user@example.com'
      end
    end
  end

  describe '#tasks' do
    let(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, user: user) }

    context 'ユーザーが削除されたとき' do
      it '紐づくタスクも削除されること' do
        expect { user.destroy }.to change(Task, :count).by(-1)
      end
    end
  end
end
