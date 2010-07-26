class HomeController < ApplicationController
  def index
    # Mache einen Redirect zum Facebook-Controller, falls wir von Facebook
    # aufgerufen werden
    if request_comes_from_facebook?
      redirect_to :controller => 'facebook'
    end
  end
end
