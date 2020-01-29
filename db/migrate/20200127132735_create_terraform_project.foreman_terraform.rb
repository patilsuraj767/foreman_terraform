class CreateTerraformProject < ActiveRecord::Migration[5.2]
  def change
  	create_table :terraform_projects do |t|
      t.string :name, :null => false, :limit => 255, :unique => true
	end
  end
end
