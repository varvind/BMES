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

  # This code takes the front end portion above operates it to where it reads
  # the input given by the user and creates the events (single and repeating)
  # as well as handles several cases of errors that could possible happen
  # form controller
  controller do
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Style/Next
    # rubocop:disable Style/NegatedIf
    # rubocop:disable Lint/NonLocalExitFromIterator
    def create
      # gets parameters from new event
      newevent = permitted_params[:event]

      if newevent['starttime(1i)'] == '' || newevent['starttime(1i)'] == '' ||
         newevent['starttime(2i)'] == '' || newevent['starttime(3i)'] == '' ||
         newevent['starttime(4i)'] == '' || newevent['starttime(5i)'] == '' ||
         newevent['endtime(1i)'] == '' || newevent['endtime(1i)'] == '' ||
         newevent['endtime(2i)'] == '' || newevent['endtime(3i)'] == '' ||
         newevent['endtime(4i)'] == '' || newevent['endtime(5i)'] == ''
        redirect_to '/admin/events/new', flash: { error: 'Error: Invalid Date Entry' }
        return
      end
      # gets the start time parameter from new event
      newstarttime = DateTime.new(newevent['starttime(1i)'].to_i, newevent['starttime(2i)'].to_i,
                                  newevent['starttime(3i)'].to_i, newevent['starttime(4i)'].to_i,
                                  newevent['starttime(5i)'].to_i)
      # gets the end time parameter from new event
      newendtime = DateTime.new(newevent['endtime(1i)'].to_i, newevent['endtime(2i)'].to_i,
                                newevent['endtime(3i)'].to_i, newevent['endtime(4i)'].to_i,
                                newevent['endtime(5i)'].to_i)
      # gets the weeks parameter from new event
      weeks = newevent[:repeatweeks].to_i

      # changes time zone to central time
      newstarttime = newstarttime.change(offset: '+0000')
      newendtime = newendtime.change(offset: '+0000')
      # checks to see if starttime is not in the past
      if newstarttime.change(offset: '-0500') < DateTime.now
        # gives error if it does
        redirect_to '/admin/events/new', flash: { error: 'Error: Start Time cannot be in the past.' }
      # checks to see if end time is before start time
      elsif newendtime < newstarttime
        # gives error if it does
        redirect_to '/admin/events/new', flash: { error: 'Error: End Time is earlier than Start Time.' }
      # checks to see if any of the repeating booleans are true
      elsif newevent[:repeatsunday] == '1' || newevent[:repeatmonday] == '1' || newevent[:repeattuesday] == '1' ||
            newevent[:repeatwednesday] == '1' || newevent[:repeatthursday] == '1' || newevent[:repeatfriday] == '1' ||
            newevent[:repeatsaturday] == '1' # repeating event creation
        # checks to see if weeks is positive and not zero
        if weeks.positive?
          # for the first day of the repeating events creation
          event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                newevent[:description], starttime: newstarttime, endtime: newendtime,
                               eventpass: newevent[:eventpass])
          # for loop for repeating events
          (0..weeks).each do |_i|
            if newevent[:repeatsunday] == '1' # checks if event needs to repeat on sunday
              nextdate = newstarttime.next_occurring(:sunday) # finds the next sunday
              change = (nextdate - newstarttime).to_i # gets the difference between the dates
              # creates the event with the change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime + change,
                                   endtime: newendtime + change, eventpass: newevent[:eventpass])
            end
            if newevent[:repeatmonday] == '1' # checks if event needs to repeat on monday
              nextdate = newstarttime.next_occurring(:monday) # finds the next monday
              change = (nextdate - newstarttime).to_i # gets the difference between the dates
              # creates the event with the change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime + change,
                                   endtime: newendtime + change, eventpass: newevent[:eventpass])
            end
            if newevent[:repeattuesday] == '1' # checks if event needs to repeat on tuesday
              nextdate = newstarttime.next_occurring(:tuesday) # finds the next tuesday
              change = (nextdate - newstarttime).to_i # gets the difference between the dates
              # creates the event with the change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime + change,
                                   endtime: newendtime + change, eventpass: newevent[:eventpass])
            end
            if newevent[:repeatwednesday] == '1' # checks if event needs to repeat on wednesday
              nextdate = newstarttime.next_occurring(:wednesday) # finds the next wednesday
              change = (nextdate - newstarttime).to_i # gets the difference between the dates
              # creates the event with the change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime + change,
                                   endtime: newendtime + change, eventpass: newevent[:eventpass])
            end
            if newevent[:repeatthursday] == '1' # checks if event needs to repeat on thursday
              nextdate = newstarttime.next_occurring(:thursday) # finds the next thursday
              change = (nextdate - newstarttime).to_i # gets the difference between the dates
              # creates the event with the change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime + change,
                                   endtime: newendtime + change, eventpass: newevent[:eventpass])
            end
            if newevent[:repeatfriday] == '1' # checks if event needs to repeat on friday
              nextdate = newstarttime.next_occurring(:friday) # finds the next friday
              change = (nextdate - newstarttime).to_i # gets the difference between the dates
              # creates the event with the change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                   newevent[:description], starttime: newstarttime + change,
                                   endtime: newendtime + change, eventpass: newevent[:eventpass])
            end
            if newevent[:repeatsaturday] == '1' # checks if event needs to repeat on saturday
              nextdate = newstarttime.next_occurring(:saturday) # finds the next saturday
              change = (nextdate - newstarttime).to_i # gets the difference between the dates
              # creates the event with the change
              event = Event.create(title: newevent[:title], place: newevent[:place], description:
                                  newevent[:description], starttime: newstarttime + change,
                                   endtime: newendtime + change, eventpass: newevent[:eventpass])
            end
            newstarttime += 7
            newendtime += 7
            if !event.valid? # checks to see if event is successfully created and valid
              # gives error if it does not
              redirect_to '/admin/events/new', flash: { error: 'Error: Invalid Event' }
              return
            end
          end
          redirect_to '/admin/events', flash: { error: 'Event was successfully created.' }
        else
          # gives error if weeks is negative or zero
          redirect_to '/admin/events/new', flash: { error: 'Error: Weeks cannot be zero/negative for repeat events.' }
        end
      else # singular event creation
        # creates event
        event = Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description],
                             starttime: newstarttime, endtime: newendtime, eventpass: newevent[:eventpass])
        if !event.valid? # checks to see if event is successfully created and valid
          # gives error if it does not
          redirect_to '/admin/events/new', flash: { error: 'Error: Invalid Event' }
        else
          # prints off that it works
          redirect_to '/admin/events', flash: { error: 'Event was successfully created.' }
        end
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Style/Next
# rubocop:enable Style/NegatedIf
# rubocop:enable Lint/NonLocalExitFromIterator
