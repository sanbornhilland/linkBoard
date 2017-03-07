class LinksController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'

    sse = SSE.new(response.stream)

    begin
      on_link_created do |link_id|
        puts "Received Link created event"
        link = Link.find(link_id)

        sse.write({data: link.as_json}, event: "newlink")
      end
    rescue IOError
      puts "Client Disconnected"
    ensure
      puts "SSE is Closing"
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

  def on_link_created
    connection = ActiveRecord::Base.connection
    connection.execute "LISTEN #{channel}"

    connection.raw_connection.wait_for_notify do |event, pid, link|
      yield link
    end
  ensure
    puts "Unlistening from channel"
    connection.execute "UNLISTEN #{channel}"
  end

  def links_params
    merged_params = {}
    # This is throwing deprecation warning because of #to_hash. Should use #to_h instead
    merged_params.merge! params.permit(:board_id)
    merged_params.merge! params.require(:link).permit(:url)

    merged_params
  end

  # Creation of link associated with board x should broadcast an event
  # on channel board_x
  def channel
    "board_#{params[:board_id]}"
  end

end
