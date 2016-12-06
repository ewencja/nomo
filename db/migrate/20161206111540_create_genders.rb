class CreateGenders < ActiveRecord::Migration[5.0]
  def change
    create_table :genders do |t|
      t.string :name
      t.references :name, foreign_key: true

      t.timestamps
    end
  end
end
