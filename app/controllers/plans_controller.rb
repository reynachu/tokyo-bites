class PlansController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index

  def index
    # Temporary placeholder
    @plans = []
  end
end
