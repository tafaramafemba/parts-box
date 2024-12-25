class AddReadToChats < ActiveRecord::Migration[7.2]
  def change
    add_column :chats, :read, :boolean
    add_column :chats, :default, :string
    add_column :chats, :false, :string
  end
end
