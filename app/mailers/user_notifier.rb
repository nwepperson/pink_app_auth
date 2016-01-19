class UserNotifier < ApplicationMailer
  default :from => 'leighpinkfit@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Thanks for signing up for our amazing app' )
  end

  def send_appointment_email(user)
    @user = user
    @appointment = Appointment.find_by(user_id: @user.id)
    mail( :to => @user.email,
    :subject => 'Thanks for scheduling a training session!' )
  end

  def send_admin_email(user)
    @user = user
    @appointment = Appointment.find_by(user_id: @user.id)
    mail( :to => 'nepperson25@gmail.com',
    :subject => 'Thanks for scheduling a training session!' )
  end
end
