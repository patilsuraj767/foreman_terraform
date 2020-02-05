class TerraformCreateModuleTable < ActiveRecord::Migration[5.2]
  def change
  	create_table :terraform_modules do |t|
      t.string :name, :null => false, :limit => 255, :unique => true
	end
  end
end
