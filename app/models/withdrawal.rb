# app/models/withdrawal.rb
class Withdrawal < ApplicationRecord
  KINDS = %w[patient nursing].freeze
  REIMB = %w[full half none].freeze

  belongs_to :patient,       class_name: "User", optional: true
  belongs_to :internal_user, class_name: "User", optional: true
  has_many   :withdrawal_lines, dependent: :destroy

  accepts_nested_attributes_for :withdrawal_lines, allow_destroy: true

  validates :kind, inclusion: { in: KINDS }
  validates :reimbursement, inclusion: { in: REIMB }
  validates :occurred_at, presence: true
  validates :patient_id, presence: true, if: -> { kind == "patient" }
  validates :internal_user_id, presence: true, if: -> { kind == "nursing" }

  before_validation :force_full_for_nursing

  def pay_factor
    case reimbursement
    when "full" then 0.0
    when "half" then 0.5
    else 1.0
    end
  end

  private
  def force_full_for_nursing
    self.reimbursement = "full" if kind == "nursing"
  end
end