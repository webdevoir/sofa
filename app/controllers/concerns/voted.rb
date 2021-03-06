module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    if !current_user.check_author(@votable)
      respond(@votable.vote_up(current_user))
    end
  end

  def vote_down
    if !current_user.check_author(@votable)
      respond(@votable.vote_down(current_user))
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def get_votable
    @votable = model_klass.find(params[:id])
  end

  def respond(result)
    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end
end