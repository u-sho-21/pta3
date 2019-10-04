class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    first = @user.attendances.first.worked_on
    last = @user.attendances.last.worked_on
    @dates = @user.attendances.where("worked_on>=? and worked_on<=?",first,last).order('worked_on asc')
  end

  # GET /users/new
  def new
    @user = User.new
  end

  
  def edit
  end

  def create
    @user = User.all
    params[:str].split("\r\n").each do |day|
     @user.each do |user|
       unless user.attendances.any?{|attendance| attendance.worked_on == Date.parse(day)}
         record = user.attendances.build(worked_on:Date.parse(day))
         record.save
       end
     end 
    end  
    redirect_to users_path
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
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :age)
    end
end
