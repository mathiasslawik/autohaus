class CustomersController < ApplicationController
  before_filter :require_admin

  def index
    @customers = Person.paginate :all, :page => params[:page]
  end
end