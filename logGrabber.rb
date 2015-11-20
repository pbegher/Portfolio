#!/bin/ruby/env
#USAGE: rubygrab 2015-07-10 2015-08-11 11536 "impression"

require 'date'

randomNumber = ARGV[3]

datesplit = Date.parse('2015-08-01')
inputfiles = []

(Date.parse(ARGV[0]) .. Date.parse(ARGV[1])).each do |date| 
  if date < datesplit then
    prefix = "#{amazonURL}"
  else
    prefix = "#{amazonURL2}"
  end
  inputfiles << "#{prefix}/#{'%04d' % date.year}/#{'%02d' % date.month}/#{'%02d' % date.day}/#{ARGV[2].to_s}"	#'%02d' % variable => two digit format
end

# #RandomNumber for hadoop job call to make it unique
#	randomNumber = rand(10 ** 10)

`hadoop jar heston-tools-1.0.1-SNAPSHOT.jar -Dre=\"impression\" spongecell/tools/LogGrab #{randomNumber} #{inputfiles.join(" ")}`
puts randomNumber


##Classical code version and additional details as to the function of this script:

# require 'date'


# if ARGV[0] > ARGV[1]
# 	puts "The second date must be greater than or equal to the first date."
# 	exit if ARGV[0] > ARGV[1]
# end

# m = Date.parse(ARGV[0]).to_s
# n = Date.parse(ARGV[1]).to_s
# flight = ARGV[2]
# type = ARGV[3]

# # year = Date.parse(m.to_s).year
# # puts year
# # month = Date.parse(m.to_s).month
# # puts month
# # day = Date.parse(m.to_s).day
# # day = '0' + day.to_s
# # puts day

# link = ''
# def s3links(m,n,flight)
# 	datesplit = '20150801'

# 	while m.to_s < n

# 		year = Date.parse(m.to_s).year
# 		month = Date.parse(m.to_s).month
# 		date = Date.parse(m.to_s).day

# 		#For single digit months and dates, add a zero to the tens digit
# 		if date < 10
# 			date = '0' + date.to_s
# 		end	
# 		if month < 10
# 			month = '0' + month.to_s
# 		end
			
# 		#Create different URL for pre- and post- 8/1/2015 (change of log storing)
# 		if Date.parse(m.to_s) < Date.parse(datesplit.to_s)
# 			link = [link.to_s,"#{amazonURL}#{year.to_s}/#{month.to_s}/#{date.to_s}/#{flight.to_s}"].join(" ")
# 		else
# 			link = [link.to_s,"#{amazonURL2}#{year.to_s}/#{month.to_s}/#{date.to_s}/#{flight.to_s}"].join(" ")
# 		end

# 		#Increment to the next date
# 		m = Date.parse(m.to_s) + 1
# 	end

# 	link
# end

# #RandomNumber for hadoop job call to make it unique
# 	randomNumber = rand(10 ** 10)

# #NOTE: instead of \" you can use '. 
# `hadoop jar heston-tools-1.0.1-SNAPSHOT.jar -Dre=\"impression\" spongecell/tools/LogGrab #{randomNumber} #{s3links(m,n,flight)}`

# # puts Date.parse(ARGV[0])
# # n = Date.parse(ARGV[0])
# # puts Date.parse(n.to_s)

# # m = Date.parse(ARGV[0])+1
# # puts Date.parse(m.to_s)

# # if m > n
# # 	puts "yes"
# # else
# # 	puts "no"
# # end

# # if m.to_s > n.to_s
# # 	puts "yes"
# # else 
# # 	puts "no"
# # end

# # if Date.parse(m.to_s) > Date.parse(n.to_s)
# # 	puts "yes"
# # else
# # 	puts "no"
# # end
