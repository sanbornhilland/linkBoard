class Link < ApplicationRecord
	belongs_to :board

  after_create :notify_created

  def notify_created
    connection = ActiveRecord::Base.connection
    connection.execute "NOTIFY #{channel}, #{connection.quote self.id.to_s}"
  end

  private
  def channel
    "board_#{self.board.id}"
  end
end
