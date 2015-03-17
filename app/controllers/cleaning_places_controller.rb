# encoding: utf-8

class CleaningPlacesController < ApplicationController
  def index
    @places = CleaningPlace.all
  end
end
