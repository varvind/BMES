# frozen_string_literal: true

class Participation < ApplicationRecord
  validates_presence_of :event_id, :first_name, :last_name, :email

  def as_json(*)
    { email: email, first_name: first_name, last_name: last_name, uin: uin.nil? ? '' : uin }
  end
end
