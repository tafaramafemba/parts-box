class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.integer :chat_id, null: false
      t.integer :sender_id, null: false
      t.text :body, null: false
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
