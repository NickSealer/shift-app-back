class CreateAssigments < ActiveRecord::Migration[7.1]
  def change
    create_table :assigments do |t|
      t.belongs_to :user
      t.belongs_to :service
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
