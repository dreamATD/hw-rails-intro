class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @movies = Movie.all
      @order = order_init
      @title_header = ""
      @release_date_header = ""
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
    
    def sorted_by 
      @order = order_init
      if @order[:ordered_by].include?(params[:sort_id])
        @title_header = params[:sort_id]=="title" ? "hilite bg-warning" : ""
        @release_date_header = params[:sort_id] == "release_date" ? "hilite bg-warning" : ""
        @movies = Movie.all.order("%s ASC" % params[:sort_id])
        respond_to do |format|
          format.html {render 'index'}       
        end
      else
        redirect_to movies_path
      end
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
    
    def order_init
      order = {}
      order[:title] = "title"
      order[:release_date] = "release_date"
      order[:ordered_by] = []
      order.keys.each do |key|
         order[:ordered_by] << "#{key.to_s}"     
      end
      return order
    end
end