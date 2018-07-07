require 'sinatra'
require 'find'
require 'pry'

lista_canciones = []

Find.find('cancion/') do |ruta|
  lista_canciones.push(ruta) if ruta != "cancion/"
end

song_path = "li.html"

get "/" do 
  lista_canciones = []

    Find.find('cancion/') do |ruta|
      lista_canciones.push(ruta) if ruta != "cancion/"
    end
  file_name = "./cancionero.html"
  file = File.open(file_name, "r")
  html = file.read
  file.close
  
      song_lis = lista_canciones.map do |cancion|
      li = File.open(song_path,"r")
      li_html = li.read
      li_html = li_html % {:cancion_name => cancion}
      li.close
      li_html
    end
  
  html = html % {:lista_canciones => song_lis.join('<br>') }
  html
end

get '/cancion/:cancion_name' do
  file_name = lista_canciones.find {|file| file == "cancion/#{params[:cancion_name]}"}
  file = File.open(file_name, "r")
  lyrics = file.read
  plain_lyrics = lyrics
  lyrics = lyrics.gsub("\n", '<br>')
  file.close

  cancion_template = "../client/cancion_template.html"
  file2= File.open(cancion_template,"r")
  html = file2.read
  file2.close
  cancion_name = params[:cancion_name]
  html = html % {:lyrics => lyrics, :cancion_name => cancion_name, :plain_lyrics => plain_lyrics}
  html
end

post "/cancion" do
  cancion_name = params[:canciones_name]
  lyrics_content = params[:cancion_lyrics]

  cancion_path = "cancion/#{cancion_name}.txt"
  cancion_file = File.open(cancion_path, "w")
  cancion_file.write(lyrics_content)
  cancion_file.close()
  redirect "/"
end

post "/cancion/:cancion_name" do
  cancion_name = params[:cancion_name]
  cancion_path = "cancion/#{cancion_name}"
  File.delete(cancion_path)
  redirect "/"
end

post "/cancion/:cancion_name/update" do
  cancion_name = params[:cancion_name]
  lyrics_content = params[:cancion_lyrics]

  cancion_path = "cancion/#{cancion_name}"
  cancion_file = File.open(cancion_path, "w")
  cancion_file.write(lyrics_content)
  cancion_file.close

  redirect "/cancion/" + cancion_name
end


