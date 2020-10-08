class MedicinesController < ApplicationController
  def index
    @medicines = Medicine.all
    @new_medicine = Medicine.new
  end

  def create
    @new_medicine = Medicine.new(medicine_params)
    if @new_medicine.save
      redirect_to medicines_path
    else
      render :index
    end
  end

  private

  def medicine_params
    params.require(:medicine).permit(:name, :image, :url)
  end
end
