class CreateLanguages < ActiveRecord::Migration[7.1]
  def change
    create_table :languages do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :languages, :name, unique: true
  end
end
