class CreateBrands < ActiveRecord::Migration[6.1]
  def change
    enable_extension "citext"
    create_table :brands do |t|
      t.citext :name, index: { unique: true }

      t.timestamps
    end
  end
end
