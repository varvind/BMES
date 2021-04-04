# frozen_string_literal: true

require 'securerandom'

class EventsController < ApplicationController
  def index
    @events = Event.where('starttime > ?', Date.today - 2.day).all.sorted
    @meetings = Event.where('starttime > ?', Date.today - 2.day).all.sorted
  end

  def show
    @event = Event.find(params[:id])
    @events = Event.all
    @count = Participation.where(event_id: params[:id])
  end
end
