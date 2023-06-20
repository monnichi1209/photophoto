 class PicturesController < ApplicationController
    before_action :set_picture, only: [:show, :edit, :update, :destroy]
    before_action :require_permission, only: [:edit, :update, :destroy]
    before_action :authenticate_user, only: [:confirm]

  
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
        #PictureMailer.picture_posted(current_user).deliver_now
        redirect_to @picture, notice: '写真の投稿が完了しました.'
      else
        render :new
      end
    end
    
  
    def show
      @favorite = current_user.favorites.find_by(picture_id: @picture.id)
    end
  
    
    

    def edit
      @picture = Picture.find(params[:id])
      unless current_user == @picture.user
        redirect_to pictures_path, alert: "他人の投稿を編集することはできません。"
      end
    end
    
    def confirm
      @picture = Picture.new(picture_params)
      @picture.user_id = current_user.id
  
      unless @picture.image.present?
        flash[:alert] = "No image uploaded. Please try again"
        render :new
        return
      end
  
      session[:picture_cache] = @picture.image.cache_name
  
      if @picture.invalid?
        render :new
      end
    end  

    def update
      unless current_user == @picture.user
        redirect_to pictures_path, alert: "他人の投稿を編集することはできません。"
        return
      end

      if @picture.update(picture_params)
        redirect_to @picture, notice: '編集が完了しました.'
      else
        render :edit
      end
    end
  
    def destroy
      @picture.destroy
      redirect_to pictures_url, notice: '投稿を削除しました.'
    end
  
    private

    def set_picture
    @picture = Picture.find(params[:id])
    end
  
    def picture_params
    params.require(:picture).permit(:caption, :image)
    end

    def require_permission
    picture = Picture.find(params[:id])
    unless current_user == @picture.user
    redirect_to pictures_path, alert: "他人の投稿を編集することはできません。"
    end
    end

    def authenticate_user
    if current_user.nil?
    redirect_to login_url, alert: "You must be logged in to access this page."
    end
    end

    end
