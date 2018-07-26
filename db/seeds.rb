require 'rest-client'
require 'json'
require 'pry'

data = RestClient.get 'https://quiniwine.com/api/pub/wineKeywordSearch/white/0/10', {:Authorization => 'Bearer KpENVmRkf9jyAjk8w2pX', :accept => 'application/json'}

var = JSON.parse(data)

var["items"].each_with_index do |x, index|
  QuiniWine.create(
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

# javascript fetch
# fetch('https://quiniwine.com/api/pub/wineKeywordSearch/white/0/1000',
#   {headers:
#   {'Accept':'application/json',
#     'Authorization': 'Bearer KpENVmRkf9jyAjk8w2pX'
#   },
# })
# .then(res => res.json())
# .then(console.log)
