# frozen_string_literal: true

class AddEventidToParticipation < ActiveRecord::Migration[6.0]
  def change
    # add_column table_name, :column_name, :column type
    add_column :participations, :event_id, :integer
    # add_reference :participations, :events, index: true
    add_foreign_key :participations, :events
  end
end
