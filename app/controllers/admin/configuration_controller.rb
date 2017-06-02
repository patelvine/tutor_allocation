module Admin
  class ConfigurationController < ApplicationController
    #before_filter :authorize_tm

    def index
    end

    def calculate_num_tutors
      Course.recalculate_all_tutors!
      redirect_to request.env["HTTP_REFERER"], flash: { notice: "Successfully calculated the number of required tutors for all courses" }
    end

    def deadline
      if params[:date]
        if Admin::Configuration.deadline = params[:date]
          redirect_to request.env["HTTP_REFERER"], flash: { notice: "Updated deadline date" }
        else
          redirect_to request.env["HTTP_REFERER"], flash: { error: "Could not save deadline date" }
        end
        return
      end
      redirect_to request.env["HTTP_REFERER"], flash: { error: "Could not save deadline date" }
    end

    def tutor_hours
      if params[:hours]
        if Admin::Configuration.set_tutor_hours params[:hours]
          redirect_to request.env["HTTP_REFERER"], flash: { notice: "Updated hours per tutor" }
        else
          redirect_to request.env["HTTP_REFERER"], flash: { error: "There was an error updating the hours." }
        end
      else
        redirect_to request.env["HTTP_REFERER"]
      end
    end

    def course_hours
      required = ["100level", "200level", "300level", "400level"]
      if required.any?{|l| !params.include?(l) }
        redirect_to request.env["HTTP_REFERER"], flash: { error: "There was an error updating one or more parameter." }
      else
        error = false
        required.each do |level|
          unless Admin::Configuration.set_course_hours(level.slice(0,3), params[level])
            error = true
          end
        end

        if error
          redirect_to request.env["HTTP_REFERER"], flash: { error: "There was an error updating one or more parameter." }
        else
          redirect_to request.env["HTTP_REFERER"], flash: { notice: "Updated enrollment hours per course level." }
        end
      end
    end

    def year_and_term
      if params[:year] && params[:term]
        flashes = {notice: [], error: []}
        if Admin::Configuration.set_year params[:year]
          flashes[:notice] << "Successfully updated current year"
        else
          flashes[:error] << "Failed to update year"
        end
        if Admin::Configuration.set_term params[:term]
          flashes[:notice] << "Successfully updated current term"
        else
          flashes[:error] << "Failed to update term"
        end
        flashes.reject!{|k,v| v.empty?}
        flashes_out = {}
        flashes.map{|k,v| flashes_out[k] = v.join("<br />")}

        redirect_to request.env["HTTP_REFERER"], flash: flashes_out
      end
    end

    def import_courses
      # STUB, use the helper in admin/configuration_helper
    end

  end
end
