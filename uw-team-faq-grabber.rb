require 'net/http'

puts 'UW-TEAM FAQ DOWNLOADER'
puts 'This script will download all the materials present on http://www.uw-team.org/faq.html'

$dir = "uwteam"
Dir.mkdir $dir if not Dir.exist? $dir

uri = URI('http://www.uw-team.org/faq.html')

site = Net::HTTP.get(uri)


$origin = "http://www.uw-team.org/data"

# find all links and returns a list of them
def scan_for_links(str)
    list = []
    match_data = str.scan(/<a href="data([^"]+)/)
    puts "Found " + match_data.length.to_s + " links to files."
    return match_data.to_a
end

$paths = scan_for_links(site)


# does all the job
def download
    $paths.each do |p|
        p = p[0] # shit comes as array length 1
        path = $dir + p

        File.open(path, "wb") do |file|
            print "Downloading " + p + "... "            
            file.write(Net::HTTP.get(URI($origin + p)))
            print "Saved to " + path + "\n"
        end
    end
end



download()

puts "success"
