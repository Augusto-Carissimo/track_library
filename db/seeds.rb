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
    sql = "INSERT INTO artists (name, created_at, updated_at) "\
      "VALUES ('#{row[1]}', '#{DateTime.current}', '#{DateTime.current}');"
    ActiveRecord::Base.connection.execute(sql)
    rescue => e
      e.message
    end

    csv.map do|row|
      subquery = "SELECT id FROM artists WHERE name='#{row[1]}'"
      sql =
      "INSERT INTO albums (title, artist_id, created_at, updated_at) "\
        "VALUES ('#{row[2]}', (#{subquery}), '#{DateTime.current}', '#{DateTime.current}');"
      ActiveRecord::Base.connection.execute(sql)
    rescue => e
      e.message
    end

    csv.map do |row|
      subquery = "SELECT id FROM albums WHERE title='#{row[2]}'"
      sql =
      "INSERT INTO tracks (title, count, rating, len, album_id, created_at, updated_at) "\
        "VALUES ('#{row[0]}', '#{row[3].to_i}', '#{row[4].to_i}', '#{Time.at(row[5].to_i).utc.strftime "%M:%S"}', (#{subquery}), '#{DateTime.current}', '#{DateTime.current}');"
      ActiveRecord::Base.connection.execute(sql)
    rescue => e
      e.message
    end
   }
end
