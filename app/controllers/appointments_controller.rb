class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  before_action :verify_correct_user, only: [:show, :edit, :update, :destroy]
  # GET /appointments
  # GET /appointments.json
  def index
    if current_user.admin?
      @appointments = Appointment.all.order(date: :desc)
      @appointments = Appointment.all.order(time: :desc)
    else
      @appointments = current_user.appointments.order(created_at: :desc)
    end
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments
  # POST /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user = current_user
    @appointments = current_user.appointments
    if @appointments.exists?(time: @appointment.time, date: @appointment.date)
      redirect_to root_url, notice: 'Appointment already exists!'
    else
      respond_to do |format|
        if @appointment.save
          UserNotifier.send_appointment_email(current_user, @appointment).deliver_now
          UserNotifier.send_admin_email(current_user, @appointment).deliver_now
          format.html { redirect_to root_url, notice: 'Appointment was successfully created.' }
          format.json { render :show, status: :created, location: @appointment }
        else
          format.html { render :new }
          format.json { render json: @appointment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    @appointments = current_user.appointments
    if @appointments.exists?(time: appointment_params[:time], date: appointment_params[:date])
      redirect_to root_url, notice: 'Appointment already exists!'
    else
    respond_to do |format|
      if @appointment.update(appointment_params)
        UserNotifier.send_update_email(current_user, @appointment).deliver_now
        UserNotifier.send_adm_update_email(current_user, @appointment).deliver_now
        format.html { redirect_to appointment_path, notice: 'Appointment was successfully updated.' }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    UserNotifier.send_delete_email(current_user, @appointment).deliver_now
    UserNotifier.send_adm_delete_email(current_user, @appointment).deliver_now
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Appointment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def app_filter
    if current_user.admin?
      @appointments = Appointment.where(appointments: params[:appointment]).order(time: :asc)
    else
      @appointments = current_user.appointments.where(appointments: params[:appointment]).order(time: :asc)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params.require(:appointment).permit(:date, :time, :comment)
    end

    def verify_correct_user
      if current_user.admin?
        @appointment = Appointment.find(params[:id])
      else
        @appointment = current_user.appointments.find_by(id: params[:id])
        redirect_to root_url, notice: 'Access Denied!' if @appointment.nil?
      end
    end
end
