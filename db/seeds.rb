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


data = RestClient.get 'https://quiniwine.com/api/pub/wineKeywordSearch/white/0/1000', {:Authorization => 'Bearer KpENVmRkf9jyAjk8w2pX', :accept => 'application/json'}

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

# select varietal, count(*) from wine_from_apis where varietal not like '%,%' group by varietal having count(*) > 30 order by count(*) desc;

# select country, count(*) from wine_from_apis group by country having count(*)>50

# update wine_from_apis set country='United States' where country in ('USA','usa','Usa','U.S.A.','United States');

# update wine_from_apis set country='Italy' where country='ITALY';
# update wine_from_apis set country='United Kingdom' where country='UK';

# select country, left(area,20), province, count(sequence) from wine_from_apis group by country, area, province order by count(sequence) DESC;

# \copy wine_from_apis to 'wine_from_apis.csv' DELIMITER ',' CSV HEADER;

Wine.delete_all
Winery.delete_all
Region.delete_all

api = WineFromApi.all

created = 0
skipped = 0
wine_count = 0
region_count = 0

api.each do |api|
  if !@this_region = Region.find_by(name: api["country"])
    @this_region = Region.new(
      name: api["country"]
    )
    if @this_region.save
      puts("saved Region #{api["country"]}")
      region_count = region_count + 1
    end
  end

  if !@this_winery = Winery.find_by(name: api["winery"]) #, country: api["country"], province: api["province"])
    @this_winery = Winery.new(
      area: api["area"],
      country: api["country"],
      province: api["province"],
      name: api["winery"],
      region: @this_region,
      api_sequence: api["sequence"]
    )
    if @this_winery.save
      puts("saved Winery #{api["winery"]}")
      created = created+1
    end
  else
    skipped = skipped+1
    puts("skipped Winery #{api["winery"]}")
  end
  @wine = Wine.new(
    name: api["name"],
    style: api["style"],
    wine_type: api["type"],
    varietal: api["varietal"],
    api_id: api["id"],
#    vintage: api["vintage"],
    winery: @this_winery
  )
  if @wine.save
    puts("saved Wine #{api["name"]}")
  end
  wine_count = wine_count + 1
  break if wine_count > 1000

end
puts("saved wineries=#{created} skipped=#{skipped} saved wines=#{wine_count} regions=#{region_count}")
