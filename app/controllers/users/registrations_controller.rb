# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def employee_uniquness
    employee_ids = User.pluck(:employee_id)
    new_employee = params[:employee]
    duplicate = employee_ids.include?(new_employee)
    render json: duplicate
  end
end
