class CreateCertifications < ActiveRecord::Migration[7.1]
  def change
    create_table :certifications do |t|
      t.string :name
      t.date :completion_date
      t.references :resume, null: false, foreign_key: true

      t.timestamps
    end
  end
end
