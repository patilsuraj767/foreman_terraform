class TerraformCreateEnvironemntTable < ActiveRecord::Migration[5.2]
  def change
  	create_table :terraform_environments do |t|
      t.string :name, :null => false, :limit => 255, :unique => true
      t.belongs_to :terraform_project
	end
  end
end
