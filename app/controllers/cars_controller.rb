class CarsController < ApplicationController
  def index
    if params[:contact_id]
      @contact = Contact.find params[:contact_id]
      @cars = Car.find_all_by_contact_id(params[:contact_id])
    else
      @cars = Car.find :all, :include => [:contact]
    end

    #Übernimm Sort-Parameter aus Params. Default: ID
    @sort = if params[:sort] then params[:sort] else "id" end

    #Sortiere die Autos nach den übergebenen Parametern und kümmere dich darum,
    #dass das auch mit "nil" funktioniert
    @cars.sort! do |a,b|
      if (a.send @sort) == nil && (b.send @sort) == nil then
        0
      elsif (a.send @sort) == nil then
        -1
      elsif (b.send @sort) == nil then
        1
      else
        (a.send @sort) <=> (b.send @sort)
      end
    end

    unless params[:reverse] == nil
      @cars.reverse!
    end

    @cars = @cars.paginate :page => params[:page]
  end

  def show
    @cars = Car.find(params[:id])
  end

  def due_swap
    @car = Car.find params[:id]

    if @car.inspection_due.nil? || @car.inspection_due == false
      @car.inspection_due = true
    else
      @car.inspection_due = false
    end

    @car.save!

    redirect_to :back
  end
end