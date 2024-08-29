class CreateCandidateLanguages < ActiveRecord::Migration[7.1]
  def change
    create_table :candidate_languages do |t|
      t.references :candidate, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end

    add_index :candidate_languages, [:candidate_id, :language_id], unique: true
  end
end
