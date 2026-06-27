-- Valle Nevado (Chile) — simplified trail and lift geometry for map overlay.
-- Coordinates are approximate polylines (EPSG:4326, lng lat) aligned to the resort layout.
SET search_path TO resorts, public;

DO $$
DECLARE
    rid UUID;
BEGIN
    SELECT id INTO rid FROM resorts WHERE slug = 'valle-nevado';
    IF rid IS NULL THEN
        RAISE EXCEPTION 'Resort valle-nevado not found — run V2 seed first.';
    END IF;

    -- ---------- Trails ----------
    INSERT INTO trails (id, resort_id, name, difficulty, geom) VALUES
    (gen_random_uuid(), rid, 'Prado', 'green',
     ST_GeomFromText('LINESTRING(-70.2520 -33.3610, -70.2510 -33.3585, -70.2495 -33.3560, -70.2480 -33.3535)', 4326)),
    (gen_random_uuid(), rid, 'Sol', 'blue',
     ST_GeomFromText('LINESTRING(-70.2535 -33.3490, -70.2525 -33.3505, -70.2515 -33.3520, -70.2505 -33.3535, -70.2495 -33.3550)', 4326)),
    (gen_random_uuid(), rid, 'Sol I', 'blue',
     ST_GeomFromText('LINESTRING(-70.2540 -33.3480, -70.2530 -33.3495, -70.2520 -33.3510, -70.2510 -33.3525)', 4326)),
    (gen_random_uuid(), rid, 'Sol II', 'blue',
     ST_GeomFromText('LINESTRING(-70.2530 -33.3475, -70.2520 -33.3490, -70.2510 -33.3505, -70.2500 -33.3520, -70.2490 -33.3535)', 4326)),
    (gen_random_uuid(), rid, 'Luna', 'green',
     ST_GeomFromText('LINESTRING(-70.2515 -33.3485, -70.2505 -33.3500, -70.2495 -33.3515, -70.2485 -33.3530)', 4326)),
    (gen_random_uuid(), rid, 'Retorno Alto', 'blue',
     ST_GeomFromText('LINESTRING(-70.2555 -33.3460, -70.2545 -33.3475, -70.2535 -33.3490, -70.2525 -33.3505, -70.2515 -33.3520)', 4326)),
    (gen_random_uuid(), rid, 'Retorno Medio', 'blue',
     ST_GeomFromText('LINESTRING(-70.2548 -33.3470, -70.2538 -33.3485, -70.2528 -33.3500, -70.2518 -33.3515, -70.2508 -33.3530)', 4326)),
    (gen_random_uuid(), rid, 'Retorno Bajo', 'green',
     ST_GeomFromText('LINESTRING(-70.2540 -33.3480, -70.2530 -33.3495, -70.2520 -33.3510, -70.2510 -33.3525, -70.2500 -33.3540)', 4326)),
    (gen_random_uuid(), rid, 'Can Can', 'blue',
     ST_GeomFromText('LINESTRING(-70.2565 -33.3445, -70.2555 -33.3460, -70.2545 -33.3475, -70.2535 -33.3490)', 4326)),
    (gen_random_uuid(), rid, 'Eclipse', 'black',
     ST_GeomFromText('LINESTRING(-70.2575 -33.3420, -70.2565 -33.3435, -70.2555 -33.3450, -70.2545 -33.3465, -70.2535 -33.3480)', 4326)),
    (gen_random_uuid(), rid, 'Momia', 'red',
     ST_GeomFromText('LINESTRING(-70.2585 -33.3405, -70.2575 -33.3420, -70.2565 -33.3435, -70.2555 -33.3450)', 4326)),
    (gen_random_uuid(), rid, 'Rock & Roll', 'black',
     ST_GeomFromText('LINESTRING(-70.2525 -33.3470, -70.2515 -33.3485, -70.2505 -33.3500, -70.2495 -33.3515)', 4326)),
    (gen_random_uuid(), rid, 'Polka', 'green',
     ST_GeomFromText('LINESTRING(-70.2510 -33.3590, -70.2500 -33.3575, -70.2490 -33.3560, -70.2480 -33.3545)', 4326)),
    (gen_random_uuid(), rid, 'Fox Trot', 'blue',
     ST_GeomFromText('LINESTRING(-70.2505 -33.3585, -70.2495 -33.3570, -70.2485 -33.3555, -70.2475 -33.3540)', 4326)),
    (gen_random_uuid(), rid, 'Vals', 'blue',
     ST_GeomFromText('LINESTRING(-70.2530 -33.3565, -70.2520 -33.3550, -70.2510 -33.3535, -70.2500 -33.3520)', 4326)),
    (gen_random_uuid(), rid, 'Tango I', 'black',
     ST_GeomFromText('LINESTRING(-70.2560 -33.3455, -70.2550 -33.3470, -70.2540 -33.3485, -70.2530 -33.3500)', 4326)),
    (gen_random_uuid(), rid, 'Tango II', 'black',
     ST_GeomFromText('LINESTRING(-70.2555 -33.3460, -70.2545 -33.3475, -70.2535 -33.3490, -70.2525 -33.3505)', 4326)),
    (gen_random_uuid(), rid, 'Milonga', 'red',
     ST_GeomFromText('LINESTRING(-70.2570 -33.3435, -70.2560 -33.3450, -70.2550 -33.3465, -70.2540 -33.3480)', 4326));

    -- ---------- Lifts ----------
    INSERT INTO lifts (id, resort_id, name, geom) VALUES
    (gen_random_uuid(), rid, 'Andes Express',
     ST_GeomFromText('LINESTRING(-70.2520 -33.3605, -70.2525 -33.3575, -70.2530 -33.3545, -70.2535 -33.3515, -70.2540 -33.3485)', 4326)),
    (gen_random_uuid(), rid, 'Gondola Valle',
     ST_GeomFromText('LINESTRING(-70.2510 -33.3610, -70.2515 -33.3580, -70.2520 -33.3550, -70.2525 -33.3520)', 4326)),
    (gen_random_uuid(), rid, 'Telesilla Prado',
     ST_GeomFromText('LINESTRING(-70.2525 -33.3600, -70.2520 -33.3570, -70.2515 -33.3540)', 4326)),
    (gen_random_uuid(), rid, 'Telesilla Sol',
     ST_GeomFromText('LINESTRING(-70.2545 -33.3495, -70.2535 -33.3510, -70.2525 -33.3525)', 4326)),
    (gen_random_uuid(), rid, 'Telesilla Eclipse',
     ST_GeomFromText('LINESTRING(-70.2560 -33.3465, -70.2555 -33.3445, -70.2550 -33.3425)', 4326)),
    (gen_random_uuid(), rid, 'Teleski Momia',
     ST_GeomFromText('LINESTRING(-70.2575 -33.3450, -70.2570 -33.3430, -70.2565 -33.3410)', 4326)),
    (gen_random_uuid(), rid, 'Telecabina Tres Puntas',
     ST_GeomFromText('LINESTRING(-70.2550 -33.3480, -70.2555 -33.3455, -70.2560 -33.3430, -70.2565 -33.3405)', 4326)),
    (gen_random_uuid(), rid, 'Magic Carpet Prado',
     ST_GeomFromText('LINESTRING(-70.2528 -33.3605, -70.2523 -33.3585)', 4326)),
    (gen_random_uuid(), rid, 'Telesilla Can Can',
     ST_GeomFromText('LINESTRING(-70.2555 -33.3475, -70.2560 -33.3455, -70.2565 -33.3435)', 4326)),
    (gen_random_uuid(), rid, 'Telesilla Luna',
     ST_GeomFromText('LINESTRING(-70.2518 -33.3490, -70.2513 -33.3510, -70.2508 -33.3530)', 4326));
END $$;
