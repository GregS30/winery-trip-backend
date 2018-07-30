require 'rest-client'
require 'json'
require 'pry'

# javascript fetch
# fetch('https://quiniwine.com/api/pub/wineKeywordSearch/white/0/100',
#   {headers:
#   {'Accept':'application/json',
#     'Authorization': 'Bearer KpENVmRkf9jyAjk8w2pX'
#   },
# })
# .then(res => res.json())
# .then(console.log)


# for testing, change MAX_FETCH to small number, otherwise 20000
MAX_FETCH = 20000
BASE_URL = 'https://quiniwine.com/api/pub/wineKeywordSearch/'
TOKEN = 'Bearer KpENVmRkf9jyAjk8w2pX'

def fetch_wines(keyword)

  # response = RestClient.get 'https://quiniwine.com/api/pub/wineKeywordSearch/red/0/20000', {:Authorization => 'Bearer KpENVmRkf9jyAjk8w2pX', :accept => 'application/json'}

  url = BASE_URL + keyword + '/0/' + MAX_FETCH.to_s
  puts(url)
  response = RestClient.get url, {:Authorization => TOKEN, :accept => 'application/json'}
  JSON.parse(response)

end

def save_wines(wines, color)

  wines["items"].each_with_index do |wine, index|
    if !WineFromApi.find_by(api_id: wine["id"])
      puts("count #{api_count} name #{wine["Name"]}")
      api_count = api_count + 1
      WineFromApi.create(
        sequence: index+1,
        area: wine["Area"].rstrip,
        country: wine["Country"].rstrip,
        name: wine["Name"].rstrip,
        province: wine["Province"].rstrip,
        style: wine["Style"].rstrip,
        wine_type: wine["Type"].rstrip,
        varietal: wine["Varietal"].rstrip,
        winery: wine["Winery"].rstrip,
        api_id: wine["id"].rstrip,
        vintage: wine["vintage"].rstrip)
    end
  end
end

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# un-comment this section to fetch wines from api
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# white_wines = fetch_wines('white')
# save_wines(white_wines, 'white')
# red_wines = fetch_wines('red')
# save_wines(red_wines, 'red')
# rose_wines = fetch_wines('rose')
# save_wines(rose_wines, 'rose')  # crashes after 4,567, have to figure out how to trap end of response when < MAX_FETCH

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# some psql queries to count things
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# select varietal, count(*) from wine_from_apis where varietal not like '%,%' group by varietal having count(*) > 30 order by count(*) desc;

# select country, count(*) from wine_from_apis group by country having count(*)>50

# update wine_from_apis set country='United States' where country in ('USA','usa','Usa','U.S.A.','United States');

# update wine_from_apis set country='Italy' where country='ITALY';
# update wine_from_apis set country='United Kingdom' where country='UK';

# select country, left(area,20), province, count(sequence) from wine_from_apis group by country, area, province order by count(sequence) DESC;

# \copy wine_from_apis to 'wine_from_apis.csv' DELIMITER ',' CSV HEADER;

def get_grape(varietal, wine_type)

  top_grapes = [
  'Barbera',  'Cabernet Franc', 'Cabernet Sauvignon', 'Chambourcin', 'Chardonnay', 'Chenin Blanc', 'Concord', 'Frontenac', 'Gamay', 'Gewurztraminer', 'Grenache', 'Gruner Veltliner', 'Malbec', 'Merlot', 'Montepulciano', 'Mourvedre', 'Muscat', 'Nebbiolo', 'Pinot Blanc', 'Pinot Grigio', 'Pinot Gris', 'Pinot Noir', 'Prosecco', 'Riesling', 'Sangiovese', 'Sauvignon Blanc', 'Shiraz', 'Tempranillo', 'Trebbiano', 'Vermentino', 'Viognier', 'Zinfandel'
  ]

# use wine_type (white, red, rose) if varietal is '' or is not a top grape
  return top_grapes.include?(varietal) ? varietal : wine_type
end

def get_region(winery)

  country = winery.country.rstrip
  area = winery.area ? winery.area.rstrip : ''
  province = winery.province ? winery.province.rstrip : ''

  case country

    when 'Americas' then region = 'Americas'

    when 'United States'
      if area != '' && "Alexander Valley Alexander Valley, Anderson Valley Russian River Valley Russian River, Calif Somoma County Sonoma Coast Sonoma County, Alexa Sonoma County, Calif Sonoma Mountain Sonoma Mtn Sonoma Sonoma County Sonoma Valley Sonoma valley Sonoma Valley".include?(area)
        region = 'Sonoma'
      elsif area != '' && "Carneros, Napa Valley Napa / Sonoma Napa County Napa Valey Napa Valley & Sonoma Napa, Oakville Rutherford, Napa Val Saint Helena St. Helena Stags Leap District Yountville, Napa Valley".include?(area)
        region = 'Napa Valley'
      elsif (province == 'California' || area == 'California')
        region = 'California'
      elsif area != '' && "Cayuga Lake Cayuga Lake & Finger Finger Lakes Finger Lakes & Seneca Lake Finger Lakes District Finger Lakes, Seneca Lake Hudson River Region Lake Erie Niagara Escarpment Seneca Lake Seneca Lake & Finger Lake Seneca Lakes".include?(area)
        region = 'Finger Lakes'
      elsif area != '' && "North Fork of Long Island &The Hamptons, Long Island Long Island North Fork of Long Island The Hamptons, Long Island".include?(area)
        region = 'North Fork'
      elsif province == 'New York'
        region = 'New York'
      elsif province != '' && province.length > 4 && "Idaho Michigan Oregon Pennsylvania Virginia Washington".include?(province)
        region = province
      else
        region = 'United States'
      end

    when 'Italy'
      if area != '' && "Asti Casaret Langhe Langhe Piedmont Piedmonte Piedmonte Piemonte".include?(area)
        region = "Piedmont"
      elsif area != '' && "Tuscany Umbria".include?(area)
        region = "Tuscany"
      elsif area != '' && "Veneto".include?(area)
        region = "Veneto"
      else
        region = 'Italy'
      end

    when 'Canada' then region = 'Canada'
    when 'France'
      if area != '' && "Bordeaux Haut-Medoc Hermitage Medoc Pessac-Leognan Pomerol Provence Saint Emilion Saint-Emilion Saint-Julien St. Julien Graves Medoc Pauillac Bordeaux Superieur".include?(area)
        region = 'Bordeaux'
      elsif area != '' && "Batard-Montrachet, B Beaujolais Bourgogne Burgundy Chablis Cote Chalonnaise Cote de Beaune Cote de Nuits Julienas, Cru du Bea Maconnais Pouilly-Fuisse Sancerre".include?(area)
        region = 'Burgundy'
      elsif (area != '' && "Champagne Reims Epernay".include?(area)) || province == 'Champagne'
        region = 'Champagne'
      else
        region = 'France'
      end

    when 'United Kingdom' then region = 'United Kingdom'
    when 'Spain'          then region = 'Spain'
    when 'Argentina'      then region = 'Argentina'
    when 'Portugal'       then region = 'Portugal'
    when 'Australia'      then region = 'Australia'
    when 'Chile'          then region = 'Chile'
    when 'New Zealand'   then region = 'New Zealand'
     when 'Mexico'        then region = 'Americas'
     when 'Germany'       then region = 'Germany'
     when 'South Africa'  then region = 'South Africa'
     when 'Austria'       then region = 'Europe'
     when 'Greece'        then region = 'Europe'
     when 'Hungary'       then region = 'Europe'
     when 'Israel'        then region = 'Israel'
     when 'Turkey'        then region = 'Asia'
     when 'Slovenia'      then region = 'Europe'
     when 'Croatia'       then region = 'Europe'
     when 'Uruguay'       then region = 'Americas'
     when 'India'         then region = 'Asia'
     when 'Bulgaria'      then region = 'Europe'
     when 'Lebanon'       then region = 'Lebanon'
     when 'Macedonia'     then region = 'Europe'
     when 'Switzerland'   then region = 'Europe'
     when 'Romania'       then region = 'Europe'
     when 'Georgia'       then region = 'Europe'
     when 'Russia'        then region = 'Europe'
     when 'Poland'        then region = 'Europe'
     when 'Peru'          then region = 'Americas'
     when 'Luxembourg'    then region = 'Europe'
     when 'Ukraine'       then region = 'Europe'
     when 'Brazil'        then region = 'Americas'
     when 'Serbia'        then region = 'Europe'

     else region = 'UNKNOWN REGION'
    end

  return region

end

def fix_country(winery)
  country = winery.country ? winery.country.rstrip : ''
  case country
    when 'USA'
      winery.country = 'United States'
    when 'U.S.A.'
      winery.country = 'United States'
    when 'UK'
      winery.country = 'United Kingdom'
     when 'Mexico'
       winery.country = 'Americas'
     when 'Usa'
       winery.country = 'United States'
     when 'ITALY'
       winery.country = 'Italy'
     when 'CANADA'
       winery.country = 'Canada'
     when 'Itay'
       winery.country = 'Italy'
     when 'California'
       winery.country = 'United States'
     when 'Austrailia'
       winery.country = 'Australia'
     when 'FRANCE'
       winery.country = 'France'
     when 'NEW ZEALAND'
       winery.country = 'New Zealand'
     when 'U.S.A.'
       winery.country = 'United States'
     when 'U'
       winery.country = 'Unknown'
     when 'French'
       winery.country = 'France'
     when 'Su'
       winery.country = 'Unknown'
     when 'france'
       winery.country = 'France'
     when 'Usa'
       winery.country = 'United States'
     when 'Liban'
       winery.country = 'Unknown'
     when 'Sicily'
       winery.country = 'Italy'
     when 'New Zealan'
       winery.country = 'New Zealand'
     when 'Germany Schloss'
       winery.country = 'Germany'
     when 'Italie'
       winery.country = 'Italy'
     when 'South Australia'
       winery.country = 'Australia'
     when 'ARGENTINA'
       winery.country = 'Argentina'
     when 'England'
       winery.country = 'United Kingdom'
     when 'Franc'
       winery.country = 'France'
     when 'New zealand'
       winery.country = 'New Zealand'
     when 'Many'
       winery.country = 'Unknown'
     when 'Washington State'
       winery.country = 'United States'
     when 'Uk'
       winery.country = 'United Kingdom'
    when 'Wales'
      winery.country = 'United Kingdom'
  end
end


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# un-comment this section to process fetched wines into main db
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# change to false to process all data, only 1000 rows otherwise
TEST_RUN = false
TEST_MAX = 5000
SILENT = true

Wine.delete_all
Winery.delete_all
Region.delete_all
Grape.delete_all

api = WineFromApi.all

winery_count = 0
skipped = 0
wine_count = 0
region_count = 0
grape_count = 0

puts("runtime options TEST_RUN=#{TEST_RUN} TEST_MAX=#{TEST_MAX} SILENT=#{SILENT}")

api.each do |api|

  break if TEST_RUN && wine_count == TEST_MAX

  if !@this_winery = Winery.find_by(name: api["winery"])
  # , country: api["country"], province: api["province"])
    @this_winery = Winery.new(
      area: api["area"],
      country: api["country"],
      province: api["province"],
      name: api["winery"],
      api_sequence: api["sequence"]
    )

    fix_country(@this_winery)

    region = get_region(@this_winery)

    # puts("region: #{region} area: '#{@this_winery.area}' country: '#{@this_winery.country}' province: '#{@this_winery.province}' ")

    if !@this_region = Region.find_by(name: region)
      @this_region = Region.new(
        name: region
      )
      if @this_region.save
        puts("saved Region #{region}") if !SILENT
        region_count = region_count + 1
      else
        puts("Region save failed", @this_region)
        break
      end
    end

    @this_winery.region = @this_region

    if @this_winery.save
      puts("saved Winery #{winery_count} #{api["winery"]}") if !SILENT
      winery_count = winery_count+1
    else
      puts("Winery save failed", @this_winery)
      break
    end
  else
    skipped = skipped+1
    puts("skipped Winery #{api["winery"]}") if !SILENT
  end

  @wine = Wine.new(
    name: api["name"],
    style: api["style"],
    wine_type: api["wine_type"],
    api_id: api["id"],
    vintage: api["vintage"],
    winery: @this_winery
  )

  grape = get_grape(api["varietal"], @wine.wine_type)

  if !@this_grape = Grape.find_by(name: grape)
    @this_grape = Grape.new(
      name: grape
    )
    if @this_grape.save
      puts("saved Grape #{grape}") if !SILENT
      grape_count = grape_count + 1
    else
      puts("Grape save failed", @this_grape)
      break
    end

  end

  @wine.grape = @this_grape

  if @wine.save
    puts("saved Wine #{api["name"]}") if !SILENT
  else
    puts("Wine save failed", @wine)
    break
  end
  wine_count = wine_count + 1

  if wine_count % 1000 == 0
    puts("progress: wineries=#{winery_count} wines=#{wine_count} regions=#{region_count} grapes=#{grape_count}")
  end

end
puts("completed: wineries=#{winery_count} (skipped=#{skipped})  wines=#{wine_count} regions=#{region_count} grapes=#{grape_count}")
