require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'library.csv'))
csv = CSV.parse(csv_text, :encoding => 'ISO-8859-1')

Benchmark.bm do |x|
  x.report {
    csv.map do |row|
      Artist.create(name: row[1])
    rescue => e
      e.message
    end

    csv.map do|row|
      Album.create(title: row[2], artist: Artist.find_by(name: row[1]))
    rescue => e
      e.message
    end

    csv.map do |row|
      Track.create(title: row[0], count: row[3].to_i, rating: row[4].to_i, len: (Time.at(row[5].to_i).utc.strftime "%M:%S"), album: Album.find_by(title: row[2]))
    rescue => e
      e.message
    end
   }

  Artist.delete_all
  Album.delete_all
  Track.delete_all

  x.report {
    csv.map do |row|
      artist_name = ActiveRecord::Base.connection.quote("#{row[1]}")
      album_title = ActiveRecord::Base.connection.quote("#{row[2]}")
      track_name = ActiveRecord::Base.connection.quote("#{row[0]}")
      count = ActiveRecord::Base.connection.quote("#{row[3].to_i}")
      rating = ActiveRecord::Base.connection.quote("#{row[4].to_i}")
      len = ActiveRecord::Base.connection.quote("#{Time.at(row[5].to_i).utc.strftime "%M:%S"}")
      date = ActiveRecord::Base.connection.quote("#{DateTime.current}")

      begin
        artist_query = "INSERT INTO artists (name, created_at, updated_at) "\
                          "VALUES (#{artist_name}, #{date}, #{date});"
        ActiveRecord::Base.connection.execute(artist_query)
      rescue => e
        e.message
      end

      begin
        artist_subquery = "SELECT id FROM artists WHERE name=#{artist_name}"
        album_query = "INSERT INTO albums (title, artist_id, created_at, updated_at) "\
                        "VALUES (#{album_title}, (#{artist_subquery}), #{date}, #{date});"
        ActiveRecord::Base.connection.execute(album_query)
      rescue => e
        e.message
      end

      begin
        album_subquery = "SELECT id FROM albums WHERE title=#{album_title}"
        track_query = "INSERT INTO tracks (title, count, rating, len, album_id, created_at, updated_at) "\
                        "VALUES (#{track_name}, #{count}, #{rating}, #{len}, (#{album_subquery}), #{date}, #{date});"
        ActiveRecord::Base.connection.execute(track_query)
      rescue => e
        e.message
      end
    end
  }
end
