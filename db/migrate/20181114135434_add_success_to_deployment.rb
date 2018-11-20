class AddSuccessToDeployment < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :success, :boolean
  end
end
