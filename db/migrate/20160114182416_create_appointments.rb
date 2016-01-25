class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.date :date, null: false
      t.time :time, null: false
      t.string :comment

      t.timestamps null: false
    end
  end
end
