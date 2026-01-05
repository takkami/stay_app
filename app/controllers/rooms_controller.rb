class RoomsController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create]
  before_action :set_room, only: %i[show]

  def index
    @rooms = current_user.rooms.order(created_at: :desc)
  end

  def show
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      redirect_to rooms_path, notice: "施設が作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end
