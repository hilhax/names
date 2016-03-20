class NamesController < ApplicationController

	def index
    
    session[:filterrific_names] = nil

    @filterrific = Filterrific.new(
      Name,
      params[:filterrific] || session[:filterrific_names]
    )
  
    @filterrific.select_options = {    
      with_gender: Gender.all,
      with_meaning: NameType.all,
      with_length: NameLength.all,
      with_letter: ['A','B','C','Ç','D','Dh','E','Ë','F','G','Gj','H','I','J','K','L','Ll','M','N','Nj','O','P','Q','R','Rr','S','Sh','T','Th','U','V','X','Xh','Y','Z','Zh','Gjith']
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
      redirect_to(action: :reset) and return
  end

  def reset
    # Clear session persistence
    session[:filterrific_names] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to action: :index
  end 

  #todo, in js
  def vote_up
    begin
      if cookies[:votes_number].nil?
        cookies[:votes_number] = {
           :value => 1,
           :expires => 1.week.from_now
        }
      else
        num = cookies[:votes_number].to_i + 1
        cookies[:votes_number] = {
           :value => num,
           :expires => 1.week.from_now
        }
      end  
      if cookies[:votes_number].to_i < 4
        cookie_key = params[:id].to_s
        if cookies[cookie_key].nil?
          n = Name.find_by_id(params[:id])
          if n.rating.nil?
            n.rating = 1
          else
            n.rating = n.rating + 1
          end
          n.save!
          cookies[cookie_key] = {
             :value => true,
             :expires => 1.week.from_now
          }
        end
      #else
        #flash.no[:alert] = 'Error while sending message!'  
      end
    rescue
      puts "Error #{$!}"
    ensure   
      # TODO , fix
      render 'index'

    end 
  end
end
