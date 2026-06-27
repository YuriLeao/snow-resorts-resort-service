-- Expands the catalog with additional world-class resorts (with a focus on South
-- America) and seeds representative, real-named pistes (and a few lifts) for the
-- marquee resorts. Valle Nevado trails/lifts are already covered by V3.
--
-- Conventions (mirrors V1/V2/V3):
--   * search_path is set to resorts, public.
--   * ids via gen_random_uuid(); foreign keys resolved by sub-select on the slug.
--   * resorts use ON CONFLICT (slug) DO NOTHING so existing rows are untouched.
--   * trails/lifts have no natural unique key, so each INSERT ... SELECT is guarded
--     by NOT EXISTS on (resort_id, name) to stay idempotent if re-run.
--   * geom is a short, plausible LineString (EPSG:4326, "lng lat") near the resort.
SET search_path TO resorts, public;

-- ============================================================================
-- Part 1 — additional resorts (idempotent via ON CONFLICT (slug) DO NOTHING)
-- ============================================================================
INSERT INTO resorts (id, slug, name, country, lat, lng, official_url, description) VALUES
-- ---------------------------- South America --------------------------------
-- Chile
(gen_random_uuid(), 'el-colorado', 'El Colorado', 'CL', -33.3486, -70.2960, 'https://www.elcolorado.cl', 'Farellones-based resort and part of the Tres Valles area near Santiago, linked with La Parva and Valle Nevado.'),
(gen_random_uuid(), 'corralco', 'Corralco', 'CL', -38.4439, -71.6014, 'https://www.corralco.com', 'Resort on the slopes of the Lonquimay volcano amid araucaria forests in the Araucanía region.'),
(gen_random_uuid(), 'antillanca', 'Antillanca', 'CL', -40.7667, -72.1833, NULL, 'Resort on the Casablanca volcano in the Puyehue area, known for its forested runs and lake views.'),
-- Argentina
(gen_random_uuid(), 'caviahue', 'Caviahue', 'AR', -37.8667, -71.0667, 'https://www.caviahue.com', 'Neuquén resort beside the Copahue volcano and its crater lakes, with araucaria-lined slopes.'),
(gen_random_uuid(), 'cerro-bayo', 'Cerro Bayo', 'AR', -40.7333, -71.6167, 'https://www.cerrobayoweb.com', 'Boutique resort above Villa La Angostura with sweeping views over Lake Nahuel Huapi.'),
(gen_random_uuid(), 'la-hoya', 'La Hoya', 'AR', -42.8500, -71.2000, 'https://www.skilahoya.com', 'Sunny, snow-sure resort near Esquel in Chubut, prized for its long season and value.'),
(gen_random_uuid(), 'los-penitentes', 'Los Penitentes', 'AR', -32.8667, -69.9500, NULL, 'Mendoza resort on the international road to Aconcagua, with terrain on both sides of the valley.'),
-- ------------------------------- Europe ------------------------------------
(gen_random_uuid(), 'flaine', 'Flaine', 'FR', 46.0028, 6.6900, 'https://www.flaine.com', 'Bauhaus-styled, snow-sure resort at the heart of the Grand Massif above the Arve valley.'),
(gen_random_uuid(), 'morzine', 'Morzine', 'FR', 46.1791, 6.7089, 'https://www.morzine-avoriaz.com', 'Traditional Haute-Savoie town at the centre of the cross-border Portes du Soleil.'),
-- --------------------------- North America ---------------------------------
(gen_random_uuid(), 'crested-butte', 'Crested Butte', 'US', 38.8991, -106.9656, 'https://www.skicb.com', 'Colorado resort regarded as a birthplace of extreme skiing, with steep, ungroomed terrain.'),
-- ------------------------------- Asia --------------------------------------
(gen_random_uuid(), 'kiroro', 'Kiroro', 'JP', 43.0667, 140.9939, 'https://www.kiroro.co.jp', 'Snow-heavy Hokkaido resort west of Sapporo, famed for deep, dry powder and a long season.')
ON CONFLICT (slug) DO NOTHING;

-- ============================================================================
-- Part 2 — trails (pistes). One guarded INSERT per resort; geom is a short
-- LineString near the resort coordinate. Difficulty in {green, blue, black, red}.
-- ============================================================================

-- ---------------------------- Chile: El Colorado ---------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Cono Este',      'red',   'LINESTRING(-70.2960 -33.3486, -70.2945 -33.3470, -70.2930 -33.3455)'),
    ('Las Hortensias', 'blue',  'LINESTRING(-70.2980 -33.3500, -70.2965 -33.3485, -70.2950 -33.3470)'),
    ('Olímpica',       'blue',  'LINESTRING(-70.2940 -33.3510, -70.2928 -33.3495, -70.2916 -33.3480)'),
    ('El Mirador',     'black', 'LINESTRING(-70.3000 -33.3460, -70.2985 -33.3445, -70.2970 -33.3430)'),
    ('La Cancha',      'green', 'LINESTRING(-70.2955 -33.3520, -70.2945 -33.3508, -70.2935 -33.3496)'),
    ('Cancha Tabla',   'blue',  'LINESTRING(-70.2925 -33.3525, -70.2915 -33.3512, -70.2905 -33.3500)'),
    ('Santa Teresita', 'green', 'LINESTRING(-70.2970 -33.3530, -70.2960 -33.3518, -70.2950 -33.3506)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'el-colorado'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ------------------------------ Chile: La Parva ----------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('La Paloma',          'blue',  'LINESTRING(-70.2900 -33.3300, -70.2888 -33.3286, -70.2876 -33.3272)'),
    ('El Águila',          'black', 'LINESTRING(-70.2920 -33.3290, -70.2906 -33.3276, -70.2892 -33.3262)'),
    ('Las Lomas',          'blue',  'LINESTRING(-70.2880 -33.3315, -70.2868 -33.3301, -70.2856 -33.3287)'),
    ('Cancha de Carreras', 'red',   'LINESTRING(-70.2910 -33.3320, -70.2898 -33.3306, -70.2886 -33.3292)'),
    ('Franciscano',        'blue',  'LINESTRING(-70.2895 -33.3330, -70.2884 -33.3316, -70.2873 -33.3302)'),
    ('El Pollerón',        'black', 'LINESTRING(-70.2935 -33.3280, -70.2921 -33.3266, -70.2907 -33.3252)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'la-parva'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ------------------------------ Chile: Portillo ----------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('El Plateau',     'blue',  'LINESTRING(-70.1289 -32.8350, -70.1275 -32.8338, -70.1261 -32.8326)'),
    ('Juncalillo',     'blue',  'LINESTRING(-70.1310 -32.8360, -70.1296 -32.8348, -70.1282 -32.8336)'),
    ('Roca Jack',      'black', 'LINESTRING(-70.1330 -32.8330, -70.1316 -32.8318, -70.1302 -32.8306)'),
    ('Lake Run',       'red',   'LINESTRING(-70.1270 -32.8370, -70.1256 -32.8358, -70.1242 -32.8346)'),
    ('El Estadio',     'blue',  'LINESTRING(-70.1300 -32.8345, -70.1287 -32.8333, -70.1274 -32.8321)'),
    ('La Garganta',    'black', 'LINESTRING(-70.1345 -32.8320, -70.1331 -32.8308, -70.1317 -32.8296)'),
    ('Las Vizcachas',  'green', 'LINESTRING(-70.1285 -32.8380, -70.1273 -32.8368, -70.1261 -32.8356)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'portillo'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ------------------------- Chile: Nevados de Chillán -----------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Pista Larga',     'red',   'LINESTRING(-71.4061 -36.9056, -71.4030 -36.9020, -71.3995 -36.8985, -71.3960 -36.8950)'),
    ('Las Tres Marías', 'blue',  'LINESTRING(-71.4080 -36.9070, -71.4062 -36.9054, -71.4044 -36.9038)'),
    ('El Pellín',       'blue',  'LINESTRING(-71.4045 -36.9075, -71.4028 -36.9059, -71.4011 -36.9043)'),
    ('Otto',            'black', 'LINESTRING(-71.4095 -36.9050, -71.4078 -36.9034, -71.4061 -36.9018)'),
    ('Los Pioneros',    'blue',  'LINESTRING(-71.4070 -36.9085, -71.4053 -36.9069, -71.4036 -36.9053)'),
    ('Shangri-La',      'red',   'LINESTRING(-71.4110 -36.9040, -71.4093 -36.9024, -71.4076 -36.9008)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'nevados-de-chillan'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- -------------------------- Argentina: Cerro Catedral ----------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Nubes',        'blue',  'LINESTRING(-71.4333 -41.1667, -71.4318 -41.1652, -71.4303 -41.1637)'),
    ('La Laguna',    'red',   'LINESTRING(-71.4355 -41.1675, -71.4340 -41.1660, -71.4325 -41.1645)'),
    ('Lynch',        'red',   'LINESTRING(-71.4310 -41.1685, -71.4296 -41.1670, -71.4282 -41.1655)'),
    ('Princesa',     'blue',  'LINESTRING(-71.4345 -41.1690, -71.4331 -41.1675, -71.4317 -41.1660)'),
    ('Cóndor',       'black', 'LINESTRING(-71.4375 -41.1660, -71.4360 -41.1645, -71.4345 -41.1630)'),
    ('Slalom',       'red',   'LINESTRING(-71.4325 -41.1700, -71.4311 -41.1685, -71.4297 -41.1670)'),
    ('Punta Nevada', 'blue',  'LINESTRING(-71.4360 -41.1705, -71.4346 -41.1690, -71.4332 -41.1675)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'cerro-catedral'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- --------------------------- Argentina: Las Leñas --------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Marte',   'black', 'LINESTRING(-70.0833 -35.1500, -70.0818 -35.1485, -70.0803 -35.1470)'),
    ('Venus',   'red',   'LINESTRING(-70.0855 -35.1510, -70.0840 -35.1495, -70.0825 -35.1480)'),
    ('Apolo',   'blue',  'LINESTRING(-70.0815 -35.1520, -70.0801 -35.1505, -70.0787 -35.1490)'),
    ('Neptuno', 'red',   'LINESTRING(-70.0845 -35.1525, -70.0831 -35.1510, -70.0817 -35.1495)'),
    ('Júpiter', 'blue',  'LINESTRING(-70.0825 -35.1535, -70.0811 -35.1520, -70.0797 -35.1505)'),
    ('Eros',    'black', 'LINESTRING(-70.0875 -35.1490, -70.0860 -35.1475, -70.0845 -35.1460)'),
    ('Vulcano', 'red',   'LINESTRING(-70.0865 -35.1530, -70.0851 -35.1515, -70.0837 -35.1500)'),
    ('Iris',    'green', 'LINESTRING(-70.0840 -35.1545, -70.0828 -35.1532, -70.0816 -35.1519)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'las-lenas'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ---------------------------- Argentina: Chapelco --------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('El Bosque',            'blue',  'LINESTRING(-71.2500 -40.2167, -71.2485 -40.2152, -71.2470 -40.2137)'),
    ('Pendiente del Diablo', 'black', 'LINESTRING(-71.2520 -40.2175, -71.2505 -40.2160, -71.2490 -40.2145)'),
    ('La Cima',              'red',   'LINESTRING(-71.2480 -40.2185, -71.2466 -40.2170, -71.2452 -40.2155)'),
    ('Tom & Jerry',          'blue',  'LINESTRING(-71.2510 -40.2190, -71.2496 -40.2175, -71.2482 -40.2160)'),
    ('Crucero',              'green', 'LINESTRING(-71.2495 -40.2200, -71.2483 -40.2188, -71.2471 -40.2176)'),
    ('Pista de Lujo',        'red',   'LINESTRING(-71.2530 -40.2160, -71.2516 -40.2145, -71.2502 -40.2130)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'chapelco'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- -------------------------- Argentina: Cerro Castor ------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Del Bosque', 'blue',  'LINESTRING(-68.0167 -54.7167, -68.0150 -54.7155, -68.0133 -54.7143)'),
    ('Cumbre',     'red',   'LINESTRING(-68.0190 -54.7175, -68.0173 -54.7163, -68.0156 -54.7151)'),
    ('La Cornisa', 'black', 'LINESTRING(-68.0150 -54.7185, -68.0133 -54.7173, -68.0116 -54.7161)'),
    ('Krund',      'blue',  'LINESTRING(-68.0180 -54.7190, -68.0163 -54.7178, -68.0146 -54.7166)'),
    ('Mladki',     'green', 'LINESTRING(-68.0165 -54.7200, -68.0151 -54.7189, -68.0137 -54.7178)'),
    ('Forestal',   'blue',  'LINESTRING(-68.0200 -54.7165, -68.0183 -54.7153, -68.0166 -54.7141)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'cerro-castor'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ----------------------------- Argentina: Caviahue -------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('El Volcán',  'red',   'LINESTRING(-71.0667 -37.8667, -71.0650 -37.8653, -71.0633 -37.8639)'),
    ('Las Termas', 'blue',  'LINESTRING(-71.0690 -37.8675, -71.0673 -37.8661, -71.0656 -37.8647)'),
    ('El Bosque',  'green', 'LINESTRING(-71.0650 -37.8685, -71.0636 -37.8671, -71.0622 -37.8657)'),
    ('La Montaña', 'blue',  'LINESTRING(-71.0680 -37.8690, -71.0666 -37.8676, -71.0652 -37.8662)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'caviahue'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ------------------------------ France: Chamonix ---------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Vallée Blanche',        'red',   'LINESTRING(6.8694 45.9237, 6.8720 45.9210, 6.8746 45.9183, 6.8772 45.9156)'),
    ('Bochard',               'red',   'LINESTRING(6.8750 45.9270, 6.8736 45.9255, 6.8722 45.9240)'),
    ('Point de Vue',          'red',   'LINESTRING(6.8770 45.9260, 6.8756 45.9245, 6.8742 45.9230)'),
    ('Pierre à Ric',          'blue',  'LINESTRING(6.8730 45.9280, 6.8716 45.9265, 6.8702 45.9250)'),
    ('La Variante Hôtel',     'black', 'LINESTRING(6.8710 45.9250, 6.8696 45.9235, 6.8682 45.9220)'),
    ('Combe de la Pendant',   'red',   'LINESTRING(6.8790 45.9245, 6.8776 45.9230, 6.8762 45.9215)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'chamonix-mont-blanc'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- --------------------------- Switzerland: Zermatt --------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Triftji',   'black', 'LINESTRING(7.7491 46.0207, 7.7510 46.0188, 7.7529 46.0169)'),
    ('Stockhorn', 'black', 'LINESTRING(7.7530 46.0215, 7.7549 46.0196, 7.7568 46.0177)'),
    ('Furgg',     'blue',  'LINESTRING(7.7470 46.0220, 7.7484 46.0204, 7.7498 46.0188)'),
    ('Gornergrat','red',   'LINESTRING(7.7515 46.0230, 7.7531 46.0213, 7.7547 46.0196)'),
    ('Sunnegga',  'blue',  'LINESTRING(7.7460 46.0235, 7.7475 46.0220, 7.7490 46.0205)'),
    ('National',  'red',   'LINESTRING(7.7500 46.0245, 7.7486 46.0230, 7.7472 46.0215)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'zermatt'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ----------------------------- France: Val Thorens -------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Pluviomètre',    'red',   'LINESTRING(6.5800 45.2978, 6.5816 45.2962, 6.5832 45.2946)'),
    ('Combe de Caron', 'red',   'LINESTRING(6.5770 45.2960, 6.5786 45.2944, 6.5802 45.2928)'),
    ('Col',            'blue',  'LINESTRING(6.5820 45.2990, 6.5836 45.2974, 6.5852 45.2958)'),
    ('Cristaux',       'red',   'LINESTRING(6.5840 45.2970, 6.5856 45.2954, 6.5872 45.2938)'),
    ('Béranger',       'blue',  'LINESTRING(6.5790 45.2995, 6.5806 45.2979, 6.5822 45.2963)'),
    ('Lac Blanc',      'blue',  'LINESTRING(6.5760 45.2980, 6.5776 45.2964, 6.5792 45.2948)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'val-thorens'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ----------------------------- Austria: St. Anton --------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Kandahar',      'black', 'LINESTRING(10.2644 47.1297, 10.2630 47.1283, 10.2616 47.1269)'),
    ('Fang',          'red',   'LINESTRING(10.2665 47.1305, 10.2651 47.1291, 10.2637 47.1277)'),
    ('Schindlerkar',  'black', 'LINESTRING(10.2625 47.1315, 10.2611 47.1301, 10.2597 47.1287)'),
    ('Mattun',        'black', 'LINESTRING(10.2655 47.1320, 10.2641 47.1306, 10.2627 47.1292)'),
    ('Steissbachtal', 'blue',  'LINESTRING(10.2640 47.1330, 10.2628 47.1317, 10.2616 47.1304)'),
    ('Galzig',        'blue',  'LINESTRING(10.2675 47.1290, 10.2661 47.1276, 10.2647 47.1262)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'st-anton-am-arlberg'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ------------------------- Canada: Whistler Blackcomb ----------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Peak to Creek',     'blue',  'LINESTRING(-122.9574 50.1163, -122.9540 50.1135, -122.9506 50.1107, -122.9472 50.1079)'),
    ('Spanky''s Ladder',  'black', 'LINESTRING(-122.9520 50.1180, -122.9506 50.1166, -122.9492 50.1152)'),
    ('Couloir Extreme',   'black', 'LINESTRING(-122.9600 50.1175, -122.9586 50.1161, -122.9572 50.1147)'),
    ('Harmony Ridge',     'blue',  'LINESTRING(-122.9550 50.1190, -122.9536 50.1176, -122.9522 50.1162)'),
    ('Symphony',          'green', 'LINESTRING(-122.9590 50.1150, -122.9576 50.1136, -122.9562 50.1122)'),
    ('Blackcomb Glacier', 'black', 'LINESTRING(-122.9490 50.1195, -122.9476 50.1181, -122.9462 50.1167)'),
    ('7th Heaven',        'blue',  'LINESTRING(-122.9530 50.1200, -122.9516 50.1186, -122.9502 50.1172)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'whistler-blackcomb'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- --------------------------------- USA: Vail -------------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Riva Ridge',  'black', 'LINESTRING(-106.3742 39.6403, -106.3726 39.6388, -106.3710 39.6373)'),
    ('Forever',     'blue',  'LINESTRING(-106.3765 39.6410, -106.3749 39.6395, -106.3733 39.6380)'),
    ('Born Free',   'blue',  'LINESTRING(-106.3720 39.6415, -106.3706 39.6401, -106.3692 39.6387)'),
    ('Sun Up Bowl', 'black', 'LINESTRING(-106.3700 39.6390, -106.3686 39.6376, -106.3672 39.6362)'),
    ('Game Creek',  'blue',  'LINESTRING(-106.3780 39.6395, -106.3766 39.6381, -106.3752 39.6367)'),
    ('Pepi''s Face','black', 'LINESTRING(-106.3750 39.6425, -106.3736 39.6411, -106.3722 39.6397)'),
    ('Lionshead',   'green', 'LINESTRING(-106.3760 39.6420, -106.3748 39.6408, -106.3736 39.6396)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'vail'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ----------------------------- Japan: Niseko United ------------------------
INSERT INTO trails (id, resort_id, name, difficulty, geom)
SELECT gen_random_uuid(), r.id, t.name, t.difficulty, ST_GeomFromText(t.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Miharashi',         'blue',  'LINESTRING(140.6874 42.8048, 140.6858 42.8033, 140.6842 42.8018)'),
    ('Super Course',      'red',   'LINESTRING(140.6895 42.8055, 140.6879 42.8040, 140.6863 42.8025)'),
    ('King Bell',         'blue',  'LINESTRING(140.6855 42.8060, 140.6841 42.8046, 140.6827 42.8032)'),
    ('Strawberry Fields', 'black', 'LINESTRING(140.6915 42.8045, 140.6901 42.8031, 140.6887 42.8017)'),
    ('Jackson Course',    'red',   'LINESTRING(140.6880 42.8070, 140.6866 42.8056, 140.6852 42.8042)'),
    ('Center Four',       'green', 'LINESTRING(140.6865 42.8075, 140.6853 42.8062, 140.6841 42.8049)')
) AS t(name, difficulty, wkt)
WHERE r.slug = 'niseko-united'
  AND NOT EXISTS (SELECT 1 FROM trails x WHERE x.resort_id = r.id AND x.name = t.name);

-- ============================================================================
-- Part 3 — a few real-named lifts for marquee resorts (idempotent on name).
-- ============================================================================

-- El Colorado
INSERT INTO lifts (id, resort_id, name, geom)
SELECT gen_random_uuid(), r.id, l.name, ST_GeomFromText(l.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Telesilla La Cornisa',  'LINESTRING(-70.2980 -33.3520, -70.2960 -33.3490, -70.2940 -33.3460)'),
    ('Telesilla El Mirador',  'LINESTRING(-70.2960 -33.3530, -70.2980 -33.3490, -70.3000 -33.3450)'),
    ('Telesilla Cono Este',   'LINESTRING(-70.2945 -33.3500, -70.2935 -33.3470, -70.2925 -33.3440)')
) AS l(name, wkt)
WHERE r.slug = 'el-colorado'
  AND NOT EXISTS (SELECT 1 FROM lifts x WHERE x.resort_id = r.id AND x.name = l.name);

-- Cerro Catedral
INSERT INTO lifts (id, resort_id, name, geom)
SELECT gen_random_uuid(), r.id, l.name, ST_GeomFromText(l.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Cable Carril',        'LINESTRING(-71.4330 -41.1710, -71.4340 -41.1680, -71.4350 -41.1650)'),
    ('Telesilla Lynch',     'LINESTRING(-71.4300 -41.1700, -71.4310 -41.1670, -71.4320 -41.1640)'),
    ('Telesilla Séxtuple',  'LINESTRING(-71.4350 -41.1715, -71.4358 -41.1685, -71.4366 -41.1655)')
) AS l(name, wkt)
WHERE r.slug = 'cerro-catedral'
  AND NOT EXISTS (SELECT 1 FROM lifts x WHERE x.resort_id = r.id AND x.name = l.name);

-- Las Leñas
INSERT INTO lifts (id, resort_id, name, geom)
SELECT gen_random_uuid(), r.id, l.name, ST_GeomFromText(l.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Telesilla Marte', 'LINESTRING(-70.0830 -35.1545, -70.0820 -35.1510, -70.0810 -35.1475)'),
    ('Telesilla Venus', 'LINESTRING(-70.0855 -35.1540, -70.0845 -35.1505, -70.0835 -35.1470)'),
    ('Telesilla Iris',  'LINESTRING(-70.0840 -35.1555, -70.0832 -35.1530, -70.0824 -35.1505)')
) AS l(name, wkt)
WHERE r.slug = 'las-lenas'
  AND NOT EXISTS (SELECT 1 FROM lifts x WHERE x.resort_id = r.id AND x.name = l.name);

-- Portillo
INSERT INTO lifts (id, resort_id, name, geom)
SELECT gen_random_uuid(), r.id, l.name, ST_GeomFromText(l.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Va et Vient Roca Jack', 'LINESTRING(-70.1335 -32.8360, -70.1325 -32.8330, -70.1315 -32.8300)'),
    ('Telesilla Juncalillo',  'LINESTRING(-70.1310 -32.8375, -70.1300 -32.8345, -70.1290 -32.8315)')
) AS l(name, wkt)
WHERE r.slug = 'portillo'
  AND NOT EXISTS (SELECT 1 FROM lifts x WHERE x.resort_id = r.id AND x.name = l.name);

-- Chamonix
INSERT INTO lifts (id, resort_id, name, geom)
SELECT gen_random_uuid(), r.id, l.name, ST_GeomFromText(l.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Téléphérique Aiguille du Midi', 'LINESTRING(6.8694 45.9237, 6.8772 45.9100, 6.8870 45.8790)'),
    ('Télécabine Bochard',            'LINESTRING(6.8755 45.9295, 6.8745 45.9270, 6.8735 45.9245)')
) AS l(name, wkt)
WHERE r.slug = 'chamonix-mont-blanc'
  AND NOT EXISTS (SELECT 1 FROM lifts x WHERE x.resort_id = r.id AND x.name = l.name);

-- Zermatt
INSERT INTO lifts (id, resort_id, name, geom)
SELECT gen_random_uuid(), r.id, l.name, ST_GeomFromText(l.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Gornergratbahn',               'LINESTRING(7.7491 46.0207, 7.7600 46.0150, 7.7710 46.0093)'),
    ('Matterhorn Glacier Paradise',  'LINESTRING(7.7470 46.0200, 7.7430 46.0050, 7.7390 45.9900)')
) AS l(name, wkt)
WHERE r.slug = 'zermatt'
  AND NOT EXISTS (SELECT 1 FROM lifts x WHERE x.resort_id = r.id AND x.name = l.name);

-- Whistler Blackcomb
INSERT INTO lifts (id, resort_id, name, geom)
SELECT gen_random_uuid(), r.id, l.name, ST_GeomFromText(l.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Peak Express',              'LINESTRING(-122.9574 50.1163, -122.9560 50.1190, -122.9546 50.1217)'),
    ('Whistler Village Gondola',  'LINESTRING(-122.9500 50.1140, -122.9540 50.1170, -122.9580 50.1200)')
) AS l(name, wkt)
WHERE r.slug = 'whistler-blackcomb'
  AND NOT EXISTS (SELECT 1 FROM lifts x WHERE x.resort_id = r.id AND x.name = l.name);

-- Vail
INSERT INTO lifts (id, resort_id, name, geom)
SELECT gen_random_uuid(), r.id, l.name, ST_GeomFromText(l.wkt, 4326)
FROM resorts r
CROSS JOIN (VALUES
    ('Gondola One',         'LINESTRING(-106.3742 39.6403, -106.3730 39.6440, -106.3718 39.6477)'),
    ('Riva Bahn Express',   'LINESTRING(-106.3726 39.6388, -106.3714 39.6420, -106.3702 39.6452)')
) AS l(name, wkt)
WHERE r.slug = 'vail'
  AND NOT EXISTS (SELECT 1 FROM lifts x WHERE x.resort_id = r.id AND x.name = l.name);
