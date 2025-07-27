class AddInstitutionTypeToEducations < ActiveRecord::Migration[7.1]
  def change
    add_column :educations, :institution_type, :string
  end
end
