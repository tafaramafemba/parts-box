class CreateDeliverySlots < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_slots do |t|
      t.time :time
      t.integer :cutoff

      t.timestamps
    end
  end
end
