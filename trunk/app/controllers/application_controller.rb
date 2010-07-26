class ApplicationController < ActionController::Base
  helper_method :current_user_session, :current_user, :page_title, :paginate_stats
  filter_parameter_logging :password, :password_confirmation

  layout 'default'

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "Logge Dich ein, um diese Seite zu sehen."
        redirect_to user_sessions_path
        return false
      end
    end

    def require_admin
      if require_user
        unless current_user.admin?
          store_location
          flash[:notice] = "Um diese Seite zu sehen, muss Du als Administrator eingeloggt sein"
          redirect_to user_sessions_path
          return false
        end
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "Logge Dich aus, um diese Seite zu sehen."
        redirect_to account_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def page_title
      if @page_title
        "Autohaus - " + @page_title
      else
        "Autohaus"
      end
    end

    def paginate_stats(c)
      _start = c.offset + 1
      _end = c.next_page == nil ? c.total_entries : c.offset + c.per_page
      _total = c.total_entries

      _start.to_s + " - " + _end.to_s + " von " + _total.to_s
    end
end