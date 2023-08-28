require 'webrick'

root = File.expand_path './build/selfcontained'
server = WEBrick::HTTPServer.new :Port => 3000, :DocumentRoot => root
server.mount '/latest', WEBrick::HTTPServlet::FileHandler, root

trap 'INT' do server.shutdown end

server.start
