# frozen_string_literal: true

require 'securerandom'

# All commented out methods works in Admin Console, they are not needed for a user

class EventsController < ApplicationController
  # has_many: ParticipationsController

  # def delete
  #   @event = Event.find(params[:id])
  # end

  # def edit
  #   @event = Event.find(params[:id])
  # end

  def index
    @events = Event.where('starttime > ?', Date.today - 2.day).all.sorted
  end

  # def new
  #   @event = Event.new
  # end

  def show
    @event = Event.find(params[:id])
  end

  # def destroy
  #   @event = Event.find(params[:id])
  #   @event.destroy
  #   flash[:notice] = "Event '#{@event.title}' destroyed successfully."
  #   redirect_to(events_path)
  # end

  # def update
  #   @event = Event.find(params[:id])
  #   if @event.update_attributes(event_params)
  #     flash[:notice] = "Event updated successfully."
  #     redirect_to(events_path)

  #   else
  #     render('edit')
  #   end
  # end

  # def create
  #   @event = Event.new(event_params)

  #   if @event.save
  #     flash[:notice] = "Event created successfully."
  #     redirect_to(events_path)
  #   else
  #     render("new")
  #   end
  # end

  # private

  # def event_params
  #   params.require(:event).permit(:title, :place, :description, :starttime, :endtime, :eventpass)
  # end
end
