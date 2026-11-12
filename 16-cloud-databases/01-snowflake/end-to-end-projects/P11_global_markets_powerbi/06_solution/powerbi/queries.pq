// P11 Power Query (M) for the Power BI semantic model. One query per table; Import mode.
// Create two text parameters first: SnowflakeServer = "<account identifier>.snowflakecomputing.com",
// Warehouse = "P11_BI_WH". Sign in with Key Pair as P11_POWERBI_SVC (private key file p11_powerbi.p8).
// Implementation "2.0" is the ADBC driver; key-pair authentication always uses it.

// ---- Query: Mart (helper, disable load) ----
let
    Source = Snowflake.Databases(SnowflakeServer, Warehouse, [Role = "P11_BI_READER", Implementation = "2.0"]),
    Database = Source{[Name = "P11_MARKETS", Kind = "Database"]}[Data],
    Mart = Database{[Name = "MART", Kind = "Schema"]}[Data]
in
    Mart

// ---- Query: FACT_FOOD_PRICE ----
let
    Source = Mart{[Name = "FACT_FOOD_PRICE", Kind = "View"]}[Data],
    // Keep the model narrow: PRICE_KEY and UNIT are for SQL checks, not for visuals.
    Columns = Table.SelectColumns(Source, {"MONTH_START", "COUNTRY_ISO3", "MARKET_ID", "COMMODITY_ID", "PRICE_TYPE",
        "BASE_UNIT", "PRICE_LOCAL_PER_BASE", "PRICE_USD_PER_BASE", "PRICE_EUR_PER_BASE", "FX_SOURCE"}),
    Typed = Table.TransformColumnTypes(Columns, {{"MONTH_START", type date}, {"MARKET_ID", Int64.Type},
        {"COMMODITY_ID", Int64.Type}, {"PRICE_LOCAL_PER_BASE", type number}, {"PRICE_USD_PER_BASE", type number},
        {"PRICE_EUR_PER_BASE", type number}})
in
    Typed

// ---- Query: DIM_COUNTRY ----
let Source = Mart{[Name = "DIM_COUNTRY", Kind = "View"]}[Data] in Source

// ---- Query: DIM_COMMODITY ----
let Source = Mart{[Name = "DIM_COMMODITY", Kind = "View"]}[Data] in Source

// ---- Query: DIM_MARKET ----
let
    Source = Mart{[Name = "DIM_MARKET", Kind = "View"]}[Data],
    Typed = Table.TransformColumnTypes(Source, {{"LATITUDE", type number}, {"LONGITUDE", type number}})
in
    Typed

// ---- Query: DIM_MONTH ----
let
    Source = Mart{[Name = "DIM_MONTH", Kind = "View"]}[Data],
    Typed = Table.TransformColumnTypes(Source, {{"MONTH_START", type date}, {"YEAR", Int64.Type}, {"MONTH_NUMBER", Int64.Type}})
in
    Typed

// ---- Query: DIM_YEAR ----
let
    Source = Mart{[Name = "DIM_YEAR", Kind = "View"]}[Data],
    Typed = Table.TransformColumnTypes(Source, {{"YEAR", Int64.Type}})
in
    Typed

// ---- Query: FACT_COUNTRY_YEAR ----
let
    Source = Mart{[Name = "FACT_COUNTRY_YEAR", Kind = "View"]}[Data],
    Typed = Table.TransformColumnTypes(Source, {{"YEAR", Int64.Type}})
in
    Typed
