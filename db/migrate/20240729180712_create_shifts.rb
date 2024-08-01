class CreateShifts < ActiveRecord::Migration[7.1]
  def change
    create_table :shifts do |t|
      t.integer :week
      t.integer :year
      t.boolean :confirmed, default: false
      t.references :service, null: false, foreign_key: true
      t.bigint :admin_id, null: false
      t.jsonb :data, default: '{}'

      t.timestamps
    end

    add_index :shifts, :admin_id
    add_index :shifts, :data, using: :gin
  end
end
