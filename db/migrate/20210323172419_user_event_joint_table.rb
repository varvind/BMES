class UserEventJointTable < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :place
      t.string :description
      t.datetime :starttime
      t.datetime :endtime
      t.string :eventpass
      t.string :eventtype
      t.string :guests, array:true, default:[]
      t.timestamps
    end

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.integer :total_points, default: 0
      t.integer :general_meeting_points, default: 0
      t.integer :mentorship_meeting_points, default: 0
      t.integer :social_points, default: 0
      t.timestamps
    end

    create_table :events_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :event
    end
  end
end
