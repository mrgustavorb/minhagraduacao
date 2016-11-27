class AddViewsToInstitutions < ActiveRecord::Migration
  def change
  	add_column :institutions, :views, :integer, default: 0
  end
end
