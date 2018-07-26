require 'rest-client'
require 'json'
require 'pry'


# javascript fetch
# fetch('https://quiniwine.com/api/pub/wineKeywordSearch/white/0/1000',
#   {headers:
#   {'Accept':'application/json',
#     'Authorization': 'Bearer KpENVmRkf9jyAjk8w2pX'
#   },
# })
# .then(res => res.json())
# .then(console.log)

# manually change the keyword from white to red to rose - 10000 per fetch
# rose fails with "ArgumentError: string contains null byte"
# so total count in WineFromApi after the 3 fetchs should be about 24,567
# but from doing a manual fetch in the browser it appears rose is only about 4,768
# so we're only missing about the last 200
data = RestClient.get 'https://quiniwine.com/api/pub/wineKeywordSearch/rose/0/10000', {:Authorization => 'Bearer KpENVmRkf9jyAjk8w2pX', :accept => 'application/json'}

var = JSON.parse(data)

var["items"].each_with_index do |x, index|
  puts(x["Name"])
  WineFromApi.create(
    sequence: index,
    area: x["Area"],
    country: x["Country"],
    name: x["Name"],
    province: x["Province"],
    style: x["Style"],
    wine_type: x["Type"],
    varietal: x["Varietal"],
    winery: x["Winery"],
    api_id: x["Id"],
    vintage: x["Vintage"])
end
