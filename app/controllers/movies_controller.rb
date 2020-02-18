class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.all_ratings
    redirectFlag = 0
    
    
    
    if params[:sort]
      @sortList = params[:sort]
    else
      @sortList = session[:sort]
    end
    
    if (params[:sort]==nil && session[:sort]!=nil)
      redirectFlag=1
    end
    
    if params[:order]!= session[:order]
      session[:order]=@orderList
    end
    
    if @sortList == "title"
      @highlight_title = 'hilite'
      @movies = Movie.order(@sortList)
    elsif @sortList == "release_date"
      @highlight_release_date = 'hilite'
      @movies = Movie.order(@sortList)
    else
      @movies = Movie.all
    end
    
   
  
    if params[:ratings]
        @ratings=params[:ratings]
        @movies=@movies.where(rating: @ratings.keys)
    else
        if session[:ratings]
          @ratings=session[:ratings]
          @movies=@movies.where(rating: @ratings.keys)
        else
          @ratings=Hash[@all_ratings.collect {|rating| [rating, rating]}] #setting rating to all ratings as initially all boxes should be checked
          @movies=@movies
        end
    end
    
    if @ratings != session[:ratings]
      session[:ratings]=@ratings
    end
    
    if redirectFlag==1
        flash.keep
        redirect_to movies_path(sort: session[:sort],ratings: session[:ratings])
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

end
