# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Event do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :title, :place, :description, :starttime, :endtime, :eventpass, :repeating, :repeatmonday,
                :repeattuesday, :repeatwednesday, :repeatthursday, :repeatfriday, :repeatsaturday, :repeatsunday, :eventtype

  index do
    selectable_column
    column :title
    column :place
    column :description
    column :starttime, label: 'Start Time'
    column :endtime, label: 'End Time'
    column :eventpass, label: 'Event Password'
    column :eventtype, label: 'Event Type'
    column :users
    column :guests
    column :created_at
    column :updated_at
    actions
  end

  filter :title
  filter :place
  filter :starttime
  filter :eventtype

  show do
    attributes_table :title, :place, :description, :starttime, :endtime, :eventpass, :eventtype, :created_at, :updated_at
  end

  form do |f|
    text_node javascript_include_tag('events_form.js')
    f.inputs do
      input :title
      input :place
      input :description
      input :eventtype, :as => :select, :collection => ['General Meeting', 'Mentorship Meeting', 'Social Meeting'], :label => 'Event Type', :include_blank => false
      input :starttime
      input :endtime
      input :eventpass, label: 'Event Password'
      f.li "<button type = 'button' class='label' id = 'switchButton'
             style = 'margin-left:1%;font-weight:bold; margin-top:1%' onclick='changeForm()'>
             Non-Repeating Event</label>".html_safe
      f.li "<label class='label' id ='instructions'
             style = 'margin-left:1%;font-weight:bold; margin-top:10%; position:relative'>
             What days should the event repeat for?</label>".html_safe
      input :repeatmonday, as: :boolean, label: 'Mondays'
      input :repeattuesday, as: :boolean, label: 'Tuesdays'
      input :repeatwednesday, as: :boolean, label: 'Wednesdays'
      input :repeatthursday, as: :boolean, label: 'Thursdays'
      input :repeatfriday, as: :boolean, label: 'Fridays'
      input :repeatsaturday, as: :boolean, label: 'Saturdays'
      input :repeatsunday, as: :boolean, label: 'Sundays'
      input :repeatweeks, label: 'How many weeks should the event repeat for?'
    end
    f.actions
  end
end
# rubocop:enable Metrics/BlockLength
