class DogsController < ApplicationController
  respond_to :json
  
  def index
    @dogs = Dog.includes(:breed).order(:name).all
    render :json => {:dogs => @dogs}
  end

  def create
    @dog = Dog.new(params[:dog])
    @dog.save
    render :json => {:dog => @dog.as_json(:only => [:id, :name, :breed_id, :breed_name, :bottoms_sniffed, :cats_chased, :faces_licked])}
  end

  def show
    @dog = Dog.includes(:breed).find params[:id]
    render :json => {:dog => @dog.as_json(:only => [:id, :name, :breed_id, :breed_name, :bottoms_sniffed, :cats_chased, :faces_licked])}
  end

  def update
    @dog = Dog.includes(:breed).find params[:id]
    @dog.update_attributes(params[:dog])
    @dog.save
    render :json => {:dog => @dog.as_json(:only => [:id, :name, :breed_id, :breed_name, :bottoms_sniffed, :cats_chased, :faces_licked])}
  end

  def destroy
    @dog = Dog.find params[:id]
    @dog.delete
    render :json => {}
  end
end
