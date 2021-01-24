class MedicineDosingTimesController < ApplicationController
  def create
    @medicine_dosing_time = MedicineDosingTime.new(medicine_dosing_time_params)
    @medicine_dosing_time.save

    redirect_to controller: :dosing_times, action: :index, id: care_receiver_params[:care_receiver_id]
  end

  def destroy
    MedicineDosingTime.find(params[:id]).discard

    redirect_to controller: :dosing_times, action: :index, id: params[:care_receiver_id]
  end

  private

  def medicine_dosing_time_params
    params.require(:medicine_dosing_time).permit(:medicine_id, :dosing_time_id)
  end

  def care_receiver_params
    params.require(:medicine_dosing_time).permit(:care_receiver_id)
  end
end
