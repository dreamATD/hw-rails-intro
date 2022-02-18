class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      # sort related
      @sort = params[:sort_id] || session[:sort_id]
      @title_header = params[:sort_id]=="title" ? "hilite bg-warning" : ""
      @release_date_header = params[:sort_id] == "release_date" ? "hilite bg-warning" : ""
      session[:sort_id] = @sort
      
      # rating related
      @all_ratings = Movie.ratings
      checked_list = params[:ratings] || session[:ratings]
      @rating_checked = checked_list.nil? ? @all_ratings : checked_list.keys
      session[:ratings] = checked_list
      
      @movies = Movie.with_ratings(@rating_checked).order(@sort)
      if ( params[:sort_id].nil? && !(session[:sort_id].nil?) ) || ( params[:ratings].nil? && !(session[:ratings].nil?) )
        flash.keep
        redirect_to movies_path(sort_id: session[:sort_id], ratings: session[:ratings])
      end
      
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end