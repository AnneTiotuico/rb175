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
  
  def highlight_text(text, search_text)
    text.gsub(search_text, "<strong>#{search_text}</strong>")
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

get "/search" do
  @title = "Search"
  @search_text = params[:query]
  @results = ''
  @found = {}
  
  if @search_text
    @contents.each_with_index do |ch, idx|
      @ch_text = File.read("data/chp#{idx + 1}.txt")
      if @ch_text.include?(@search_text)
        @found[ch] = idx
      end
      
    end
    unless @found.empty?
      @results = "<h2 class='content-subhead'>Results for '#{@search_text}'</h2>"
    else
      @results = "<p>Sorry, no matches were found.</p>"
    end
  end
  
  
  
  erb :search
end

=begin 
if results are found, display "<h2>Results for 'truck'<h2>"
and the chapter links
else, display <p>"Sorry, no matches found"</p>

if text is found in any chapters, return that chapter and a link to it as an unordered list
iterate through each chapter and see if the text is matched in the chapter, if so return that chapter title


=end