class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[create]
  before_action :set_reservation, only: %i[edit update destroy]

  def confirm
    if request.post?
      @room = Room.find(params[:reservation][:room_id])
      @reservation = @room.reservations.new(reservation_params)
      @reservation.user = current_user

      if @reservation.valid?
        return redirect_to confirm_reservations_path(
          reservation: reservation_params.merge(room_id: @room.id)
        )
      end

      flash[:alert] = @reservation.errors.full_messages.join(" / ")
      return redirect_to room_path(@room)
    end

    @room = Room.find(params[:reservation][:room_id])
    @reservation = @room.reservations.new(reservation_params)
    @reservation.user = current_user

    @nights = @reservation.nights
    @total_price = @nights * @reservation.people.to_i * @room.price

    render :confirm
  end

  def create
    @reservation = @room.reservations.new(reservation_params)
    @reservation.user = current_user

    if @reservation.valid?
      nights = @reservation.nights
      @reservation.total_price = calculate_total_price(@room, nights, @reservation.people)

      if @reservation.save
        redirect_to reservations_path, notice: "施設の予約が完了しました"
      else
        redirect_to room_path(@room), alert: "予約の保存に失敗しました"
      end
    else
      redirect_to room_path(@room), alert: @reservation.errors.full_messages.join(" / ")
    end
  end

  def index
    @reservations = current_user.reservations.includes(:room).order(created_at: :asc)
  end

  # before_action で取得済み
  def edit
  end

  def update
    if @reservation.update(reservation_params)
      nights = @reservation.nights
      @reservation.update!(total_price: calculate_total_price(@reservation.room, nights, @reservation.people))

      redirect_to reservations_path, notice: "予約を変更しました"
    else
      flash.now[:alert] = @reservation.errors.full_messages.join(" / ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.destroy
    redirect_to reservations_path, notice: "予約を削除しました"
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_reservation
    @reservation = current_user.reservations.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:room_id, :check_in, :check_out, :people)
  end

  def calculate_total_price(room, nights, people)
    nights * people.to_i * room.price
  end
end
