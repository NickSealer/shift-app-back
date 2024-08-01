class CreateDays < ActiveRecord::Migration[7.1]
  def change
    create_table :days do |t|
      t.date :date
      t.string :day_name
      t.string :time
      t.boolean :available, default: false
      t.references :availability, null: false, foreign_key: true

      t.timestamps
    end
  end
end
