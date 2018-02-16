class User::TracksController < UsersController

  def index
    @tracks = current_user.tracks
  end

  def show
    @track = Track.find(params[:id])
  end
end