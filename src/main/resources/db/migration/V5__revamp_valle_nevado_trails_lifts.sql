-- Valle Nevado (Chile) — revamped, higher-fidelity trail & lift geometry.
--
-- Why a new migration (not editing V3): Flyway migrations are immutable once
-- applied, so editing V3 would break checksum validation on any dev DB that has
-- already run it. This V5 instead DELETEs the existing Valle Nevado trails/lifts
-- and re-inserts a denser, coherent network, so it applies cleanly on top of an
-- already-migrated DB and is itself idempotent (re-running ends in the same state).
--
-- Geometry was hand-authored to match the real resort layout as shown on
-- OpenSkiMap (center ~ -70.2654 / -33.3438) and OpenSnowMap (center ~ -70.253 /
-- -33.335): the mountain descends from the high NW ridge (lng ~ -70.266..-70.256,
-- lat ~ -33.342..-33.346) down to the base village (lng ~ -70.248, lat ~ -33.356,
-- the V2 resort coordinate). Runs are multi-vertex fall lines that fan out from
-- the ridge and converge near the base; lifts climb roughly parallel to them.
-- Names keep Valle Nevado's dance-themed pistes (Tango, Vals, Milonga, Polka,
-- Fox Trot, Can Can…) plus the Sol/Prado sectors.
--
-- IMPORTANT: the "Sol" run includes the dev mock GPS point (-70.2512 -33.3478,
-- "Pista Sol") as an exact vertex, so the user's location dot lands ON a trail.
--
-- Conventions mirror V1–V4: search_path resorts, public; ids via gen_random_uuid();
-- foreign key resolved by slug; geom is EPSG:4326 LineString in "lng lat" order.
SET search_path TO resorts, public;

DO $$
DECLARE
    rid UUID;
BEGIN
    SELECT id INTO rid FROM resorts WHERE slug = 'valle-nevado';
    IF rid IS NULL THEN
        RAISE EXCEPTION 'Resort valle-nevado not found — run V2 seed first.';
    END IF;

    -- Clear the crude V3 Valle Nevado geometry so this migration is idempotent
    -- and supersedes it cleanly (CASCADE not needed; no FKs reference these rows).
    DELETE FROM trails WHERE resort_id = rid;
    DELETE FROM lifts  WHERE resort_id = rid;

    -- ---------- Trails ----------
    -- difficulty in {green, blue, black, red}; coordinates are "lng lat".
    INSERT INTO trails (id, resort_id, name, difficulty, geom) VALUES
    -- Sol sector (central) — Sol passes THROUGH the dev mock point.
    (gen_random_uuid(), rid, 'Sol', 'blue',
     ST_GeomFromText('LINESTRING(-70.2558 -33.3448, -70.2545 -33.3457, -70.2533 -33.3465, -70.2522 -33.3472, -70.2512 -33.3478, -70.2503 -33.3486, -70.2495 -33.3497, -70.2489 -33.3510, -70.2485 -33.3523)', 4326)),
    (gen_random_uuid(), rid, 'Sol I', 'blue',
     ST_GeomFromText('LINESTRING(-70.2575 -33.3450, -70.2562 -33.3458, -70.2549 -33.3466, -70.2538 -33.3473, -70.2528 -33.3480, -70.2519 -33.3489, -70.2512 -33.3500, -70.2506 -33.3512)', 4326)),
    (gen_random_uuid(), rid, 'Sol II', 'blue',
     ST_GeomFromText('LINESTRING(-70.2545 -33.3447, -70.2532 -33.3455, -70.2520 -33.3463, -70.2509 -33.3470, -70.2499 -33.3477, -70.2490 -33.3486, -70.2483 -33.3497, -70.2478 -33.3509)', 4326)),
    (gen_random_uuid(), rid, 'Luna', 'green',
     ST_GeomFromText('LINESTRING(-70.2535 -33.3452, -70.2522 -33.3461, -70.2510 -33.3470, -70.2499 -33.3479, -70.2489 -33.3490, -70.2481 -33.3502, -70.2476 -33.3515, -70.2474 -33.3528)', 4326)),
    (gen_random_uuid(), rid, 'Mirador', 'blue',
     ST_GeomFromText('LINESTRING(-70.2588 -33.3442, -70.2574 -33.3450, -70.2560 -33.3457, -70.2546 -33.3463, -70.2533 -33.3470, -70.2521 -33.3478, -70.2511 -33.3487)', 4326)),
    -- Prado sector (base, beginner/cruisers).
    (gen_random_uuid(), rid, 'Prado', 'green',
     ST_GeomFromText('LINESTRING(-70.2505 -33.3528, -70.2499 -33.3536, -70.2493 -33.3544, -70.2487 -33.3551, -70.2482 -33.3558)', 4326)),
    (gen_random_uuid(), rid, 'Polka', 'green',
     ST_GeomFromText('LINESTRING(-70.2518 -33.3525, -70.2510 -33.3534, -70.2502 -33.3543, -70.2494 -33.3551, -70.2487 -33.3559)', 4326)),
    (gen_random_uuid(), rid, 'Fox Trot', 'blue',
     ST_GeomFromText('LINESTRING(-70.2528 -33.3520, -70.2519 -33.3529, -70.2510 -33.3538, -70.2501 -33.3547, -70.2493 -33.3556)', 4326)),
    (gen_random_uuid(), rid, 'Vals', 'blue',
     ST_GeomFromText('LINESTRING(-70.2500 -33.3500, -70.2493 -33.3510, -70.2487 -33.3521, -70.2482 -33.3533, -70.2479 -33.3545)', 4326)),
    -- Retorno traverses (link sectors back toward the base).
    (gen_random_uuid(), rid, 'Retorno Alto', 'blue',
     ST_GeomFromText('LINESTRING(-70.2640 -33.3428, -70.2620 -33.3434, -70.2600 -33.3440, -70.2580 -33.3447, -70.2562 -33.3453)', 4326)),
    (gen_random_uuid(), rid, 'Retorno Medio', 'blue',
     ST_GeomFromText('LINESTRING(-70.2600 -33.3445, -70.2582 -33.3451, -70.2564 -33.3458, -70.2547 -33.3465, -70.2531 -33.3472)', 4326)),
    (gen_random_uuid(), rid, 'Retorno Bajo', 'green',
     ST_GeomFromText('LINESTRING(-70.2530 -33.3478, -70.2518 -33.3485, -70.2506 -33.3493, -70.2495 -33.3502, -70.2486 -33.3513, -70.2480 -33.3526)', 4326)),
    -- Upper steep sector (top ridge, fall lines toward the Sol top).
    (gen_random_uuid(), rid, 'Can Can', 'blue',
     ST_GeomFromText('LINESTRING(-70.2600 -33.3438, -70.2586 -33.3446, -70.2572 -33.3454, -70.2558 -33.3462, -70.2545 -33.3470)', 4326)),
    (gen_random_uuid(), rid, 'Rock & Roll', 'black',
     ST_GeomFromText('LINESTRING(-70.2590 -33.3448, -70.2578 -33.3456, -70.2566 -33.3464, -70.2554 -33.3472, -70.2543 -33.3481)', 4326)),
    (gen_random_uuid(), rid, 'Tango I', 'black',
     ST_GeomFromText('LINESTRING(-70.2625 -33.3435, -70.2612 -33.3443, -70.2599 -33.3451, -70.2586 -33.3460, -70.2574 -33.3469)', 4326)),
    (gen_random_uuid(), rid, 'Tango II', 'black',
     ST_GeomFromText('LINESTRING(-70.2618 -33.3438, -70.2605 -33.3446, -70.2592 -33.3454, -70.2580 -33.3463, -70.2568 -33.3472)', 4326)),
    (gen_random_uuid(), rid, 'Eclipse', 'black',
     ST_GeomFromText('LINESTRING(-70.2648 -33.3422, -70.2634 -33.3430, -70.2620 -33.3438, -70.2606 -33.3447, -70.2593 -33.3456, -70.2581 -33.3465)', 4326)),
    (gen_random_uuid(), rid, 'Milonga', 'red',
     ST_GeomFromText('LINESTRING(-70.2635 -33.3430, -70.2622 -33.3438, -70.2609 -33.3447, -70.2597 -33.3456, -70.2585 -33.3466)', 4326)),
    (gen_random_uuid(), rid, 'Momia', 'red',
     ST_GeomFromText('LINESTRING(-70.2658 -33.3418, -70.2645 -33.3426, -70.2632 -33.3435, -70.2620 -33.3444, -70.2609 -33.3454)', 4326));

    -- ---------- Lifts ----------
    -- Climb from the base up the mountain, roughly parallel to the runs.
    INSERT INTO lifts (id, resort_id, name, geom) VALUES
    -- Andes Express: main high-speed quad, base village up to the Sol top, passing
    -- close to the dev mock point (serves the Sol sector).
    (gen_random_uuid(), rid, 'Andes Express',
     ST_GeomFromText('LINESTRING(-70.2484 -33.3540, -70.2497 -33.3512, -70.2510 -33.3484, -70.2524 -33.3464, -70.2540 -33.3452, -70.2556 -33.3446)', 4326)),
    (gen_random_uuid(), rid, 'Gondola Valle',
     ST_GeomFromText('LINESTRING(-70.2480 -33.3556, -70.2495 -33.3530, -70.2510 -33.3505, -70.2525 -33.3482, -70.2540 -33.3462)', 4326)),
    (gen_random_uuid(), rid, 'Telecabina Tres Puntas',
     ST_GeomFromText('LINESTRING(-70.2540 -33.3460, -70.2565 -33.3450, -70.2590 -33.3440, -70.2615 -33.3432, -70.2642 -33.3425)', 4326)),
    (gen_random_uuid(), rid, 'Telesilla Prado',
     ST_GeomFromText('LINESTRING(-70.2486 -33.3556, -70.2492 -33.3540, -70.2498 -33.3526)', 4326)),
    (gen_random_uuid(), rid, 'Magic Carpet Prado',
     ST_GeomFromText('LINESTRING(-70.2484 -33.3558, -70.2488 -33.3549)', 4326)),
    (gen_random_uuid(), rid, 'Telesilla Sol',
     ST_GeomFromText('LINESTRING(-70.2496 -33.3500, -70.2512 -33.3480, -70.2528 -33.3462)', 4326)),
    (gen_random_uuid(), rid, 'Telesilla Luna',
     ST_GeomFromText('LINESTRING(-70.2476 -33.3526, -70.2486 -33.3505, -70.2498 -33.3482, -70.2512 -33.3464)', 4326)),
    (gen_random_uuid(), rid, 'Telesilla Can Can',
     ST_GeomFromText('LINESTRING(-70.2545 -33.3470, -70.2560 -33.3458, -70.2576 -33.3448, -70.2592 -33.3440)', 4326)),
    (gen_random_uuid(), rid, 'Telesilla Eclipse',
     ST_GeomFromText('LINESTRING(-70.2581 -33.3465, -70.2600 -33.3452, -70.2620 -33.3440, -70.2640 -33.3428, -70.2650 -33.3420)', 4326)),
    (gen_random_uuid(), rid, 'Teleski Momia',
     ST_GeomFromText('LINESTRING(-70.2609 -33.3454, -70.2625 -33.3442, -70.2642 -33.3430, -70.2658 -33.3418)', 4326));
END $$;
