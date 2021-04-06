# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates_presence_of :name, :password_digest, :email
  validates :email, uniqueness: true
  has_and_belongs_to_many :events
end
