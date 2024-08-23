class CreateUserDisabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :candidate_disabilities do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :disability, null: false, foreign_key: true, index: true
      t.text :details

      t.timestamps
    end
    add_index :candidate_disabilities, [:user_id, :disability_id], unique: true

  end
end
