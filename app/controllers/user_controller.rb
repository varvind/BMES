# frozen_string_literal: true

class UserController < ApplicationController
  def login
    render layout: 'mailer'
  end

  def login_action
    user = User.find_by(email: params['user']['email']).try(:authenticate, params['user']['password'].to_i)
    puts user
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
    current_password = params["current_password"]
    new_password = params["new_password"][0]
    password_confirmation = params["confirmation_password"][0]
    user = User.find_by(id: session[:user_id])
    if user && user.authenticate(current_password[0].to_i)
      if new_password == password_confirmation
        newUser = user.update(:password => new_password, :password_confirmation => password_confirmation)
        flash[:notice] = "Password reset successfully"
      else
        flash[:notice] = "Passwords do not match!"
      end
    else
      flash[:notice] = "Wrong Password Entered, Try Again"
    end
    redirect_to '/user/settings'
  end
end
