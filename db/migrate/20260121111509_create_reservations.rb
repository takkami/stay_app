class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :check_in
      t.date :check_out
      t.integer :people
      t.integer :total_price

      t.timestamps
    end
  end
end
