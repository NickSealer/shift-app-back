class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.string :name
      t.string :monday, array: true, default: []
      t.string :tuesday, array: true, default: []
      t.string :wednesday, array: true, default: []
      t.string :thursday, array: true, default: []
      t.string :friday, array: true, default: []
      t.string :saturday, array: true, default: []
      t.string :sunday, array: true, default: []
      t.integer :total_hours, default: 0

      t.timestamps
    end

    add_index :services, :monday, using: 'gin'
    add_index :services, :tuesday, using: 'gin'
    add_index :services, :wednesday, using: 'gin'
    add_index :services, :thursday, using: 'gin'
    add_index :services, :friday, using: 'gin'
    add_index :services, :saturday, using: 'gin'
    add_index :services, :sunday, using: 'gin'
  end
end
