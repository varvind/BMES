# frozen_string_literal: true

ActiveAdmin.register Event do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :title, :place, :description, :starttime, :endtime, :eventpass,
                        :repeating, :repeatmonday, :repeattuesday, :repeatwednesday,
						:repeatthursday, :repeatfriday, :repeatsaturday, :repeatsunday

  index do
    selectable_column
    column :title
    column :place
    column :description
    column :starttime, label: 'Start Time'
    column :endtime, label: 'End Time'
    column :eventpass, label: 'Event Password'
    column :created_at
    column :updated_at
    actions
  end

  filter :title
  filter :place
  filter :starttime

  # show do
    # #selectable_column
	# panel "Info" do
    # column :title
    # column :place
    # column :description
    # column :starttime, label: 'Start Time'
    # column :endtime, label: 'End Time'
    # column :eventpass, label: 'Event Password'
    # column :created_at
	# column :updated_at
    # end
  # end

  form do |f|
    input :title
    input :place
    input :description
    input :starttime
    input :endtime
    input :eventpass, label: 'Event Password'
    text_node javascript_include_tag('events_form.js')
    f.inputs do
      f.li "<button type = 'button' class='label' id = 'switchButton'
             style = 'margin-left:1%;font-weight:bold; margin-top:1%' onclick='changeForm()'>
             Non-Repeating Event</label>".html_safe
      f.li "<label class='label' id ='instructions'
             style = 'margin-left:1%;font-weight:bold; margin-top:10%; position:relative'>
             What days should the event repeat for?</label>".html_safe
      input :repeatmonday, label: 'Mondays'
      input :repeattuesday, label: 'Tuesdays'
      input :repeatwednesday, label: 'Wednesdays'
      input :repeatthursday, label: 'Thursdays'
      input :repeatfriday, label: 'Fridays'
      input :repeatsaturday, label: 'Saturdays'
      input :repeatsunday, label: 'Sundays'
      input :repeatweeks, label: 'How many weeks should the event repeat for?'
    end
    f.actions
  end
end
