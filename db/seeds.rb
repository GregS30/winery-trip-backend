require 'rest-client'
require 'json'

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
MAX_FETCH = 100
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
      # puts("count #{api_count} name #{wine["Name"]}")
      # api_count = api_count + 1
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

def get_region(country, province, area)

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

def get_region(winery)

  country = winery.country.rstrip
  winery.area = winery.area ? winery.area.rstrip : ''
  winery.province = winery.province ? winery.province.rstrip : ''

  case country
  when 'Americas'
    region = 'Americas'

  when 'United States'
    if winery.area != '' && "Carneros, Napa Valle Napa / Sonoma Napa County Napa Valey Napa Valley & Sonoma Napa, Sonoma, Monter Oakville Rutherford, Napa Val Saint Helena St. Helena Stags Leap District Yountville, Napa Val Dry Creek Valley Edna Valley El Dorado Fair Play Howell Mountain Lodi Monterey County".include?(winery.area)
      region = 'Napa Valley'
    elsif winery.province != '' && "Idaho Michigan Oregon Pennsylvania Virginia Washington".include?(winery.province)
      region = winery.province
    elsif winery.area != '' && "Cayuga Lake Cayuga Lake & Finger Finger Lakes Finger Lakes & Senec Finger Lakes Distric Finger Lakes, Seneca Hudson River Region Lake Erie Niagara Escarpment Seneca Lake Seneca Lake & Finger Seneca Lakes".include?(winery.area)
      region = 'Finger Lakes'
    elsif winery.area != '' && "Long Island North Fork of Long I The Hamptons, Long I".include?(winery.area)
      region = 'North Fork'
    elsif winery.area != '' && "Alexander Valley Alexander Valley, Oa Anderson Valley Russian River Valley Russian River, Calif Somoma County Sonoma Coast Sonoma County, Alexa Sonoma County, Calif Sonoma Mountain Sonoma Mtn Sonoma Sonoma County Sonoma Valley Sonoma valley Sonoma Valley".include?(winery.area)
      region = 'Sonoma'
    else
      region = 'United States'
    end

    when 'Italy'
      region = 'Italy'
      if winery.area != '' && "Asti Casaret Langhe Langhe Piedmont Piedmonte Piedmonte Piemonte".include?(winery.area)
        region = "Piedmont"
      elsif winery.area != '' && "Tuscany Umbria".include?(winery.area)
        region = "Tuscany"
      elsif winery.area != '' && "Veneto".include?(winery.area)
        region = "Veneto"
      else
        region = 'Italy'
      end

    when 'Canada'
      region = 'Canada'
    when 'France'
      region = 'France'
      if winery.area != '' && "Bordeaux Haut-Medoc Hermitage Medoc Pessac-Leognan Pomerol Provence Saint Emilion Saint-Emilion Saint-Julien St. Julien Graves Medoc Pauillac".include?(winery.area)
        region = 'Bordeaux'
      elsif winery.area != '' && "Batard-Montrachet, B Beaujolais Bourgogne Burgundy Chablis Cote Chalonnaise Cote de Beaune Cote de Nuits Julienas, Cru du Bea Maconnais Pouilly-Fuisse Sancerre".include?(winery.area)
        region = 'Burgundy'
      elsif winery.area != '' && "Champagne Reims".include?(winery.area)
        region = 'Champagne'
      end

    when 'United Kingdom'
      region = 'United Kingdom'
    when 'Spain'
      region = 'Spain'
    when 'Argentina'
      region = 'Argentina'
    when 'Portugal'
      region = 'Portugal'
     when 'Australia'
       region = 'Australia'
     when 'Chile'
       region = 'Chile'
     when 'New Zealand'
       region = 'New Zealand'
     when 'Mexico'
       region = 'Americas'
     when 'Germany'
       region = 'Germany'
     when 'South Africa'
       region = 'South Africa'
     when 'Austria'
       region = 'Europe'
     when 'Greece'
       region = 'Europe'
     when 'Hungary'
       region = 'Europe'
     when 'Israel'
       region = 'Israel'
     when 'Turkey'
       region = 'Asia'
     when 'Slovenia'
       region = 'Europe'
     when 'Croatia'
       region = 'Europe'
     when 'Uruguay'
       region = 'Americas'
     when 'India'
       region = 'Asia'
     when 'Bulgaria'
       region = 'Europe'
     when 'Lebanon'
       region = 'Lebanon'
     when 'Macedonia'
       region = 'Europe'
     when 'Switzerland'
       region = 'Europe'
     when 'Romania'
       region = 'Europe'
     when 'Georgia'
       region = 'Europe'
     when 'Russia'
       region = 'Europe'
     when 'Poland'
       region = 'Europe'
     when 'Peru'
       region = 'Americas'
     when 'Luxembourg'
       region = 'Europe'
     when 'Ukraine'
       region = 'Europe'
     when 'Brazil'
       region = 'Americas'
     when 'Serbia'
       region = 'Europe'
     else
       region = 'UNKNOWN REGION'
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
TEST_RUN = true
TEST_MAX = 10
SILENT = true

Wine.delete_all
Winery.delete_all
Region.delete_all

api = WineFromApi.all

created = 0
skipped = 0
wine_count = 0
region_count = 0

puts("runtime options TEST_RUN=#{TEST_RUN} TEST_MAX=#{TEST_MAX} SILENT=#{SILENT}")

api.each do |api|

  break if TEST_RUN && wine_count == TEST_MAX

  if !@this_winery = Winery.find_by(name: api["winery"], country: api["country"], province: api["province"])
    @this_winery = Winery.new(
      area: api["area"],
      country: api["country"],
      province: api["province"],
      name: api["winery"],
      api_sequence: api["sequence"]
    )

    fix_country(@this_winery)

    region = get_region(@this_winery)

    if !@this_region = Region.find_by(name: region)
      @this_region = Region.new(
        name: region
      )
      if @this_region.save
        puts("saved Region #{region}") if !SILENT
        region_count = region_count + 1
      end
    end

    @this_winery.region = @this_region

    if @this_winery.save
      puts("saved Winery #{created} #{api["winery"]}") if !SILENT
      created = created+1
    end
  else
    skipped = skipped+1
    puts("skipped Winery #{api["winery"]}") if !SILENT
  end
  @wine = Wine.new(
    name: api["name"],
    style: api["style"],
    wine_type: api["wine_type"],
    varietal: api["varietal"],
    api_id: api["id"],
    vintage: api["vintage"],
    winery: @this_winery
  )

  if @wine.save
    puts("saved Wine #{api["name"]}") if !SILENT
  end
  wine_count = wine_count + 1

  if created % 5000 == 0
    puts("progress: saved wineries=#{created} skipped=#{skipped} saved wines=#{wine_count} regions=#{region_count}")
  end

end
puts("completed: saved wineries=#{created} skipped=#{skipped} saved wines=#{wine_count} regions=#{region_count}")
