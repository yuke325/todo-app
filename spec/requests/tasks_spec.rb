require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user) }

  shared_examples 'バリデーションエラー' do |error_message|
    it 'HTTPステータス 422 を返し、エラーメッセージを表示すること' do
      subject
      expect(response).to have_http_status(:unprocessable_content)
      expect(CGI.unescapeHTML(response.body)).to include(error_message)
    end
  end

  describe 'GET /tasks' do
    it 'HTTPステータス 200 を返す' do
      get tasks_path
      expect(response).to have_http_status(200)
    end

    it '作成日時の降順でタスクが表示されること' do
      old_task = FactoryBot.create(:task, user: user, created_at: 1.day.ago)
      new_task = FactoryBot.create(:task, user: user, created_at: 1.day.from_now)

      get tasks_path

      expect(response.body).to include(new_task.title)
      expect(response.body).to include(task.title)
      expect(response.body).to include(old_task.title)
    end

    it '完了済みのタスクには取り消し線が表示されること' do
      FactoryBot.create(:task, user: user, completed: true)
      get tasks_path
      expect(response.body).to include('line-through')
    end
  end

  describe 'GET /tasks/new' do
    it 'HTTPステータス 200 を返す' do
      get new_task_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /tasks' do
    context '有効なパラメータの場合' do
      let(:valid_params) { { task: { title: '新しいタスク' } } }

      it 'タスクを作成できること' do
        expect do
          post tasks_path, params: valid_params
        end.to change(Task, :count).by(1)
      end

      it 'タスク一覧にリダイレクトすること' do
        post tasks_path, params: valid_params
        expect(response).to redirect_to(tasks_path)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) { { task: { title: '' } } }
      subject { post tasks_path, params: invalid_params }

      it 'タスクを作成しないこと' do
        expect { subject }.not_to change(Task, :count)
      end

      it_behaves_like 'バリデーションエラー', "Title can't be blank"
    end

    context 'タイトルが50文字を超えている場合' do
      let(:long_params) { { task: { title: 'a' * 51 } } }
      subject { post tasks_path, params: long_params }

      it 'タスクを作成しないこと' do
        expect { subject }.not_to change(Task, :count)
      end

      it_behaves_like 'バリデーションエラー', 'Title is too long (maximum is 50 characters)'
    end
  end

  describe 'GET /tasks/:id/edit' do
    it 'HTTPステータス 200 を返す' do
      get edit_task_path(task)
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH /tasks/:id' do
    context '有効なパラメータの場合' do
      let(:valid_params) { { task: { title: '更新後のタイトル' } } }

      it 'タスクを更新できること' do
        patch task_path(task), params: valid_params
        expect(task.reload.title).to eq('更新後のタイトル')
      end

      it 'タスクの完了状態を更新できること' do
        patch task_path(task), params: { task: { completed: true } }
        expect(task.reload.completed).to be true
      end

      it 'タスク一覧にリダイレクトすること' do
        patch task_path(task), params: valid_params
        expect(response).to redirect_to(tasks_path)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) { { task: { title: '' } } }
      subject { patch task_path(task), params: invalid_params }

      it 'タスクを更新できないこと' do
        expect { subject }.not_to(change { task.reload.title })
      end

      it_behaves_like 'バリデーションエラー', "Title can't be blank"
    end

    context 'タイトルが50文字を超えている場合' do
      let(:long_params) { { task: { title: 'a' * 51 } } }
      subject { patch task_path(task), params: long_params }

      it 'タスクを更新しないこと' do
        expect { subject }.not_to(change { task.reload.title })
      end

      it_behaves_like 'バリデーションエラー', 'Title is too long (maximum is 50 characters)'
    end
  end

  describe 'DELETE /tasks/:id' do
    it 'タスクを削除できること' do
      expect do
        delete task_path(task)
      end.to change(Task, :count).by(-1)
    end

    it 'タスク一覧にリダイレクトすること' do
      delete task_path(task)
      expect(response).to redirect_to(tasks_path)
    end
  end
end

