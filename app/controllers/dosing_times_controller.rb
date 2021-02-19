class DosingTimesController < ApplicationController
  def index
    @care_receiver = CareReceiver.find(params[:care_receiver_id])
    @dosing_times = DosingTime.list_fetch(@care_receiver)
    @medicine_dosing_time = MedicineDosingTime.new
    @medicines = Medicine.kept
    @dosing_time = DosingTime.new
    @timeframes = Timeframe.where.not(id: @dosing_times.map(&:timeframe_id))
  end

  def create
    @dosing_time = DosingTime.new(dosing_time_params)
    @dosing_time.save

    redirect_to action: :index, care_receiver_id: params[:care_receiver_id]
  end

  def destroy
    DosingTime.find(params[:id]).discard

    redirect_to action: :index, care_receiver_id: params[:care_receiver_id]
  end

  private

  def dosing_time_params
    params.require(:dosing_time).permit(:timeframe_id, :time).merge(care_receiver_id: params[:care_receiver_id])
  end
end
