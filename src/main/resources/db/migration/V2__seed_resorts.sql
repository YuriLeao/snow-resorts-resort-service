-- Seed the resort catalog with a curated, worldwide set of real ski resorts.
-- Coordinates are real-world locations (WGS84); official_url is left NULL when unverified.
-- Ids are generated via gen_random_uuid() (built into PostgreSQL 13+, no extension needed).
-- ON CONFLICT (slug) DO NOTHING keeps this migration idempotent and side-effect free.
SET search_path TO resorts, public;

INSERT INTO resorts (id, slug, name, country, lat, lng, official_url, description) VALUES
-- ============================ EUROPE ============================
-- France
(gen_random_uuid(), 'chamonix-mont-blanc', 'Chamonix-Mont-Blanc', 'FR', 45.9237, 6.8694, 'https://www.chamonix.com', 'Historic Mont Blanc resort famed for the Vallée Blanche and serious off-piste terrain.'),
(gen_random_uuid(), 'val-thorens', 'Val Thorens', 'FR', 45.2978, 6.5800, 'https://www.valthorens.com', 'Europe''s highest ski resort and gateway to the Three Valleys, the largest linked ski area in the world.'),
(gen_random_uuid(), 'courchevel', 'Courchevel', 'FR', 45.4154, 6.6347, 'https://www.courchevel.com', 'Upscale Three Valleys resort known for immaculate grooming and luxury chalets.'),
(gen_random_uuid(), 'tignes', 'Tignes', 'FR', 45.4685, 6.9056, 'https://www.tignes.net', 'High-altitude resort linked with Val d''Isère in the Espace Killy, with glacier skiing.'),
(gen_random_uuid(), 'val-disere', 'Val d''Isère', 'FR', 45.4486, 6.9799, 'https://www.valdisere.com', 'Classic Tarentaise resort and frequent World Cup host, snow-sure into spring.'),
(gen_random_uuid(), 'les-deux-alpes', 'Les Deux Alpes', 'FR', 45.0107, 6.1247, 'https://www.les2alpes.com', 'Large glacier ski area in the Oisans with summer skiing and a lively village.'),
(gen_random_uuid(), 'alpe-dhuez', 'Alpe d''Huez', 'FR', 45.0925, 6.0703, 'https://www.alpedhuez.com', 'Sun-soaked resort home to the legendary 16 km Sarenne black run.'),
(gen_random_uuid(), 'meribel', 'Méribel', 'FR', 45.3964, 6.5658, 'https://www.meribel.net', 'Central hub of the Three Valleys with traditional chalet-style architecture.'),
(gen_random_uuid(), 'la-plagne', 'La Plagne', 'FR', 45.5072, 6.6776, 'https://www.la-plagne.com', 'Sprawling Paradiski resort linked to Les Arcs by the Vanoise Express.'),
(gen_random_uuid(), 'les-arcs', 'Les Arcs', 'FR', 45.5722, 6.8283, 'https://www.lesarcs.com', 'Purpose-built Paradiski resort known for its varied terrain above Bourg-Saint-Maurice.'),
(gen_random_uuid(), 'megeve', 'Megève', 'FR', 45.8569, 6.6175, 'https://www.megeve.com', 'Elegant, historic village resort near Mont Blanc with gentle, scenic skiing.'),
(gen_random_uuid(), 'avoriaz', 'Avoriaz', 'FR', 46.1917, 6.7711, 'https://www.avoriaz.com', 'Car-free, ski-in/ski-out resort at the heart of the cross-border Portes du Soleil.'),
(gen_random_uuid(), 'serre-chevalier', 'Serre Chevalier', 'FR', 44.9333, 6.5500, 'https://www.serre-chevalier.com', 'Large southern Alps ski area combining old villages with extensive tree-lined runs.'),
(gen_random_uuid(), 'les-menuires', 'Les Menuires', 'FR', 45.3247, 6.5394, 'https://www.lesmenuires.com', 'Value-focused Three Valleys resort with excellent intermediate cruising.'),
(gen_random_uuid(), 'la-clusaz', 'La Clusaz', 'FR', 45.9047, 6.4239, 'https://www.laclusaz.com', 'Charming Aravis village resort close to Annecy with five mountain massifs.'),
-- Switzerland
(gen_random_uuid(), 'zermatt', 'Zermatt', 'CH', 46.0207, 7.7491, 'https://www.zermatt.ch', 'Car-free resort beneath the Matterhorn with year-round glacier skiing.'),
(gen_random_uuid(), 'verbier', 'Verbier', 'CH', 46.0964, 7.2286, 'https://www.verbier.ch', 'Freeride mecca and gateway to the vast 4 Vallées ski area.'),
(gen_random_uuid(), 'st-moritz', 'St. Moritz', 'CH', 46.4908, 9.8355, 'https://www.stmoritz.com', 'Glamorous Engadin resort and two-time Winter Olympics host.'),
(gen_random_uuid(), 'davos', 'Davos', 'CH', 46.8027, 9.8360, 'https://www.davos.ch', 'High-altitude town with six ski areas including the famous Parsenn.'),
(gen_random_uuid(), 'laax', 'Laax', 'CH', 46.8083, 9.2580, 'https://www.laax.com', 'Freestyle hotspot with one of the largest snowparks and a superpipe in Europe.'),
(gen_random_uuid(), 'grindelwald', 'Grindelwald', 'CH', 46.6242, 8.0414, 'https://www.grindelwald.ch', 'Scenic Jungfrau region village beneath the north face of the Eiger.'),
(gen_random_uuid(), 'saas-fee', 'Saas-Fee', 'CH', 46.1089, 7.9292, 'https://www.saas-fee.ch', 'Glacier village known as the Pearl of the Alps with reliable high-altitude snow.'),
(gen_random_uuid(), 'wengen', 'Wengen', 'CH', 46.6056, 7.9219, 'https://www.wengen.ch', 'Car-free Jungfrau resort and home of the Lauberhorn downhill.'),
(gen_random_uuid(), 'crans-montana', 'Crans-Montana', 'CH', 46.3119, 7.4806, 'https://www.crans-montana.ch', 'Sunny plateau resort in Valais with panoramic views over the Rhône valley.'),
(gen_random_uuid(), 'engelberg', 'Engelberg', 'CH', 46.8208, 8.4058, 'https://www.engelberg.ch', 'Deep-snow freeride destination on Mount Titlis near Lucerne.'),
(gen_random_uuid(), 'andermatt', 'Andermatt', 'CH', 46.6361, 8.5942, 'https://www.andermatt.ch', 'Central Swiss resort with the SkiArena Andermatt-Sedrun and legendary Gemsstock off-piste.'),
(gen_random_uuid(), 'gstaad', 'Gstaad', 'CH', 46.4750, 7.2861, 'https://www.gstaad.ch', 'Chic Bernese Oberland resort spanning numerous villages and mountains.'),
-- Austria
(gen_random_uuid(), 'st-anton-am-arlberg', 'St. Anton am Arlberg', 'AT', 47.1297, 10.2644, 'https://www.stantonamarlberg.com', 'Cradle of alpine skiing with demanding terrain and legendary après-ski.'),
(gen_random_uuid(), 'kitzbuehel', 'Kitzbühel', 'AT', 47.4467, 12.3917, 'https://www.kitzbuehel.com', 'Medieval town hosting the fearsome Hahnenkamm Streif downhill race.'),
(gen_random_uuid(), 'ischgl', 'Ischgl', 'AT', 47.0103, 10.2917, 'https://www.ischgl.com', 'Snow-sure Tyrolean resort famous for its party scene and Silvretta Arena.'),
(gen_random_uuid(), 'soelden', 'Sölden', 'AT', 46.9667, 11.0072, 'https://www.soelden.com', 'Glacier resort with three 3,000 m peaks and the World Cup season opener.'),
(gen_random_uuid(), 'mayrhofen', 'Mayrhofen', 'AT', 47.1656, 11.8597, 'https://www.mayrhofen.at', 'Zillertal resort home to Austria''s steepest piste, the Harakiri.'),
(gen_random_uuid(), 'saalbach-hinterglemm', 'Saalbach-Hinterglemm', 'AT', 47.3925, 12.6378, 'https://www.saalbach.com', 'Extensive Skicircus area with a famous circuit and lively villages.'),
(gen_random_uuid(), 'lech-am-arlberg', 'Lech am Arlberg', 'AT', 47.2086, 10.1419, 'https://www.lechzuers.com', 'Upscale Arlberg village linked into the vast Ski Arlberg network.'),
(gen_random_uuid(), 'obergurgl', 'Obergurgl', 'AT', 46.8694, 11.0269, 'https://www.obergurgl.com', 'High, snow-sure Ötztal resort with reliable conditions and family appeal.'),
(gen_random_uuid(), 'schladming', 'Schladming', 'AT', 47.3939, 13.6869, 'https://www.schladming-dachstein.at', 'Styrian resort renowned for floodlit night skiing and World Cup slaloms.'),
(gen_random_uuid(), 'bad-gastein', 'Bad Gastein', 'AT', 47.1117, 13.1342, 'https://www.gastein.com', 'Belle Époque spa town set in a dramatic valley with broad ski terrain.'),
(gen_random_uuid(), 'zell-am-see', 'Zell am See', 'AT', 47.3231, 12.7950, 'https://www.zellamsee-kaprun.com', 'Lakeside town paired with the Kitzsteinhorn glacier at Kaprun.'),
(gen_random_uuid(), 'stuben-am-arlberg', 'Stuben am Arlberg', 'AT', 47.1311, 10.1675, NULL, 'Quiet, snowy Arlberg hamlet with access to the wider Ski Arlberg area.'),
-- Italy
(gen_random_uuid(), 'cortina-dampezzo', 'Cortina d''Ampezzo', 'IT', 46.5405, 12.1357, 'https://www.cortinadolomiti.eu', 'Glamorous Dolomites resort and co-host of the 2026 Winter Olympics.'),
(gen_random_uuid(), 'val-gardena', 'Val Gardena', 'IT', 46.5594, 11.6747, 'https://www.valgardena.it', 'Dolomiti Superski valley with the Sellaronda circuit and Saslong downhill.'),
(gen_random_uuid(), 'sestriere', 'Sestriere', 'IT', 44.9575, 6.8786, 'https://www.sestriere.it', 'High Piedmont resort at the heart of the Via Lattea and 2006 Olympic venue.'),
(gen_random_uuid(), 'madonna-di-campiglio', 'Madonna di Campiglio', 'IT', 46.2294, 10.8267, 'https://www.campigliodolomiti.it', 'Elegant Brenta Dolomites resort with well-groomed pistes.'),
(gen_random_uuid(), 'breuil-cervinia', 'Breuil-Cervinia', 'IT', 45.9358, 7.6306, 'https://www.cervinia.it', 'Snow-sure Aosta resort linked to Zermatt beneath the Matterhorn.'),
(gen_random_uuid(), 'livigno', 'Livigno', 'IT', 46.5380, 10.1350, 'https://www.livigno.eu', 'Duty-free high-altitude resort with strong freestyle and Nordic offerings.'),
(gen_random_uuid(), 'alta-badia', 'Alta Badia', 'IT', 46.5600, 11.8800, 'https://www.altabadia.org', 'Ladin-speaking Dolomites area known for gentle cruising and gourmet huts.'),
(gen_random_uuid(), 'bormio', 'Bormio', 'IT', 46.4678, 10.3736, 'https://www.bormio.eu', 'Historic spa town with the steep Stelvio World Cup downhill.'),
(gen_random_uuid(), 'courmayeur', 'Courmayeur', 'IT', 45.7969, 6.9694, 'https://www.courmayeur-montblanc.com', 'Stylish Italian side of Mont Blanc with charming village atmosphere.'),
(gen_random_uuid(), 'la-thuile', 'La Thuile', 'IT', 45.7144, 6.9528, 'https://www.lathuile.it', 'Snowy Aosta resort linked cross-border to La Rosière in France.'),
(gen_random_uuid(), 'canazei', 'Canazei', 'IT', 46.4769, 11.7700, 'https://www.fassa.com', 'Val di Fassa base for the Sellaronda and the dramatic Marmolada glacier.'),
-- Germany
(gen_random_uuid(), 'garmisch-partenkirchen', 'Garmisch-Partenkirchen', 'DE', 47.4917, 11.0958, 'https://www.gapa.de', 'Bavaria''s premier resort beneath the Zugspitze and a regular World Cup stop.'),
(gen_random_uuid(), 'oberstdorf', 'Oberstdorf', 'DE', 47.4097, 10.2789, 'https://www.oberstdorf.de', 'Allgäu resort famous for ski jumping and varied alpine slopes.'),
-- Andorra
(gen_random_uuid(), 'grandvalira', 'Grandvalira', 'AD', 42.5400, 1.6500, 'https://www.grandvalira.com', 'Largest ski area in the Pyrenees, spanning Pas de la Casa to Soldeu.'),
(gen_random_uuid(), 'vallnord-pal-arinsal', 'Vallnord Pal Arinsal', 'AD', 42.5667, 1.4900, 'https://www.palarinsal.com', 'Family-friendly Pyrenean area on the western side of Andorra.'),
-- Spain
(gen_random_uuid(), 'baqueira-beret', 'Baqueira Beret', 'ES', 42.6986, 0.9333, 'https://www.baqueira.es', 'Spain''s most prestigious resort in the Aran Valley of the Pyrenees.'),
(gen_random_uuid(), 'sierra-nevada', 'Sierra Nevada', 'ES', 37.0961, -3.3986, 'https://www.sierranevada.es', 'Europe''s southernmost major resort, high above Granada with long seasons.'),
(gen_random_uuid(), 'formigal', 'Formigal', 'ES', 42.7783, -0.3825, 'https://www.formigal-panticosa.com', 'Large Aragonese Pyrenees resort spread across four valleys.'),
-- Norway
(gen_random_uuid(), 'trysil', 'Trysil', 'NO', 61.3000, 12.2667, 'https://www.skistar.com/en/trysil', 'Norway''s biggest ski resort, family-oriented with reliable cold snow.'),
(gen_random_uuid(), 'hemsedal', 'Hemsedal', 'NO', 60.8667, 8.3000, 'https://www.skistar.com/en/hemsedal', 'Lively resort dubbed the Scandinavian Alps for its steeper terrain.'),
(gen_random_uuid(), 'geilo', 'Geilo', 'NO', 60.5340, 8.2060, 'https://www.skigeilo.no', 'Relaxed resort on the Bergen Line railway with strong cross-country skiing.'),
-- Sweden
(gen_random_uuid(), 'are', 'Åre', 'SE', 63.3990, 13.0810, 'https://www.skistar.com/en/are', 'Sweden''s leading resort and World Cup venue with vibrant après.'),
-- Finland
(gen_random_uuid(), 'levi', 'Levi', 'FI', 67.8050, 24.8000, 'https://www.levi.fi', 'Lapland resort above the Arctic Circle hosting an annual World Cup slalom.'),
(gen_random_uuid(), 'ruka', 'Ruka', 'FI', 66.1667, 29.1333, 'https://www.ruka.fi', 'Northern Finnish resort with one of the longest seasons in Europe.'),
(gen_random_uuid(), 'yllas', 'Ylläs', 'FI', 67.5667, 24.2333, 'https://www.yllas.fi', 'Lapland fell resort with Finland''s longest slopes and serene scenery.'),
-- Bulgaria
(gen_random_uuid(), 'bansko', 'Bansko', 'BG', 41.8400, 23.4886, 'https://www.bansko.bg', 'Pirin Mountains resort offering excellent value and World Cup pistes.'),
(gen_random_uuid(), 'borovets', 'Borovets', 'BG', 42.2670, 23.6060, 'https://www.borovets-bg.com', 'Bulgaria''s oldest resort in the Rila Mountains with tree-lined runs.'),
(gen_random_uuid(), 'pamporovo', 'Pamporovo', 'BG', 41.6500, 24.6833, 'https://www.pamporovo.me', 'Sunny Rhodope resort known for gentle, beginner-friendly slopes.'),
-- Slovenia
(gen_random_uuid(), 'kranjska-gora', 'Kranjska Gora', 'SI', 46.4847, 13.7886, 'https://www.kranjska-gora.si', 'Julian Alps resort and World Cup giant slalom host near the Vršič pass.'),
(gen_random_uuid(), 'mariborsko-pohorje', 'Mariborsko Pohorje', 'SI', 46.5333, 15.6000, NULL, 'Slovenia''s largest ski area, home of the Golden Fox women''s World Cup.'),
-- Poland
(gen_random_uuid(), 'zakopane', 'Zakopane', 'PL', 49.2992, 19.9496, 'https://www.zakopane.pl', 'Poland''s winter capital in the Tatra Mountains with Kasprowy Wierch skiing.'),
-- Scotland
(gen_random_uuid(), 'cairngorm-mountain', 'Cairngorm Mountain', 'GB', 57.1167, -3.6667, 'https://www.cairngormmountain.co.uk', 'Scotland''s best-known ski area in the Cairngorms near Aviemore.'),
(gen_random_uuid(), 'glenshee', 'Glenshee', 'GB', 56.8833, -3.4167, 'https://www.ski-glenshee.co.uk', 'The largest ski centre in Scotland, spread across three valleys.'),
(gen_random_uuid(), 'nevis-range', 'Nevis Range', 'GB', 56.8167, -5.0167, 'https://www.nevisrange.co.uk', 'Resort on Aonach Mòr near Fort William reached by gondola.'),
-- Slovakia
(gen_random_uuid(), 'jasna', 'Jasná', 'SK', 48.9700, 19.5800, 'https://www.jasna.sk', 'The largest resort in the Low Tatras and the best in Slovakia.'),
-- Czech Republic
(gen_random_uuid(), 'spindleruv-mlyn', 'Špindlerův Mlýn', 'CZ', 50.7253, 15.6097, 'https://www.skiareal.cz', 'Top Czech resort in the Krkonoše (Giant) Mountains.'),
-- ============================ NORTH AMERICA ============================
-- USA
(gen_random_uuid(), 'vail', 'Vail', 'US', 39.6403, -106.3742, 'https://www.vail.com', 'Colorado giant famous for its expansive Back Bowls and Blue Sky Basin.'),
(gen_random_uuid(), 'aspen-snowmass', 'Aspen Snowmass', 'US', 39.2097, -106.9494, 'https://www.aspensnowmass.com', 'Four mountains around historic Aspen, from Snowmass to Aspen Highlands.'),
(gen_random_uuid(), 'park-city', 'Park City', 'US', 40.6514, -111.5080, 'https://www.parkcitymountain.com', 'Largest ski resort in the United States, just outside Salt Lake City.'),
(gen_random_uuid(), 'jackson-hole', 'Jackson Hole', 'US', 43.5875, -110.8278, 'https://www.jacksonhole.com', 'Steep, big-mountain Wyoming resort famed for Corbet''s Couloir.'),
(gen_random_uuid(), 'breckenridge', 'Breckenridge', 'US', 39.4817, -106.0670, 'https://www.breckenridge.com', 'Historic Colorado mining town with high alpine bowls and a lively Main Street.'),
(gen_random_uuid(), 'mammoth-mountain', 'Mammoth Mountain', 'US', 37.6308, -119.0326, 'https://www.mammothmountain.com', 'Towering Eastern Sierra volcano with deep snow and a long season.'),
(gen_random_uuid(), 'palisades-tahoe', 'Palisades Tahoe', 'US', 39.1969, -120.2358, 'https://www.palisadestahoe.com', 'Two linked Lake Tahoe mountains (formerly Squaw Valley) and 1960 Olympic host.'),
(gen_random_uuid(), 'heavenly', 'Heavenly', 'US', 38.9353, -119.9400, 'https://www.skiheavenly.com', 'Straddles California and Nevada with sweeping views over Lake Tahoe.'),
(gen_random_uuid(), 'steamboat', 'Steamboat', 'US', 40.4572, -106.8045, 'https://www.steamboat.com', 'Colorado resort renowned for its champagne powder and tree skiing.'),
(gen_random_uuid(), 'telluride', 'Telluride', 'US', 37.9375, -107.8123, 'https://www.tellurideskiresort.com', 'Dramatic box-canyon resort in the San Juan Mountains of Colorado.'),
(gen_random_uuid(), 'big-sky', 'Big Sky', 'US', 45.2858, -111.4011, 'https://www.bigskyresort.com', 'Vast Montana resort crowned by the steep Lone Peak tram.'),
(gen_random_uuid(), 'killington', 'Killington', 'US', 43.6045, -72.8201, 'https://www.killington.com', 'The Beast of the East, the largest ski area in Vermont.'),
(gen_random_uuid(), 'stowe', 'Stowe', 'US', 44.5303, -72.7814, 'https://www.stowe.com', 'Classic New England resort on Mount Mansfield, Vermont''s highest peak.'),
(gen_random_uuid(), 'snowbird', 'Snowbird', 'US', 40.5811, -111.6558, 'https://www.snowbird.com', 'Steep, deep Little Cottonwood Canyon resort with legendary Utah powder.'),
(gen_random_uuid(), 'alta', 'Alta', 'US', 40.5883, -111.6386, 'https://www.alta.com', 'Skier-only Utah institution renowned for abundant light snow.'),
(gen_random_uuid(), 'deer-valley', 'Deer Valley', 'US', 40.6374, -111.4783, 'https://www.deervalley.com', 'Luxury, skier-only Utah resort known for impeccable service and grooming.'),
(gen_random_uuid(), 'beaver-creek', 'Beaver Creek', 'US', 39.6042, -106.5167, 'https://www.beavercreek.com', 'Refined Colorado resort near Vail with the Birds of Prey downhill.'),
(gen_random_uuid(), 'keystone', 'Keystone', 'US', 39.6084, -105.9437, 'https://www.keystoneresort.com', 'Family-friendly Colorado resort with extensive night skiing.'),
(gen_random_uuid(), 'copper-mountain', 'Copper Mountain', 'US', 39.5022, -106.1517, 'https://www.coppercolorado.com', 'Naturally divided Colorado terrain and a U.S. team training base.'),
(gen_random_uuid(), 'winter-park', 'Winter Park', 'US', 39.8868, -105.7625, 'https://www.winterparkresort.com', 'Colorado''s longest continually operated resort, famed for Mary Jane''s bumps.'),
(gen_random_uuid(), 'sun-valley', 'Sun Valley', 'US', 43.6963, -114.3517, 'https://www.sunvalley.com', 'America''s first destination ski resort, on Bald Mountain in Idaho.'),
(gen_random_uuid(), 'taos-ski-valley', 'Taos Ski Valley', 'US', 36.5957, -105.4547, 'https://www.skitaos.com', 'Steep, high New Mexico resort with a distinctive Southwestern character.'),
(gen_random_uuid(), 'mt-bachelor', 'Mt. Bachelor', 'US', 43.9794, -121.6883, 'https://www.mtbachelor.com', 'Volcanic Oregon resort offering 360-degree skiing from the summit.'),
(gen_random_uuid(), 'crystal-mountain', 'Crystal Mountain', 'US', 46.9286, -121.4750, 'https://www.crystalmountainresort.com', 'Washington''s largest resort with views of Mount Rainier.'),
(gen_random_uuid(), 'stevens-pass', 'Stevens Pass', 'US', 47.7448, -121.0890, 'https://www.stevenspass.com', 'Cascades resort within easy reach of Seattle, with strong night skiing.'),
(gen_random_uuid(), 'whiteface', 'Whiteface', 'US', 44.3658, -73.9026, 'https://www.whiteface.com', 'Lake Placid resort with the greatest vertical drop in the East.'),
(gen_random_uuid(), 'sugarbush', 'Sugarbush', 'US', 44.1361, -72.8950, 'https://www.sugarbush.com', 'Vermont resort spanning Lincoln Peak and Mount Ellen.'),
(gen_random_uuid(), 'snowbasin', 'Snowbasin', 'US', 41.2160, -111.8569, 'https://www.snowbasin.com', 'Utah resort with luxurious lodges and 2002 Olympic downhill courses.'),
(gen_random_uuid(), 'brighton', 'Brighton', 'US', 40.5977, -111.5836, 'https://www.brightonresort.com', 'Laid-back Big Cottonwood Canyon resort popular with locals and freestylers.'),
(gen_random_uuid(), 'mt-hood-meadows', 'Mt. Hood Meadows', 'US', 45.3317, -121.6650, 'https://www.skihood.com', 'The largest ski area on Oregon''s Mount Hood.'),
(gen_random_uuid(), 'schweitzer', 'Schweitzer', 'US', 48.3672, -116.6228, 'https://www.schweitzer.com', 'Idaho''s biggest resort, overlooking Lake Pend Oreille in the Panhandle.'),
(gen_random_uuid(), 'arapahoe-basin', 'Arapahoe Basin', 'US', 39.6425, -105.8719, 'https://www.arapahoebasin.com', 'High-altitude Colorado resort with steep terrain and a famously long season.'),
-- Canada
(gen_random_uuid(), 'whistler-blackcomb', 'Whistler Blackcomb', 'CA', 50.1163, -122.9574, 'https://www.whistlerblackcomb.com', 'North America''s largest resort and 2010 Olympic alpine venue.'),
(gen_random_uuid(), 'banff-sunshine', 'Banff Sunshine', 'CA', 51.0780, -115.7610, 'https://www.skibig3.com', 'High, snowy resort straddling the Continental Divide in Banff National Park.'),
(gen_random_uuid(), 'lake-louise', 'Lake Louise', 'CA', 51.4419, -116.1773, 'https://www.skilouise.com', 'One of Canada''s largest resorts, set amid the iconic Banff scenery.'),
(gen_random_uuid(), 'revelstoke', 'Revelstoke', 'CA', 50.9583, -118.1636, 'https://www.revelstokemountainresort.com', 'Holds the greatest lift-served vertical in North America, with deep BC snow.'),
(gen_random_uuid(), 'mont-tremblant', 'Mont-Tremblant', 'CA', 46.2092, -74.5850, 'https://www.tremblant.ca', 'Premier Eastern Canada resort with a vibrant pedestrian village in Québec.'),
(gen_random_uuid(), 'sun-peaks', 'Sun Peaks', 'CA', 50.8836, -119.8869, 'https://www.sunpeaksresort.com', 'British Columbia''s second-largest ski area with a sunny village.'),
(gen_random_uuid(), 'big-white', 'Big White', 'CA', 49.7167, -118.9333, 'https://www.bigwhite.com', 'BC resort celebrated for its champagne powder and snow ghosts.'),
(gen_random_uuid(), 'kicking-horse', 'Kicking Horse', 'CA', 51.2978, -117.0472, 'https://www.kickinghorseresort.com', 'Steep, advanced BC resort with renowned big-mountain bowls.'),
(gen_random_uuid(), 'fernie', 'Fernie', 'CA', 49.4628, -115.0856, 'https://www.skifernie.com', 'Legendary powder resort in the BC Rockies with five alpine bowls.'),
(gen_random_uuid(), 'mont-sainte-anne', 'Mont-Sainte-Anne', 'CA', 47.0750, -70.9050, 'https://www.mont-sainte-anne.com', 'Québec resort near Québec City with extensive night skiing.'),
(gen_random_uuid(), 'blue-mountain', 'Blue Mountain', 'CA', 44.5018, -80.3097, 'https://www.bluemountain.ca', 'Ontario''s largest resort on the shores of Georgian Bay.'),
-- ============================ ASIA ============================
-- Japan
(gen_random_uuid(), 'niseko-united', 'Niseko United', 'JP', 42.8048, 140.6874, 'https://www.niseko.ne.jp', 'Hokkaido powder capital with four interconnected ski areas.'),
(gen_random_uuid(), 'hakuba-valley', 'Hakuba Valley', 'JP', 36.6983, 137.8378, 'https://www.hakubavalley.com', 'Nagano valley of ten resorts and a 1998 Winter Olympics host.'),
(gen_random_uuid(), 'furano', 'Furano', 'JP', 43.3139, 142.3792, NULL, 'Central Hokkaido resort known for dry powder and quieter slopes.'),
(gen_random_uuid(), 'rusutsu', 'Rusutsu', 'JP', 42.7411, 140.8983, 'https://www.rusutsu.com', 'Hokkaido resort famed for tree runs and abundant light snow.'),
(gen_random_uuid(), 'shiga-kogen', 'Shiga Kogen', 'JP', 36.7167, 138.5167, NULL, 'Japan''s largest connected ski area, in the Nagano highlands.'),
(gen_random_uuid(), 'nozawa-onsen', 'Nozawa Onsen', 'JP', 36.9239, 138.4439, 'https://www.nozawaski.com', 'Historic hot-spring village resort with deep snow and tradition.'),
(gen_random_uuid(), 'myoko-kogen', 'Myoko Kogen', 'JP', 36.8917, 138.2236, NULL, 'Niigata region known for extremely heavy snowfall and old-school charm.'),
(gen_random_uuid(), 'zao-onsen', 'Zao Onsen', 'JP', 38.1667, 140.4000, NULL, 'Yamagata resort famous for its frost-covered snow monsters.'),
(gen_random_uuid(), 'appi-kogen', 'Appi Kogen', 'JP', 40.0167, 140.9667, NULL, 'Tohoku resort celebrated for long, well-groomed cruising runs.'),
(gen_random_uuid(), 'naeba', 'Naeba', 'JP', 36.7847, 138.7894, NULL, 'Niigata resort linked to Kagura by the long Dragondola gondola.'),
-- South Korea
(gen_random_uuid(), 'yongpyong', 'Yongpyong', 'KR', 37.6447, 128.6817, 'https://www.yongpyong.co.kr', 'Korea''s largest resort and a venue for the 2018 Winter Olympics.'),
(gen_random_uuid(), 'high1', 'High1', 'KR', 37.2117, 128.8267, 'https://www.high1.com', 'Large Gangwon resort combining skiing with a casino and hotels.'),
-- China
(gen_random_uuid(), 'yabuli', 'Yabuli', 'CN', 44.7667, 128.6333, NULL, 'One of China''s largest and oldest resorts, in Heilongjiang province.'),
(gen_random_uuid(), 'wanlong', 'Wanlong', 'CN', 40.9783, 115.3933, NULL, 'Popular Chongli resort near Beijing in the Zhangjiakou ski region.'),
-- ============================ SOUTH AMERICA ============================
-- Chile
(gen_random_uuid(), 'valle-nevado', 'Valle Nevado', 'CL', -33.3556, -70.2486, 'https://www.vallenevado.com', 'Modern Andes resort near Santiago with the largest area in South America.'),
(gen_random_uuid(), 'portillo', 'Portillo', 'CL', -32.8350, -70.1289, 'https://www.skiportillo.com', 'Iconic yellow-hotel resort beside Laguna del Inca high in the Andes.'),
(gen_random_uuid(), 'la-parva', 'La Parva', 'CL', -33.3300, -70.2900, 'https://www.laparva.cl', 'Andes resort near Santiago popular with locals, part of Tres Valles.'),
(gen_random_uuid(), 'nevados-de-chillan', 'Nevados de Chillán', 'CL', -36.9056, -71.4061, 'https://www.nevadosdechillan.com', 'Volcanic resort with thermal springs and one of the longest runs in South America.'),
-- Argentina
(gen_random_uuid(), 'cerro-catedral', 'Cerro Catedral', 'AR', -41.1667, -71.4333, 'https://www.catedralaltapatagonia.com', 'Largest resort in South America, above Bariloche in Patagonia.'),
(gen_random_uuid(), 'las-lenas', 'Las Leñas', 'AR', -35.1500, -70.0833, 'https://www.laslenas.com', 'High Andes resort renowned for steep, extensive off-piste terrain.'),
(gen_random_uuid(), 'chapelco', 'Chapelco', 'AR', -40.2167, -71.2500, 'https://www.chapelco.com', 'Scenic Patagonian resort near San Martín de los Andes.'),
(gen_random_uuid(), 'cerro-castor', 'Cerro Castor', 'AR', -54.7167, -68.0167, 'https://www.cerrocastor.com', 'The world''s southernmost ski resort, near Ushuaia in Tierra del Fuego.'),
-- ============================ OCEANIA ============================
-- Australia
(gen_random_uuid(), 'thredbo', 'Thredbo', 'AU', -36.5042, 148.3000, 'https://www.thredbo.com.au', 'New South Wales resort with Australia''s longest runs in the Snowy Mountains.'),
(gen_random_uuid(), 'perisher', 'Perisher', 'AU', -36.4058, 148.4111, 'https://www.perisher.com.au', 'The largest ski resort in the Southern Hemisphere, in Kosciuszko National Park.'),
(gen_random_uuid(), 'mt-buller', 'Mt Buller', 'AU', -37.1467, 146.4392, 'https://www.mtbuller.com.au', 'Victoria''s most accessible major resort, within reach of Melbourne.'),
(gen_random_uuid(), 'falls-creek', 'Falls Creek', 'AU', -36.8656, 147.2861, 'https://www.fallscreek.com.au', 'Alpine village resort in Victoria with strong snowmaking and Nordic trails.'),
(gen_random_uuid(), 'mt-hotham', 'Mt Hotham', 'AU', -36.9761, 147.1361, 'https://www.mthotham.com.au', 'High Victorian resort known for its powder and unusual ski-down village.'),
-- New Zealand
(gen_random_uuid(), 'coronet-peak', 'Coronet Peak', 'NZ', -44.9200, 168.7350, 'https://www.nzski.com', 'Queenstown''s closest field, famous for night skiing above Lake Wakatipu.'),
(gen_random_uuid(), 'the-remarkables', 'The Remarkables', 'NZ', -45.0556, 168.8089, 'https://www.nzski.com', 'Dramatic Queenstown resort with sunny basins and good beginner terrain.'),
(gen_random_uuid(), 'cardrona', 'Cardrona', 'NZ', -44.8722, 168.9486, 'https://www.cardrona.com', 'Wanaka-area resort and a leading freestyle and park destination.'),
(gen_random_uuid(), 'treble-cone', 'Treble Cone', 'NZ', -44.6333, 168.8972, 'https://www.treblecone.com', 'The largest South Island field, prized for steep terrain above Lake Wanaka.'),
(gen_random_uuid(), 'mt-hutt', 'Mt Hutt', 'NZ', -43.4708, 171.5314, 'https://www.nzski.com', 'Canterbury resort with the longest season in New Zealand.'),
-- ============================ MIDDLE EAST / CAUCASUS / SOUTH ASIA ============================
-- Turkey
(gen_random_uuid(), 'uludag', 'Uludağ', 'TR', 40.0967, 29.2222, NULL, 'Turkey''s most famous resort, on a mountain rising above Bursa.'),
(gen_random_uuid(), 'palandoken', 'Palandöken', 'TR', 39.8667, 41.2333, NULL, 'High-altitude Erzurum resort with some of Turkey''s steepest, longest runs.'),
(gen_random_uuid(), 'erciyes', 'Erciyes', 'TR', 38.5333, 35.5500, 'https://www.erciyes.gen.tr', 'Modern resort on a volcano near Kayseri in central Anatolia.'),
-- Georgia
(gen_random_uuid(), 'gudauri', 'Gudauri', 'GE', 42.4761, 44.4781, NULL, 'High Caucasus resort on the Georgian Military Highway, popular for freeride.'),
(gen_random_uuid(), 'bakuriani', 'Bakuriani', 'GE', 41.7497, 43.5331, NULL, 'Historic Georgian resort with gentle slopes in the Lesser Caucasus.'),
-- Iran
(gen_random_uuid(), 'dizin', 'Dizin', 'IR', 36.0500, 51.4167, NULL, 'High Alborz resort north of Tehran, one of the highest in the world.'),
(gen_random_uuid(), 'shemshak', 'Shemshak', 'IR', 35.9333, 51.5333, NULL, 'Steeper Alborz resort near Tehran, popular with advanced skiers.'),
-- India
(gen_random_uuid(), 'gulmarg', 'Gulmarg', 'IN', 34.0500, 74.3833, NULL, 'Himalayan resort in Kashmir with one of the world''s highest gondolas.'),
(gen_random_uuid(), 'auli', 'Auli', 'IN', 30.5300, 79.5700, NULL, 'Uttarakhand resort with views of Nanda Devi in the Garhwal Himalayas.'),
-- Lebanon
(gen_random_uuid(), 'mzaar-kfardebian', 'Mzaar Kfardebian', 'LB', 34.0167, 35.8333, 'https://www.mzaarskiresort.com', 'The largest resort in the Middle East, in the mountains above Beirut.')
ON CONFLICT (slug) DO NOTHING;
