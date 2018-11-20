class AddSourceToDeployment < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :source, :string
  end
end
