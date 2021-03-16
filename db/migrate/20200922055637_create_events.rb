# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :place
      t.string :description
      t.datetime :starttime
      t.datetime :endtime
      t.string :eventpass

      t.timestamps
    end
  end
end
