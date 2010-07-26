class Facebook::OrdersController < FacebookController
  #Für das View
  helper :orders

  #Für den Controller
  include OrdersHelper

  def index
    @title = "Aufträge"

    @orders = Order.find_all_by_contact_id @contacts.collect { |c| c.id }, :include => [:invoice, :contact]

    unless params[:sort] == nil
      @orders.sort! { |a,b| eval "a.#{params[:sort]} <=> b.#{params[:sort]}" }
    end

    unless params[:reverse] == nil
      @orders.reverse!
    end

    @orders = @orders.paginate :page => params[:page]
  end

  def show
    @order = Order.find params[:id]
  end

  def post_to_wall
    order = Order.find params[:id]

    @facebook_session.user.publish_to(@facebook_session.user,
      :message => "#{params[:comment]}",
      :attachment => {
        :name => "Autohaus",
        :caption => "{*actor*} war beim Autohaus",
        :href => url_for(:controller => '/facebook', :action => :index),
        :properties => {
          "Typ des Auftrags" => order.invoice.invoice_type,
          "Datum" => order.invoice.date.strftime("%d.%m.%Y"),
          "Preis" => (order.invoice.amount / 100.0).to_s + " €",
          "Bewertung" => rating_text(params[:rating])
        },
        :order_id => order.id
      })

    redirect_to facebook_order_url(params[:id])
  end
end