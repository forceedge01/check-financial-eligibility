class DependantsController < ApplicationController
  def create
    if creation_service_result.success?
      render json: {
        success: true,
        objects: creation_service_result.dependants,
        errors: []
      }
    else
      render json: {
        success: false,
        objects: nil,
        errors: creation_service_result.errors
      }, status: 422
    end
  end

  private

  def creation_service_result
    @creation_service_result ||= DependantsCreationService.call(request.raw_post)
  end
end