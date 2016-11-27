class AddInstitutionsNumbersToGraduationGroups < ActiveRecord::Migration
  def change
    add_column :graduation_groups, :institutions_numbers, :integer, default: 0
  end
end
