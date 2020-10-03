class MedicinesController < ApplicationController
  def index
    @medicines = Medicine.all
  end
end
