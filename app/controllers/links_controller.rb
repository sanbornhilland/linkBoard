class LinksController < ApplicationController

	def create
    link = Link.create!(links_params)

    respond_to do |format|
      if link.persisted?
        format.json {render json: link}
      else
        format.json {render json: { error_message: "Didn't work" }, status: :unprocessable_entity}
      end
    end
  end

  private

  def links_params
    merged_params = {}
    # This is throwing deprecation warning because of #to_hash. Should use #to_h instead
    merged_params.merge! params.permit(:board_id)
    merged_params.merge! params.require(:link).permit(:url)

    merged_params
  end

end
