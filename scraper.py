import bs4 as bs
import urllib.request
import pandas as pd


source = urllib.request.urlopen('https://www.espn.com/espn/page2/sportSkills').read()
soup = bs.BeautifulSoup(source,'html.parser')

table = soup.find('a',{'name': 'grid'})
table_rows = table.find_all('tr', {'bgcolor': ['#ffffff', "#ecece4"]})

column_list = [
    'sport',
    'endurance',
    'strength',
    'power',
    'speed',
    'agility',
    'flexibility',
    'nerve',
    "durability",
    "hand_eye",
    "analytic",
    'total',
    'rank']

row_list = []

for row in table_rows:
    td_elements = row.find_all('td')
    row = [td.text for td in td_elements]
    row_list.append(row)

data_dict = {}
for column in column_list:
    values = [v[column_list.index(column)] for v in row_list]
    data_dict[column] = values

data_df = pd.DataFrame(data_dict)

data_df.to_csv('./data/espn-sport-rankings.csv', index=False)




