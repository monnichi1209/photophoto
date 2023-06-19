class FavoritesController < ApplicationController
  protect_from_forgery with: :exception
  include SessionsHelper

  def create
    favorite = current_user.favorites.create(picture_id: params[:picture_id])
    redirect_to pictures_url, notice: "#{favorite.picture.user.name}'さんの写真をお気に入り登録しました。"
  end

  def destroy
    favorite = current_user.favorites.find_by(id: params[:id])
    if favorite
      favorite.destroy
      redirect_to pictures_path, notice: "#{favorite.picture.user.name}さんの写真をお気に入り解除しました"
    else
      redirect_to pictures_path, alert: "お気に入りが見つかりませんでした"
    end
  end
  
private
def authenticate_user!
unless logged_in?
redirect_to new_session_path
end
end
end
