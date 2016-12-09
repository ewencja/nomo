class AddOccurenceToNames < ActiveRecord::Migration[5.0]
  def change
    add_column :names, :occurence, :string
  end
end
