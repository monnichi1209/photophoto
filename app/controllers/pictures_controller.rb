 class PicturesController < ApplicationController
    before_action :set_picture, only: [:show, :edit, :update, :destroy]
  
    def index
      @pictures = Picture.all
    end
  
    def new
      @picture = Picture.new
    end
  
    def create
      @picture = current_user.pictures.build(picture_params)
      @picture.user_id = current_user.id
      @picture.image.retrieve_from_cache! session[:picture_cache] if session[:picture_cache].present?
      if @picture.save
        session[:picture_cache] = nil
        PictureMailer.picture_posted(current_user).deliver_now
        redirect_to @picture, notice: 'Picture was successfully posted.'
      else
        render :new
      end
    end
    
  
    def show
      @favorite = current_user.favorites.find_by(picture_id: @picture.id)
    end
  
    def confirm
      @picture = Picture.new(picture_params)
      @picture.user_id = current_user.id
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
