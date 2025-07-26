class AddContactInfoToResumes < ActiveRecord::Migration[7.1]
  def change
    add_column :resumes, :address, :string
    add_column :resumes, :phone_number, :string
  end
end
