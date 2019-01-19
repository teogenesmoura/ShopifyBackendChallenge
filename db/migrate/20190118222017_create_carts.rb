class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.string :title
      t.float :total_amount

      t.timestamps
    end
  end
end
