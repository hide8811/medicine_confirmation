class DosingTimesController < ApplicationController
  def index
    @care_receiver_id = params[:id]
    @dosing_times = DosingTime.where(care_receiver_id: @care_receiver_id)
    @medicine_dosing_time = MedicineDosingTime.new
    @dosing_time = DosingTime.new
    @timeframes = Timeframe.where.not(name: @dosing_times.map(&:timeframe))
  end

  def create
    @dosing_time = DosingTime.new(dosing_time_params)
    @dosing_time.save

    redirect_to action: :index, id: dosing_time_params[:care_receiver_id]
  end

  def destroy; end

  private

  def dosing_time_params
    params.require(:dosing_time).permit(:timeframe, :time, :care_receiver_id)
  end
end
