 class PicturesController < ApplicationController
    before_action :set_picture, only: [:show, :edit, :update, :destroy]
  
    def index
      @pictures = Picture.all
    end
  
    def new
      @picture = Picture.new
    end
  
    def create
      @picture = Picture.new(picture_params)
      @picture.image.retrieve_from_cache! session[:picture_cache] if session[:picture_cache].present?
      if @picture.save
        session[:picture_cache] = nil
        redirect_to @picture
      else
        render :new
      end
    end
    
  
    def show
    end
  
    def confirm
      @picture = Picture.new(picture_params)
      if @picture.image.present?
        session[:picture_cache] = @picture.image.cache_name
        render :new if @picture.invalid?
      else
        flash[:alert] = "Image upload failed. Please try again"
        render :new
      end
    end
    

    def edit
    end
  
    def update
      if @picture.update(picture_params)
        redirect_to @picture, notice: 'Picture was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @picture.destroy
      redirect_to pictures_url, notice: 'Picture was successfully destroyed.'
    end
  
    private

    def set_picture
    @picture = Picture.find(params[:id])
    end
  
    def picture_params
    params.require(:picture).permit(:caption, :image)
    end
    end
