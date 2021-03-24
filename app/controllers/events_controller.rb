# frozen_string_literal: true

require 'securerandom'

# All commented out methods works in Admin Console, they are not needed for a user

class EventsController < ApplicationController
  def index
    @events = Event.where('starttime > ?', Date.today - 2.day).all.sorted
  end

  def new
    event = Event.find_by(id: params['event_id'])
    if event
      @id = event.id
    else
      redirect_to '/', flash: { danger: 'Event Does Not Exist!' }
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def sign_in
    @event_id = params['signin']['event_id']
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
      (0..@event.users.length - 1).each do |i|
        user = @event.users[i] if @event.users[i].id == session[:user_id]
      end
      guest_name = ''
      unless params['signin']['first_name'].nil?
        guest_name = params['signin']['first_name'] + ' ' + params['signin']['last_name']
      end
      guest_user = @event.guests.include?(name: guest_name)
      if user || guest_user # check if member or guest has signed in already
        redirect_to events_path, flash: { danger: 'You have already signed into the event' }
        nil
      else
        user = User.find_by(email: params['signin']['email'])
        user1 = User.find_by(id: session[:user_id])
        if user && !user1 # indicates the user has an account, and should sign in
          redirect_to new_event_path(event_id: @event_id), flash: { danger: 'Please sign in to your account before checking in.' }
          return
        elsif user
          user.events << @event
          gen_points = user.general_meeting_points
          men_points = user.mentorship_meeting_points
          soc_points = user.social_points
          case @event.eventtype
          when 'General Meeting'
            gen_points += 1
          when 'Mentorship Meeting'
            men_points += 1
          else
            soc_points += 1
          end
          total_points = user.total_points + 1
          user.update(general_meeting_points: gen_points, mentorship_meeting_points: men_points, social_points: soc_points, total_points: total_points)
        else # indicates no user so this means guest sign in
          @event.guests.push(guest_name)
          @event.save
        end
        redirect_to '/', flash: { success: 'You have successfully signed into the event.' }
      end
    else
      redirect_to new_event_path(event_id: @event_id), flash: { danger: 'Incorrect password, please try '\
        'again.' }
    end
  end
end
