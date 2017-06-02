class AllocationLinkController < ApplicationController
  #before_action :authorize_tm, except: [:accept, :reject]
  #before_action :authorize_cc, only: [:accept, :reject]
  #before_action :check_awaiting, only: [:accept, :reject]

  def create
    if params[:ids] && params[:application_id]
      current_allocations = AllocationLink.where(tutor_application_id: params[:application_id]).map(&:course_id)
      params[:ids].each do |id|
        id = id.to_i
        if !current_allocations.include? id
          AllocationLink.create({
            tutor_application_id: params[:application_id],
            course_id: id,
            state: :awaiting
          })
        else
          current_allocations.delete(id)
        end
      end
      current_allocations.each do |id|
        AllocationLink.where(course_id: id, tutor_application_id: params[:application_id]).map(&:delete)
      end
    else
      AllocationLink.where(tutor_application_id: params[:application_id]).map(&:delete)
    end

    redirect_to request.env["HTTP_REFERER"], flash: { notice: "Successfully (un)allocated tutor to selected courses" }
  end

  def destroy
    if params[:id]
      al = AllocationLink.find(params[:id])
      course = al.course
      al.unallocated!
      redirect_to course_path(course), flash: {notice: "Allocation removed"}
    end
  end

  def update_state
    @allocation_link = AllocationLink.find(params[:id])
    if @allocation_link.update_attributes(allocation_link_params)
      #overallocated needs to be evaluated AFTER updating, hence the repition
      overallocated = @allocation_link.tutor_application.allocation_links.allocated.size > 2
      render json: {response: "success", overallocated: overallocated}
    else
      overallocated = @allocation_link.tutor_application.allocation_links.allocated.size > 2
      render json: {response: "failure", overallocated: overallocated}
    end
  end

  def accept
    if params[:id]
      current_allocation = AllocationLink.find(params[:id])
      if correct_cc current_allocation
        redirect_to login_path, flash: {notice: "You are not authorised."} and return
      elsif current_allocation.shortlisted? || current_allocation.rejected?
        current_allocation.update(state: :accepted)
        redirect_to course_path(current_allocation.course), flash: {notice: "Allocation accepted"}
      else
        redirect_to course_path(current_allocation.course), flash: {notice: "Allocation failed"}
      end
    end
  end

  def reject
    if params[:id]
      current_allocation = AllocationLink.find(params[:id])
      if correct_cc current_allocation
        redirect_to login_path, flash: {notice: "You are not authorised."} and return
      elsif current_allocation.shortlisted? || current_allocation.accepted?
        current_allocation.update(state: :rejected)
        redirect_to course_path(current_allocation.course), flash: {notice: "Allocation rejected"}
      else
        redirect_to course_path(current_allocation.course), flash: {notice: "Allocation failed"}
      end
    end
  end

  private

  def check_awaiting
    if params[:id]
      al = AllocationLink.where(id: params[:id]).first
      if al
        if !al.course.awaiting_cc? && current_user.CC?
          redirect_to request.env["HTTP_REFERER"], flash: { error: "You can not modify applications at this time" }
        end
      end
    end
  end

  def allocation_link_params
    params.require(:allocation_link).permit(:state)
  end

  def correct_cc(allocation)
    return current_user.id != allocation.course.course_coordinator_id
  end
end
