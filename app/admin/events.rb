# frozen_string_literal: true

require 'date'

ActiveAdmin.register Event do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :place, :description, :starttime, :endtime, :eventpass
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :place, :description, :starttime, :endtime, :eventpass]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # form controller
  controller do
    def create
      newevent = permitted_params[:event]
      newstarttime = starttime
      newendtime = endtime
      if repeatsunday == true || repeatmonday == true || repeattuesday == true || repeatwednesday == true || repeatthursday == true || repeatfriday == true || repeatsaturday == true # repeating event creation
        for i in 1..repeatweeks
          if repeatsunday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:sunday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if repeatmonday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:monday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if repeattuesday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:tuesday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if repeatwednesday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:wednesday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if repeatthursday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:thursday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if repeatfriday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:friday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          if repeatsaturday == true
            nextdate = Time.zone.at(Date.next_occuring.to_time).to_datetime(:saturday)
            change = newstarttime - nextdate
            newstarttime = newstarttime + change
            newendtime = newendtime + change
            Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          end
          # Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: :newstarttime, endtime: :newendtime, eventpass: newevent[:eventpass])
          # newstarttime = newstartime + 7  # adds one week
          # newendtime = newendtime + 7 # adds one week
      else  # singular event creation
        Event.create(title: newevent[:title], place: newevent[:place], description: newevent[:description], starttime: newevent[:starttime], endtime: newevent[:endtime], eventpass: newevent[:eventpass])
      end
    end
  end
end