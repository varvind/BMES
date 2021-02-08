# frozen_string_literal: true

class CreateParticipations < ActiveRecord::Migration[6.0]
  def change
    create_table :participations do |t|
      t.integer :uin
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end
end
