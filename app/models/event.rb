# frozen_string_literal: true

class Event < ApplicationRecord
  scope :sorted, -> { order('starttime ASC') }
  has_many :participation, dependent: :destroy
  validates_presence_of :title, :starttime, :eventpass

  def as_json(*)
    { id: id, name: title, start_time: starttime }
  end

  #   before_destroy :remove_participation_from_event

  # private

  # def remove_participation_from_event
  #   Event.where(id: id).update_all(id: nil)
  # end
end
