class Admin::HourlyRatesController < ApplicationController
  #before_filter :authorize_tm

  def index
    @years_experience = Admin::HourlyRates.years_experience
    @levels = Admin::HourlyRates.levels
    @hourly_rates = Admin::HourlyRates.all
  end

  def update
    hourly_rates_params.each do |id, rate_param|
      r = Admin::HourlyRates.find(id)
      r.update_column(:rate, rate_param[:rate])
    end
    redirect_to admin_hourly_rates_path
  end

  private

  def hourly_rates_params
    permitted_fields = []
    params[:admin_hourly_rates].each do |k,v|
      permitted_fields << {k => [:rate]}
    end
    params.require(:admin_hourly_rates).permit(permitted_fields)
  end
end
