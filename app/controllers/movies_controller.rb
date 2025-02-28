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
    @sort = params[:sort]
    if !@sort
      @sort = session[:sort]
    else
      session[:sort] = @sort
    end
    @all_ratings = Movie.ratings.keys

    @selected = params[:ratings]
    if !@selected
      @selected = session[:ratings] || Movie.ratings
    else
      session[:ratings] = @selected
    end


    @movies = Movie.with_ratings(@selected.keys)
    @movies = @movies.order(@sort)
    if @sort == "title"
      @style_title_header = "hilite bg-warning"
    end
    if @sort == "release_date"
      @style_release_date_header = "hilite bg-warning"
    end

    if session[:sort] != params[:sort] or session[:ratings] != params[:ratings]
      flash.keep
      redirect_to movies_path(sort: @sort, ratings: @selected)
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
