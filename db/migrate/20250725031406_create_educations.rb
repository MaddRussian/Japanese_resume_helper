class CreateEducations < ActiveRecord::Migration[7.1]
  def change
    create_table :educations do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :school_name
      t.string :degree
      t.string :field
      t.date :start_date
      t.date :end_date
      t.text :description

      t.timestamps
    end
  end
end
