#time is used to automatically pull the current table.
import time as t

import numpy as np
from datetime import datetime, date, time, timedelta

#Pandas seemed to be necessary to apply the datetime formating over the
#first column. Feeling doubtful about this but it works.
import pandas as pd

#Stylesheet for plot
from matplotlib import style
style.use('ggplot')
import matplotlib.pyplot as plt
import matplotlib.dates as mdates


def getData(table, startDate, endDate):
	#Connect to Database and Interact
	import psycopg2
	import numpy as np
	#Connect to an existing database
	conn = psycopg2.connect("dbname= ____ user= ____ host= ____ port= ____ password= ____")
	#Open a cursor to perform database operations
	cur = conn.cursor()
	query = "SELECT to_char(convert_timezone('America/New_York', timestamp 'epoch' + tb_h * INTERVAL '.001 second'),'YYYY-MM-DD-HH24'),sum(case when metric='impression' then cnt else 0 end) FROM since_%s WHERE to_char(convert_timezone('America/New_York', timestamp 'epoch' + tb_h * INTERVAL '.001 second'),'YYYY-MM-DD') > \'%s\' and to_char(convert_timezone('America/New_York', timestamp 'epoch' + tb_h * INTERVAL '.001 second'),'YYYY-MM-DD') < \'%s\' GROUP BY to_char(convert_timezone('America/New_York', timestamp 'epoch' + tb_h * INTERVAL '.001 second'),'YYYY-MM-DD-HH24') ORDER BY to_char(convert_timezone('America/New_York', timestamp 'epoch' + tb_h * INTERVAL '.001 second'),'YYYY-MM-DD-HH24');" % (table, startDate, endDate)
	cur.execute(query)
	#Get all data
	x = cur.fetchall()
	#Make the changes to hte database persistent
	#cur.commit()
	#Close communication with the database
	cur.close()
	conn.close()
	#Convert the list result to a two dimensional array
	Data = np.array(x)
	return Data


#Table selector (e.g. since_1445). 15 days (to be safe) = 1,296,000.
#Subtracting from todays epoch time to capture range with table.
#t[:4] is called slicing. Left:  string[:amount] OR Right:  string[-amount:] OR Mid:  string[offset:offset+amount]
#t = time.time()-1296000
#t = str(t)
#t = t[:4]
#Above combined into one line
table = str(t.time()-1296000)[:4]

#Set dates for SQL Query.
end = date.today()
finishDate = end.strftime("%Y-%m-%d")
start = date.today() - timedelta(days=15)
beginDate = start.strftime("%Y-%m-%d")

#Call getData function above
C = getData(table, beginDate, finishDate)

#Extract columns and format datetime values
y = C[:,0]
a = pd.to_datetime(y)
b = C[:,1]


fig = plt.figure(figsize=(12,6))
#one way to have many subplots
ax1 = plt.subplot2grid((1,1), (0,0))	
#1st tuple = shape of grid, 2nd tuple = starting point of plot, other options: rowspan, column span
#More: 1st tuple - (1,1) fills the whole space with the graph. (2,1) splits the space vertically into two. (1,2) horizontally into two.

monthsFmt = mdates.DateFormatter("%a %b %d")
ax1.xaxis.set_major_formatter(monthsFmt)
ax1.xaxis.set_major_locator(mdates.DayLocator())

ax1.grid(True)
ax1.plot_date(a[168:335], b[0:167], '--', label='Last Week', color='red')
ax1.plot_date(a[168:335], b[168:335], '-', label='This Week', color='green')

plt.ylabel('Impressions')
plt.title('Hourly Impressions')
plt.legend()
plt.subplots_adjust(left=0.09, bottom=0.15, right=0.98, top=0.90, wspace=0.2, hspace=0)
plt.xticks(rotation=45)
#plt.show()

#plt.savefig accepts a number of formats
plt.savefig('myfig.png')


#Import smtplib for the actual sending function
import smtplib

#Here are the email package modules we'll need
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart

recipientList = open('recipientList.txt', 'r').readlines()

COMMASPACE = ', '

#Create the container (outer) email message.
msg = MIMEMultipart()
msg['Subject'] = 'Weekly Impression by Hour Chart'

msg['From'] = ' GMAIL ACCOUNT '
msg['To'] = COMMASPACE.join(recipientList)
msg.preamble = 'Chart'

#Assume we know that the image files are all in PNG format

fp = open('/Users/philbegher/CustomPrograms/PythonPlot/myfig.png', 'rb')
img = MIMEImage(fp.read())
fp.close()
msg.attach(img)


#Send the email via our own SMTP server
server = smtplib.SMTP('smtp.gmail.com:587')
server.starttls()
server.login(' GMAIL ACCOUNT ',' GMAIL PASSWORD')
server.sendmail('GMAIL ACCOUNT',recipientList, msg.as_string())
server.quit()
