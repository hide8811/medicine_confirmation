class CareReceiversController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery prepend: true

  def index
    @care_receivers = CareReceiver.kept
  end

  def new
    @care_receiver = CareReceiver.new
  end

  def create
    @care_receiver = CareReceiver.new(care_receiver_params)

    if @care_receiver.save
      redirect_to root_path, flash: { success: '登録しました' }
    else
      render :new
    end
  end

  def show
    @care_receiver = CareReceiver.find(params[:id])
    @care_receiver_age = (Date.today.strftime('%Y%m%d').to_i - @care_receiver.birthday.strftime('%Y%m%d').to_i) / 10_000

    @dosing_times = DosingTime.kept.where(care_receiver_id: @care_receiver.id).includes(:medicines)
  end

  def edit
    @care_receiver = CareReceiver.find(params[:id])
  end

  def update
    care_receiver = CareReceiver.find(params[:id])

    if care_receiver.update(care_receiver_params)
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  def destroy
    care_receiver = CareReceiver.find(params[:id])
    care_receiver.discard

    redirect_to root_path, flash: { delete: '削除しました' }
  end

  private

  def care_receiver_params
    params.require(:care_receiver).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :birthday, enroll: true)
  end
end
