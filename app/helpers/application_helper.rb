# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  #Erzeugt einen Link in der Titelzeile zur Sortierung der Tabelle
  def link_to_sort(label, criteria)
    url = url_for :controller => params[:controller], :action => params[:action]

    url += "?sort=#{criteria}"

    unless params[:sort] == nil || params[:sort] != criteria || params[:reverse] == 'true' then
      url += '&reverse=true'
    end

    unless params[:page] == nil
      url += "&page=#{params[:page]}"
    end

    link_to label, url
  end
end
