class PagesController < ApplicationController
  def home
  	@title = "Home"
  end

  def about
  	@title = "About"
  end

  def copyright
  	@title = "Copyright"
  end
end
