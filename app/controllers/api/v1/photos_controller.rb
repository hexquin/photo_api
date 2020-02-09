class Api::V1::PhotosController < ApplicationController
  before_action :get_photo, only: %i(show update)
  def index
    @photos = Photo.all
    render json: @photos
  end
  def show
    render json: @photo
  end
  def update
    @photo.update(photo_params)
    if @photo.valid?
      render json: @photo
    else
      render json: { errors: @photo.errors.full_messages }
    end
  end
  private
    def photo_params
      params.require(:photo).permit(:title, :photo_url_string)
    end
    def get_photo
      @photo = Photo.find(params[:id])
    end
end
