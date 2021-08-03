class CreateLeads < ActiveRecord::Migration[6.1]
  def change
    create_table :leads do |t|
      t.string :identity_group_id
      t.string :entity
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phone_number
      t.string :question
      t.string :lead_type
      t.string :comment_summary
      t.string :intervention_id
      t.string :agent_id
      t.string :thread_id
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end
