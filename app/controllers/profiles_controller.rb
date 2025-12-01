class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
  
    attrs = user_params.dup
    if attrs[:password].blank? && attrs[:password_confirmation].blank?
      attrs = attrs.except(:password, :password_confirmation)
    end
  
    if @user.update(attrs)
      redirect_to root_path, notice: "Perfil actualizado correctamente."
    else
      Rails.logger.warn(@user.errors.full_messages.join(" | "))
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :phone, :address, :document_id, :email,
      :password, :password_confirmation
    )
  end
end