class OrdersController < ApplicationController
  def index
    if params[:contact_id]
      @contact = Contact.find params[:contact_id]
      @orders = Order.find_all_by_contact_id(params[:contact_id])
    else
      @orders = Order.find :all, :include => [:contact, :invoice, :facebook_comments]
    end

    #Übernimm Sort-Parameter aus Params. Default: ID
    @sort = if params[:sort] then params[:sort] else "id" end

    @orders.sort! { |a,b| eval "a.#{@sort} <=> b.#{@sort}" }

    unless params[:reverse] == nil
      @orders.reverse!
    end

    @orders = @orders.paginate :page => params[:page]
  end

  def show
    @order = Order.find(params[:id])
  end
end