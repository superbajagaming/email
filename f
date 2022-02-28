from http.client import PRECONDITION_REQUIRED
import msilib
from numpy import character
import pandas as pd
import requests
from bs4 import BeautifulSoup
import smtplib as s

page = requests.get('https://forecast.weather.gov/MapClick.php?lat=41.8843&lon=-87.6324#.XIRQYFNKgUE'
)
soup = BeautifulSoup(page.text, 'html.parser')
print(soup.find_all('a'))
week = soup.find(id='seven-day-forecast-body')

items = week.find_all(class_='tombstone-container')

period_names = [item.find(class_='period-name').get_text() for item in items]
short_descriptions = [item.find(class_='short-desc').get_text() for item in items]
temperatures = [item.find(class_='temp').get_text() for item in items]


weather_stuff = pd.DataFrame(
    {
        'period': period_names,
        'short_descriptions': short_descriptions,
        'temperatures': temperatures,
    })

print("Initial Temps: ", temperatures)


templist = []
for item in temperatures:
    bob = item
    bob = str(bob)
    bob = bob.replace('\xb0', "")
    bob = bob.replace('\u21d1', "")
    bob = bob.replace('\u21d3', "")
    templist.append(bob)

    print(bob)
for i in templist:
    print("Is this correct: "+i)


object= s.SMTP('smtp.gmail.com', 587)
object.starttls()
object.login("p4867796@gmail.com", 'F007FCAa1')
subject= "weather report"
str2 = weather_stuff

body = templist 

message= "Subject: {}\n\n{}".format(subject, body)
str3 = "who do you want to send to\n"


emailAddresses= 'michael.sekol@mahoningctc.com'

object.sendmail('p4867796@gmail.com', emailAddresses, message)

print("Congrats Sent Successfull!")
object.quit()
