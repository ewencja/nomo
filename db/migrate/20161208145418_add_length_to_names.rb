class AddLengthToNames < ActiveRecord::Migration[5.0]
  def change
    add_column :names, :length, :string
  end
end
