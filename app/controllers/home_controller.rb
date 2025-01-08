class HomeController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_request, only: [:index, :about]

  def index
    # Add any logic here, such as fetching data
  end

  def about
    # An additional action for the "About" page
  end

end
