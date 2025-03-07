class HomeController < ApplicationController
  skip_before_action :authenticate_person!, only: [:index]
  
  def index
  end
end
