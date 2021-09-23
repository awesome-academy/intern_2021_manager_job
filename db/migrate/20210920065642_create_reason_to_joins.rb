class CreateReasonToJoins < ActiveRecord::Migration[6.1]
  def change
    create_table :reason_to_joins do |t|
      t.references :job, null: false, foreign_key: true
      t.string :reason_content

      t.timestamps
    end
  end
end
