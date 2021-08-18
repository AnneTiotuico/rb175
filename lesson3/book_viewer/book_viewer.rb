require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do 
  def in_paragraphs(text)
    text.split("\n\n")
  end
end

not_found do
  redirect "/"
end


get "/" do
  @title = "The Adventures of Sherlock Holmes"
  
  erb :home
end

get "/chapters/:number" do
  @number = params[:number].to_i
  @chapter_title = @contents.at(@number - 1)
  
  redirect "/" unless (1..@contents.size).cover?(@number)
  
  
  @title = "Chapter #{@number} - #{@chapter_title}"
  @chapter = File.read("data/chp#{@number}.txt")
  
  erb :chapter
end

get "/show/:name" do
  params[:name]
end
