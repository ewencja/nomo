class AddGenderToNames < ActiveRecord::Migration[5.0]
  def change
    add_column :names, :gender, :string
  end
end
