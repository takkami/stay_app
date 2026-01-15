class UsersController < ApplicationController
  before_action :authenticate_user!

  def account
  end

  def profile
  end

  # users/edit_profile.html.erb を表示する
  def edit_profile
  end

  def update_profile
    if current_user.update(profile_params)
      redirect_to users_profile_path, notice: "プロフィール情報が変更されました"
    else
      render :edit_profile, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:avatar, :name, :introduction)
  end
end
