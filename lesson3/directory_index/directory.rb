require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do 
   @listings = Dir.children("public")
   if params[:sort].nil?
       @path = "/?sort=desc"
       @sort = "descending"
       @listings.sort!
   elsif params[:sort] == "desc"
       @path = "/"
       @sort = "ascending"
       @listings.reverse!
   end
   
   erb :listings
end

