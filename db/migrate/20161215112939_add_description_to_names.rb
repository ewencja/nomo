class AddDescriptionToNames < ActiveRecord::Migration[5.0]
  def change
    add_column :names, :description, :string
  end
end
