class PictureMailer < ApplicationMailer
  def picture_posted(user)
    @user = user

    mail to: @user.email, subject: "写真投稿の確認メール"
  end
end
