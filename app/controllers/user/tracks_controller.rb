class User::TracksController < UsersController

  def index
    @tracks = current_user.tracks
  end

  def show
    @track = Track.find(params[:id])

    respond_to do |format|
      format.html
      format.json {
        render :json => @track.to_json(
          methods: [:polyline],
          include: {
            points: {
              methods: [:rounded_elevation]
            }
          }
        )
      }
    end
  end
end