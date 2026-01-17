class RoomsController < ApplicationController
  before_action :authenticate_user!, only: %i[own new create edit update destroy]
  before_action :set_room, only: %i[show]
  before_action :set_own_room, only: %i[edit update destroy]

  def index
    @rooms = Room.all

    # エリア検索（住所：あいまい検索）
    if params[:area].present?
      area = ActiveRecord::Base.sanitize_sql_like(params[:area])
      @rooms = @rooms.where("address LIKE ?", "%#{area}%")
    end

    # キーワード検索（施設名 + 施設詳細：あいまい検索）
    if params[:keyword].present?
      keyword = ActiveRecord::Base.sanitize_sql_like(params[:keyword])
      @rooms = @rooms.where("name LIKE ? OR description LIKE ?", "%#{keyword}%", "%#{keyword}%")
    end

    @rooms = @rooms.order(created_at: :asc)
    @total_count = @rooms.count
  end

  def own
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
      redirect_to room_path(@room), notice: "施設が作成されました"
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
    redirect_to own_rooms_path, notice: "施設が削除されました"
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def set_own_room
    @room = current_user.rooms.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end
