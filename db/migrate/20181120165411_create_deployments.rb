class CreateDeployments < ActiveRecord::Migration[5.2]
  def change
    create_table :deployments do |t|
      t.string :commit
      t.string :branch
      t.string :event_type
      t.string :source
      t.boolean :success
      t.text :log
      t.timestamps
    end
  end
end
