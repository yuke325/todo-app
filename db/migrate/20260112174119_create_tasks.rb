# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.boolean :completed, default: false, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
