# frozen_string_literal: true

require 'date'

# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Event do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :title, :place, :description, :starttime, :endtime, :eventpass, :repeating, :repeatmonday,
                :repeattuesday, :repeatwednesday, :repeatthursday, :repeatfriday, :repeatsaturday, :repeatsunday, :repeatweeks

  # Intialize columns
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

  show do
    attributes_table :title, :place, :description, :starttime, :endtime, :eventpass, :created_at, :updated_at
  end

  # Intialize Form
  form do |f|
    text_node javascript_include_tag('events_form.js')
    f.inputs do
      input :title
      input :place
      input :description
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

  # form controller
  controller do
    def create
      newevent = permitted_params[:event]
      newstarttime = newevent[:starttime]
      newendtime = newevent[:endtime]
      if :repeatsunday == true || :repeatmonday == true || :repeattuesday == true || :repeatwednesday == true || :repeatthursday == true || :repeatfriday == true || :repeatsaturday == true # repeating event creation
        for i in 1..:repeatweeks
          if :repeatsunday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:sunday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            event = Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if :repeatmonday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:monday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            event = Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if :repeattuesday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:tuesday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            event = Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if :repeatwednesday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:wednesday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            event = Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if :repeatthursday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:thursday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            event = Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if :repeatfriday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:friday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            event = Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if :repeatsaturday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:saturday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            event = Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          # Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          # newstarttime = newstartime + 7  # adds one week
          # newendtime = newendtime + 7 # adds one week
        end
      else  # singular event creation
        event = Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: newevent[:starttime], endtime: newevent[:endtime], eventpass: newevent[:eventpass])
      end
      if !event.valid?
        redirect_to '/admin/events/new', flash: { error: 'Error.' }
      else
        redirect_to '/admin/events', flash: { error: 'Successfully Created Event.' }
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength