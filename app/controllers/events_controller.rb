# frozen_string_literal: true

require 'securerandom'

# All commented out methods works in Admin Console, they are not needed for a user

class EventsController < ApplicationController
  def index
    @events = Event.where('starttime > ?', Date.today - 2.day).all.sorted
  end

  def new
    event = Event.find(params['event_id'])
    @id = event.id
  end

  def show
    @event = Event.find(params[:id])
  end

  def sign_in
    @event_id = params['signin']['event_id']
    puts @event_id
    @event = begin
               Event.find(@event_id)
             rescue StandardError
               nil
             end
    if @event.nil?
      redirect_to new_event_path(event_id: @event_id), flash: { danger: 'No matching event found, please try '\
        'again.' }
    elsif @event.eventpass == params[:event_pass]
      user = nil
      for i in 0..@event.users.length-1
        if(@event.users[i].id == session[:user_id])
          user = @event.users[i]
        end
      end
      guest_name = ""
      if(!params['signin']['first_name'].nil?)
        guest_name = params['signin']['first_name'] + " " + params['signin']['last_name']
      end
      guest_user = @event.guests.include?(name: guest_name)
      if user || guest_user #check if member or guest has signed in already
        redirect_to events_path, flash: { danger: 'You have already signed into the event' }
        return
      else
        user = User.find_by(email: params['signin']['email'])
        if user && !session[:user_id] # indicates the user has an account, and should sign in
          redirect_to new_event_path(event_id: @event_id), flash: { danger: 'Please sign in to your account before checking in.'}
          return
        elsif user
          user.events << @event
          case @event.eventtype
          when 'General Meeting'
            user.general_meeting_points = user.general_meeting_points + 1
          when 'Mentorship Meeting'
            user.mentorship_meeting_points = user.mentorship_meeting_points + 1
          else
            user.social_points = user.social_points + 1
          end
          user.total_points = user.total_points + 1
          user.save
        else # indicates no user so this means guest sign in
          @event.guests.push(guest_name)
          @event.save
        end
        redirect_to event_path(id: @event_id), flash: { success: 'You have successfully signed into the event.' }
      end
    else
      redirect_to new_event_path(event_id: @event_id), flash: { danger: 'Incorrect password, please try '\
        'again.' }
    end
  end
end
