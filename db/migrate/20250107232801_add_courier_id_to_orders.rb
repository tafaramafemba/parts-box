class AddCourierIdToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :courier_id, :integer
  end
end
