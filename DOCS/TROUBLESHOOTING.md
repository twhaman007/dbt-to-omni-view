# Troubleshooting & Fixes — dbt + Snowflake

This document records the problems encountered while connecting and deploying dbt models to Snowflake, and the exact fixes applied.

**Summary**
- Environment: Windows, Python 3.11 (virtualenv `.venv`), dbt 1.11.11, dbt-snowflake 1.11.5
- Snowflake account: `wjulylu-ux60638` (used for testing)
- Project: `my_dbt_project` (repo: https://github.com/twhaman007/dbt-to-omni-view)

---

## Problems & Solutions

1) dbt not found / wrong Python version
- Problem: `dbt --version` failed; Python 3.14 installed and the dbt packages installed to a different user path produced runtime errors.
- Fix: Create a Python 3.11 virtual environment and install `dbt-snowflake` there.
  - Commands used:

```powershell
py -3.11 -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install dbt-snowflake
```

2) Profiles mismatch (project `profile` vs `profiles.yml`)
- Problem: `dbt_project.yml` referred to `profile: my_dbt_profile` while the user's `%USERPROFILE%\.dbt\profiles.yml` had a different profile name.
- Fix: Aligned names by updating `C:\Users\<you>\.dbt\profiles.yml` to include `my_dbt_profile` and added `dev`, `prod`, and `main` outputs. Also provided `setup_snowflake_profile.ps1` sample.

3) Duplicate source declarations
- Problem: dbt complained about two sources named the same (e.g. `ecommerce_ORDER_ITEMS`) because sources were declared both in `models/schema.yml` and `models/sources.yml`.
- Fix: Removed the duplicate source block from `models/schema.yml` and consolidated all source definitions in `models/sources.yml`.

4) Schema/column name mismatches
- Problem: Model SQL referenced columns that did not exist (`quantity`, `total_amount`, `customer_id`), which produced SQL compilation errors from Snowflake.
- Investigation: Queried `INFORMATION_SCHEMA.COLUMNS` to list actual column names for tables: `ORDERS`, `ORDER_ITEMS`, `PRODUCTS`, `USERS`.
- Fixes applied:
  - Updated models to use real columns (`ORDER_ITEMS.SALE_PRICE`, `ORDERS.CREATED_AT`, `ORDER_ITEMS.USER_ID`, `PRODUCTS.ID`, `PRODUCTS.NAME`, etc.).
  - Example: `top_products.sql` changed to join `order_items` -> `products` and aggregate `sale_price`.

5) Model self-reference error
- Problem: After a git pull, a file `models/top_products.sql` referenced the view `TOP_PRODUCTS` (same name), causing "View definition refers to view being defined".
- Fix: Rewrote `models/top_products.sql` to select from raw sources instead of referencing the view being created. Committed the fix.

6) Pulled files outside `models/` (not executed by dbt)
- Problem: `newlogic/sale_price.sql` was added in the repo but outside `models/`, so dbt didn't run it.
- Fix / Options:
  - Move `newlogic/sale_price.sql` into `models/`.
  - Or add `newlogic` to `model-paths` in `dbt_project.yml`:

```yaml
model-paths: ["models", "newlogic"]
```

7) Deprecated config warning
- Problem: `dbt_project.yml` used `data-paths` which is deprecated.
- Fix: Replace `data-paths` with `seed-paths` in `dbt_project.yml` (non-blocking warning).

---

## Commands used repeatedly (quick copy)

Activate virtualenv:
```powershell
cd C:\Users\aman9\Downloads\my-dbt-project
.\.venv\Scripts\Activate.ps1
```

Validate connection:
```powershell
dbt debug
```

Run models (default target `dev` or explicit `main`):
```powershell
dbt run
# or
dbt run --target main
```

Run a single model or selection:
```powershell
dbt run --select top_products
```

Push/pull workflow:
```powershell
# pull remote changes
git pull origin main
# run dbt to deploy latest
.\.venv\Scripts\Activate.ps1
dbt run --target main
# commit local fixes
git add .
git commit -m "Describe fix"
git push
```

---

## Files changed / added by fix
- `dbt_project.yml` — kept `profile: my_dbt_profile` (no change required)
- `%USERPROFILE%\.dbt\profiles.yml` — updated to `my_dbt_profile` with `dev`, `prod`, `main` outputs
- `.venv/` — Python 3.11 virtual environment (local)
- `setup_snowflake_profile.ps1` — helper to create sample `profiles.yml`
- `models/sources.yml` — canonical source declarations for `ecommerce` tables
- `models/*.sql` — updated model SQL to match Snowflake schema (sales_by_day, customer_lifetime_value, top_products, weekly_active_customers)
- `DOCS/TROUBLESHOOTING.md` — this document

---

## Recommendations
- Secure credentials: do not store real passwords in `profiles.yml` in source control. Use environment variables or keyring integrations.
- Add `newlogic/` to `model-paths` if you want those SQL files run by dbt.
- Fix the `data-paths` → `seed-paths` deprecation.
- Consider adding a `requirements.txt` or `pyproject.toml` to pin dbt versions for reproducibility.

---

If you'd like, I can:
- Move `newlogic/sale_price.sql` into `models/` and run `dbt run`.
- Update `dbt_project.yml` to include `newlogic` in `model-paths`.
- Remove sensitive credentials from `profiles.yml` and replace them with environment-variable references and README instructions.

