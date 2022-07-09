class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.string :refresh_token_digest, null: false
      t.string :ip
      t.string :user_agent
      t.boolean :logged_out, null: false, default: false

      t.timestamps
    end
  end
end
