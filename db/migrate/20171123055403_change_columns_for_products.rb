class ChangeColumnsForProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :category
    add_column :products, :category, :integer, index: true
  end
end
