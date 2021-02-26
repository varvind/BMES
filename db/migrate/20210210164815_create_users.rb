class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.integer :total_points, default: 0
      t.integer :general_meeting_points, default: 0
      t.integer :mentorship_meeting_points, default: 0
      t.integer :social_points, default: 0
      t.string :events, array:true, default:[]
      t.timestamps
    end
  end
end
