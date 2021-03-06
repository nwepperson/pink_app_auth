class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user
  before_action :signed_in_user, only: [:show, :edit, :update, :destroy]
  before_action :verify_correct_user, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    if signed_in?
    if current_user.admin?
      @users = User.all.order(id: :asc)
    else
      redirect_to root_url, notice: 'Access Denied!'
    end
  else
    redirect_to signin_url, notice: "Please sign in."
  end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      set_admin(@user)
      if @user.save
        UserNotifier.send_signup_email(@user).deliver_now
        if @user.admin?
          sign_in @user
          format.html { redirect_to '/users', notice: 'Welcome Admin!' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { redirect_to root_path, notice: 'Welcome!' }
          format.json { render :show, status: :created, location: @user }
          sign_in @user
        end
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def filter
    if current_user.admin?
      @users = User.where(users: params[:user]).order(last_name: :asc)
    else
      redirect_to root_url, notice: 'Access Denied!'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_admin user
      if user[:email] == "leighpinkfit@gmail.com" || user[:email] == "leighepperson@yahoo.com"
        user[:admin] = true
      else
        user[:admin] = false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name,
                             :last_name,
                             :email,
                             :password,
                             :password_confirmation)
    end

    def verify_correct_user
        user = User.find_by(id: params[:id])
        redirect_to root_url, notice: 'Access Denied!' unless current_user?(user) || current_user.admin?
    end
end
