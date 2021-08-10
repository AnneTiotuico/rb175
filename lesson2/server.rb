require "socket"

server = TCPServer.new("localhost", 8080)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  http_method, path_params = request_line.split
  path = path_params.scan(/\d(\/[a-z]*)\?/).flatten[0]
  params = path_params.scan(/\?(.*)/).flatten[0].split('&').map { |x| x.split('=')  }.to_h
  
  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts request_line
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"

  client.puts "<a href='?number=#{number+1}'>Add one</a>"
  client.puts "<a href='?number=#{number-1}'>Subtract one</a>"

  client.puts "</body>"
  client.puts "</html>"
  client.close
end
