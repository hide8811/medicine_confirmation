class MedicinesController < ApplicationController
  def index
    @care_receiver_id = care_receiver_id_params
    @medicines = Medicine.kept
    @new_medicine = Medicine.new
  end

  def create
    @new_medicine = Medicine.new(medicine_params)
    if @new_medicine.save
      redirect_to action: :index, care_receiver_id: params[:medicine][:care_receiver_id]
    else
      render action: :index
    end
  end

  def destroy
    medicine = Medicine.find(params[:id])
    medicine.discard
    medicine_dosing_times = MedicineDosingTime.where(medicine_id: medicine.id, discarded_at: nil)
    medicine_dosing_times.discard_all

    redirect_to action: :index, care_receiver_id: params[:care_receiver_id]
  end

  private

  def medicine_params
    params.require(:medicine).permit(:name, :image, :url)
  end

  def care_receiver_id_params
    latest_route = Rails.application.routes.recognize_path(request.referer)

    return nil if latest_route[:controller] == 'care_receivers'

    return latest_route[:care_receiver_id] if latest_route[:controller] == 'dosing_times'

    return params[:care_receiver_id] if latest_route[:controller] == 'medicines'
  end
end
