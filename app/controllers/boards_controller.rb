class BoardsController < ApplicationController

	def show 
		@board = Board.find(params[:id])
		@links = @board.links
	end

end
