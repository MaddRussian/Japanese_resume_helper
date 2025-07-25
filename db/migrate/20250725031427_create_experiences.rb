class CreateExperiences < ActiveRecord::Migration[7.1]
  def change
    create_table :experiences do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :company_name
      t.string :title
      t.date :start_date
      t.date :end_date
      t.text :description

      t.timestamps
    end
  end
end
