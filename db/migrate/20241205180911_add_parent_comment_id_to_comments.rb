class AddParentCommentIdToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :parent_comment_id, :integer
    add_index :comments, :parent_comment_id
  end
end
