# frozen_string_literal: true

require 'date'
require 'active_support'
require 'active_support/all'

# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Event do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :title, :place, :description, :starttime, :endtime, :eventpass, :repeating, :repeatmonday,
                :repeattuesday, :repeatwednesday, :repeatthursday, :repeatfriday, :repeatsaturday, :repeatsunday,
                :repeatweeks

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
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def create
      newevent = permitted_params[:event]
      newstarttime = DateTime.new(newevent['starttime(1i)'].to_i, newevent['starttime(2i)'].to_i,
                                  newevent['starttime(3i)'].to_i, newevent['starttime(4i)'].to_i,
                                  newevent['starttime(5i)'].to_i)
      newendtime = DateTime.new(newevent['endtime(1i)'].to_i, newevent['endtime(2i)'].to_i,
                                newevent['endtime(3i)'].to_i, newevent['endtime(4i)'].to_i,
                                newevent['endtime(5i)'].to_i)
      weeks = newevent[:repeatweeks].to_i
      if newendtime < newstarttime
        redirect_to '/admin/events/new', flash: { error: 'Error: End Time is earlier than Start Time.' }
      elsif newevent[:repeatsunday] == '1' || newevent[:repeatmonday] == '1' || newevent[:repeattuesday] == '1' ||
            newevent[:repeatwednesday] == '1' || newevent[:repeatthursday] == '1' || newevent[:repeatfriday] == '1' ||
            newevent[:repeatsaturday] == '1' # repeating event creation
        if weeks.positive?
          # for the first day of the repeating events creation
          event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                newevent[:description], starttime: newstarttime, endtime: newendtime,
                               eventpass: newevent[:eventpass])
          (0..weeks).each do |_i|
            if newevent[:repeatsunday] == '1'
              nextdate = newstarttime.next_occurring(:sunday)
              change = (nextdate - newstarttime).to_i
              newstarttime += change
              newendtime += change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime, endtime: newendtime,
                                   eventpass: newevent[:eventpass])
              newstarttime -= change
              newendtime -= change
            end
            if newevent[:repeatmonday] == '1'
              nextdate = newstarttime.next_occurring(:monday)
              change = (nextdate - newstarttime).to_i
              newstarttime += change
              newendtime += change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime, endtime: newendtime,
                                   eventpass: newevent[:eventpass])
              newstarttime -= change
              newendtime -= change
            end
            if newevent[:repeattuesday] == '1'
              nextdate = newstarttime.next_occurring(:tuesday)
              change = (nextdate - newstarttime).to_i
              newstarttime += change
              newendtime += change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime, endtime: newendtime,
                                   eventpass: newevent[:eventpass])
              newstarttime -= change
              newendtime -= change
            end
            if newevent[:repeatwednesday] == '1'
              nextdate = newstarttime.next_occurring(:wednesday)
              change = (nextdate - newstarttime).to_i
              newstarttime += change
              newendtime += change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime, endtime: newendtime,
                                   eventpass: newevent[:eventpass])
              newstarttime -= change
              newendtime -= change
            end
            if newevent[:repeatthursday] == '1'
              nextdate = newstarttime.next_occurring(:thursday)
              change = (nextdate - newstarttime).to_i
              newstarttime += change
              newendtime += change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime, endtime: newendtime,
                                   eventpass: newevent[:eventpass])
              newstarttime -= change
              newendtime -= change
            end
            if newevent[:repeatfriday] == '1'
              nextdate = newstarttime.next_occurring(:friday)
              change = (nextdate - newstarttime).to_i
              newstarttime += change
              newendtime += change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime, endtime: newendtime,
                                   eventpass: newevent[:eventpass])
              newstarttime -= change
              newendtime -= change
            end
            next unless newevent[:repeatsaturday] == '1'

            nextdate = newstarttime.next_occurring(:saturday)
            change = (nextdate - newstarttime).to_i
            newstarttime += change
            newendtime += change
            event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                 newevent[:description], starttime: newstarttime, endtime: newendtime,
                                 eventpass: newevent[:eventpass])
            newstarttime -= change
            newendtime -= change
            newstarttime += 7
            newendtime += 7
          end
          if !event.valid?
            redirect_to '/admin/events/new', flash: { error: 'Error: Invalid Event' }
          else
            redirect_to '/admin/events', flash: { error: 'Event was successfully created.' }
          end
        else
          redirect_to '/admin/events/new', flash: { error: 'Error: Weeks cannot be zero/negative for repeat events.' }
        end
      else # singular event creation
        event = Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description],
                             starttime: newstarttime, endtime: newendtime, eventpass: newevent[:eventpass])
        if !event.valid?
          redirect_to '/admin/events/new', flash: { error: 'Error: Invalid Event' }
        else
          redirect_to '/admin/events', flash: { error: 'Event was successfully created.' }
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
