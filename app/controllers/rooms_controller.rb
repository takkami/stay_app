class RoomsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show new create edit update destroy]
  before_action :set_room, only: %i[show edit update destroy]

  def index
    @rooms = current_user.rooms.order(created_at: :asc)
  end

  # before_action で取得済み
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

  # before_action で取得済み
  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to room_path(@room), notice: "施設情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy
    if @room.destroy
      redirect_to rooms_path, notice: "施設が削除されました"
    else
      redirect_to rooms_path, alert: "施設の削除に失敗しました"
    end
  end

  private

  def set_room
    @room = current_user.rooms.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end
