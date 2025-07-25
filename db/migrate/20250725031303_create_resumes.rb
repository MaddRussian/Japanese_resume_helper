class CreateResumes < ActiveRecord::Migration[7.1]
  def change
    create_table :resumes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :summary
      t.boolean :translated

      t.timestamps
    end
  end
end
