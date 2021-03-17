class AddRepeatToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :repeatmonday, :boolean
    add_column :events, :repeattuesday, :boolean
    add_column :events, :repeatwednesday, :boolean
    add_column :events, :repeatthursday, :boolean
    add_column :events, :repeatfriday, :boolean
    add_column :events, :repeatsaturday, :boolean
    add_column :events, :repeatsunday, :boolean
    add_column :events, :repeatweeks, :integer
  end
end
