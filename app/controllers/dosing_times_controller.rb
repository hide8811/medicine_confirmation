class DosingTimesController < ApplicationController
  def index
    @care_receiver_id = params[:id]
    @dosing_times = DosingTime.kept.where(care_receiver_id: @care_receiver_id).includes(:medicines)
    @medicine_dosing_time = MedicineDosingTime.new
    @medicines = Medicine.kept
    @dosing_time = DosingTime.new
    @timeframes = Timeframe.where.not(name: @dosing_times.map(&:timeframe))
  end

  def create
    @dosing_time = DosingTime.new(dosing_time_params)
    @dosing_time.save

    redirect_to action: :index, id: dosing_time_params[:care_receiver_id]
  end

  def destroy
    DosingTime.find(params[:id]).discard

    redirect_to action: :index, id: params[:care_receiver_id]
  end

  private

  def dosing_time_params
    params.require(:dosing_time).permit(:timeframe, :time, :care_receiver_id)
  end
end
