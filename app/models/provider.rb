class Provider < ApplicationRecord

    belongs_to :created_by, class_name: "User", optional: true
    belongs_to :updated_by, class_name: "User", optional: true

    # Normalizaciones simples
    before_validation { self.email = email.to_s.strip.downcase }
    before_validation { self.cuit  = cuit.to_s.gsub(/[^0-9]/, "") } # deja solo dígitos

    # Validaciones
    validates :name, presence: true, length: { maximum: 120 }
    validates :email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :cuit,  allow_blank: true, length: { in: 11..13 } # 11 dígitos (con o sin guiones)
    validates :status, inclusion: { in: [true, false] }

    has_many :items, dependent: :restrict_with_error

end
