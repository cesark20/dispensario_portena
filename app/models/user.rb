class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Definir roles con enum
  enum role: {
    client: 0,
    employee: 1,
    seller: 2,
    admin: 3,
    superadmin: 4
  }

  # Establecer el rol predeterminado al crear un usuario
  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :client
  end
end
