require "net/http"

def get(uri)
  STDOUT.printf("GET %-50s", uri)
  STDOUT.flush

  @http ||= Net::HTTP.new("localhost", 8080)

  result = begin
             response = @http.request(Net::HTTP::Get.new(uri))
             case response
             when Net::HTTPSuccess
               "OK"
             else
               "FAIL"
             end
           rescue => e
             "FAIL"
           end

  printf("%4s\n", result)
end

desc "Test that a representative sample of the site renders correctly"
task :test do
  # should check to see if it's already running?
  get "/"
  get "/tags/"
  get "/tags/ruby/"
  get "/posts/"
  get "/posts/2010/"
  get "/posts/2010/01/"
  get "/posts/2010/01/31/the-ipad/"
end
