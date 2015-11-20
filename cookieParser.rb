#################################################################################
##spongeLog Parser
#################################################################################

require 'rubygems'
require 'json'


File.open("spongeKeyLogs.log").readlines.each do |line|
	
	oneRecord = JSON.parse(line)
	
	#puts oneRecord["batch_id"]	# + "\t" +	OR ]

	## More Ruby-ish way of doing it
	#puts [oneRecord["batch_id"],oneRecord[...],...].join("\t")
	puts [oneRecord["visitor_id"],oneRecord["tsm"],oneRecord["ad_tag_id"],oneRecord["flight_id"],oneRecord["creative_id"],oneRecord["metric"],oneRecord["browser_ua"],oneRecord["ext_pl_id"],oneRecord["ext_sit_id"],oneRecord["item_id"],oneRecord["site_composite"],oneRecord["detail"],oneRecord["datax"],oneRecord["base_feature"],oneRecord["feature"],oneRecord["seconds"],oneRecord["lat"],oneRecord["lng"],oneRecord["city"],oneRecord["region"],oneRecord["country"],oneRecord["postal"]].join("뻯")

##Use following technique to keep hashed arrays together when importing into spreadsheet.
#	puts ([oneRecord["signal_value_id"]] || []).join(",")

end



##Sample Log - Use to see available metrics
#{"tb_h":1438034400000,"batch_id":"201507272340","ad_tag_id":51277765,"flight_id":20614,"creative_id":309707,"metric":"dynode","browser_ua":"Safari","ext_pl_id":"12150261","pl_composite":"20614|309707|51277765|12150261","pl_test":null,"ext_site_id":"67a5","site_composite":"20614|309707|51277765|67a5","detail":"","signal_value_id":["258365","349080"],"datax":null,"base_feature":null,"feature":null,"item_id":262343,"seconds":0,"visitor_id":"70de71e38f304e83b78b8458902301ff","tsm":1438035910183,"lat":30.326099395751953,"lng":-81.68009948730469,"tz":-400,"city":"jacksonville","region":"fl","country":"us","postal":"32204","metro":"561","area":"904"}
