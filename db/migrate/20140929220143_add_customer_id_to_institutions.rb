class AddCustomerIdToInstitutions < ActiveRecord::Migration
  def up
    if column_exists?(:institutions, :customer_id)
      remove_column :institutions, :customer_id
      add_reference :institutions, :customer, index: true
    else
      add_reference :institutions, :customer, index: true
    end
  end

  def down
    remove_column :institutions, :customer_id if column_exists?(:institutions, :customer_id)
  end
end
