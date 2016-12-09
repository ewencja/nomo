class RemoveFrequencyFromNames < ActiveRecord::Migration[5.0]
  def change
    remove_column :names, :frequency, :integer
  end
end
