class CreateAdminHourlyRates < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_hourly_rates do |t|
      t.string :level
      t.integer :years_experience
      t.float :rate

      t.timestamps
    end
  end
end
