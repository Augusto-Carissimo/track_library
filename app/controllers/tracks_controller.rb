class TracksController < ApplicationController
  def index
    sql = "SELECT tracks.title, artists.name, albums.title, tracks.len, tracks.rating
    FROM tracks
      JOIN albums ON tracks.album_id = albums.id
      JOIN artists ON albums.artist_id = artists.id;"

    @tracks = ActiveRecord::Base.connection.execute(sql).values
  end
end
