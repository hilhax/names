class NamesController < ApplicationController

	def index
    @filterrific = Filterrific.new(
      Name,
      params[:filterrific] || session[:filterrific_names]
    )
  
    @filterrific.select_options = {    
      with_gender: Gender.all,
      with_meaning: NameType.all,
      with_length: NameLength.all,
      with_letter: ['A','B','C','Ç','D','Dh','E','Ë','F','G','Gj','H','I','J','K','L','Ll','M','N','Nj','O','P','Q','R','Rr','S','Sh','T','Th','U','V','X','Xh','Y','Z','Zh','Gjitha germat']
    }
    
    #@names = Name.filterrific_find(@filterrific).page(params[:page])
    @names = Name.filterrific_find(@filterrific).order("name asc")
    @number_of_results = @names.count
    session[:filterrific_names] = @filterrific.to_hash

    # Respond to html for initial page load and to js for AJAX filter updates.
    respond_to do |format|
      format.html
      format.js
    end
  
    rescue ActiveRecord::RecordNotFound
      redirect_to(action: :reset_filterrific) and return
  end

  def reset_filterrific
    # Clear session persistence
    session[:filterrific_names] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to action: :index
  end

end
