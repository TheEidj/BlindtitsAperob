class InterludesController < ApplicationController
  before_action :set_interlude, only: [ :show, :update, :destroy ]

  def index
    interludes = Interlude.all
    render json: interludes, each_serializer: InterludeSerializer
  end

  def show
    render json: @interlude, serializer: InterludeSerializer
  end

  def create
    interlude = Interlude.new(interlude_params)

    if interlude.save
      render json: interlude, serializer: InterludeSerializer, status: :created
    else
      render json: { errors: interlude.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @interlude.update(interlude_params)
      render json: @interlude, serializer: InterludeSerializer
    else
      render json: { errors: @interlude.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @interlude.destroy
    head :no_content
  end

  private

  def set_interlude
    @interlude = Interlude.find(params[:id])
  end

  def interlude_params
    params.require(:interlude).permit(:title, :lyrics, :done)
  end
end
