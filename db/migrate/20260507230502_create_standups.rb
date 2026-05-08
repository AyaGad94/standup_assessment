class CreateStandups < ActiveRecord::Migration[8.1]
  def change
    create_table :standups do |t|
      t.references :user, null: false, foreign_key: true
      t.text :worked_on_yesterday
      t.text :plan_for_today
      t.text :blockers
      t.boolean :needs_help
      t.date :created_at_date

      t.timestamps
    end
  end
end
