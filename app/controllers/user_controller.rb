# frozen_string_literal: true

class UserController < ApplicationController
  def login
    render layout: 'mailer'
  end

  def login_action
    user = User.find_by(email: params['user']['email']).try(:authenticate, params['user']['password'])
    if user
      session[:user_id] = user.id
      redirect_to '/user_profile'
    else
      flash[:notice] = 'Error'
      redirect_to '/user/login'
    end
  end

  def profile
    user = User.find_by(id: session[:user_id])

    if user
      @user = user
    else
      redirect_to '/'
    end
  end

  def logout
    reset_session
    redirect_to '/'
  end

  def change_password
    
  end
end
