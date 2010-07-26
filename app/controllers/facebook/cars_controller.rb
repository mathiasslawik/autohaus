class Facebook::CarsController < FacebookController
  def index
    @title = "Autos und Inspektionen"

    @cars = Car.find_all_by_contact_id @contacts.collect { |c| c.id }, :include => [:contact]

    unless params[:sort] == nil
      @cars.sort! { |a,b| eval "a.#{params[:sort]} <=> b.#{params[:sort]}" }
    end

    unless params[:reverse] == nil
      @cars.reverse!
    end

    @cars = @cars.paginate :page => params[:page]
  end
end