#!/bin/ruby

#USAGE: ruby rubyLoad.rb 2015-07-10 2015-08-11 11536

require 'date'

amazonURL = ''	#Insert Amazon s3n:// URL

(Date.parse(ARGV[0]) .. Date.parse(ARGV[1])).each do |date| 

Kernel.system "hadoop distcp -overwrite /tmp/actual_files/#{'%04d' % date.year}/#{'%02d' % date.month}/#{'%02d' % date.day}/#{ARGV[2].to_s} #{amazonURL}#{'%04d' % date.year}/#{'%02d' % date.month}/#{'%02d' % date.day}/#{ARGV[2].to_s}"

#To test output
#print "hadoop distcp -overwrite /tmp/actual_files/#{'%04d' % date.year}/#{'%02d' % date.month}/#{'%02d' % date.day}/#{ARGV[2].to_s} #{amazonURL}#{'%04d' % date.year}/#{'%02d' % date.month}/#{'%02d' % date.day}/#{ARGV[2].to_s}\n"

end

