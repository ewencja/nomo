class CreateFrequencies < ActiveRecord::Migration[5.0]
  def change
    create_table :frequencies do |t|
      t.integer :year
      t.integer :frequency
      t.references :name, foreign_key: true

      t.timestamps
    end
  end
end
