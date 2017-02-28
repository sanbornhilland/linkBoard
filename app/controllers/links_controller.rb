class LinksController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'

    sse = SSE.new(response.stream)

    begin
      1.times { |i|
        sse.write({data: 'Hello World\n'}, event: 'newlink')
      }
    rescue IOError
      puts 'Client Disconnected'
    ensure
      sse.close
    end

    render nothing: true
  end

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
