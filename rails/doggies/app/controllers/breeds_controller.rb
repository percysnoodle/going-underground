class BreedsController < ApplicationController
  respond_to :json
  
  def index
    @breeds = Breed.order(:name).all
    render :json => {:breeds => @breeds}
  end

  def show
    @breed = Breed.find params[:id]
    render :json => {:breed => @breed.as_json(:include => {:dogs => {:only => [:id, :name]}})}
  end

  def dogs
    @breed = Breed.find params[:breed_id]
    render :json => {:dogs => @breed.dogs.as_json(:only => [:id, :name])}
  end
end
