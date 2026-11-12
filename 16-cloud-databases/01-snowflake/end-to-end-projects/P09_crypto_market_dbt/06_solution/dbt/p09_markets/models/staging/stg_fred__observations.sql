-- One row per series and date with a value. FRED marks holidays with an empty value; those rows are dropped.
-- A later download can revise history, so the latest load wins; the file name (fetch time) breaks ties within one COPY.
select
    series_id,
    try_to_date(observation_date)            as observation_date,
    try_to_decimal(value, 38, 6)             as value,
    loaded_at
from {{ source('raw', 'fred_observations_raw') }}
where try_to_decimal(value, 38, 6) is not null
qualify row_number() over (partition by series_id, observation_date order by loaded_at desc, src_file desc) = 1
