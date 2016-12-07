class AddFrequencyToName < ActiveRecord::Migration[5.0]
  def change
    add_column :names, :frequency, :integer
  end
end
