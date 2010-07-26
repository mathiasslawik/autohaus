class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :show]
  before_filter :require_user, :only => :destroy

  def show
    @user_session = UserSession.new
    render :new
  end

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end
end