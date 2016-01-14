#!/bin/ruby

spongeArray = []
spongeKey = 'start'


File.open("testKeys.txt").readlines.each do |line|
	spongeArray.push line
end

hadoopURL = ''	#Enter URL here

## Test that spongeArray is storing spongeKeys:

# puts spongeArray[0]
# puts spongeArray[1]


i = 0
while i < spongeArray.length
	#spongeKey = gets.chomp
	if spongeArray[i] != ''
		spongeKey = spongeArray[i].chomp

		##Query from the SIX cassandra machines
		Kernel.system "curl #{hadoopURL.to_s}=#{spongeKey.to_s}>temp.log"

		##Query form local host - !!!!!!! GET WITH JASON ABOUT THIS !!!!!!!!
		#Kernel.system "curl http://localhost.spongecell.net:8080/events?visitor=#{spongeKey.to_s}>temp.log"
		
		#Remove this line from the final file.
		Kernel.system 'cat temp.log | grep -v -E "\-\-_curl_\-\-" >> spongeKeyLogs.log'
		
		Kernel.system 'rm temp.log'

		i += 1
		end
end

