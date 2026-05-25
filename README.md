# dbt + Snowflake Setup

This workspace contains a minimal dbt project and a Snowflake connection example.

## 1) Install dbt for Snowflake

On Windows, install dbt in a Python virtual environment or globally:

```powershell
python -m pip install --upgrade pip
python -m pip install dbt-snowflake
```

## 2) Create your dbt profile

dbt looks for `profiles.yml` in `%USERPROFILE%\.dbt\profiles.yml` by default.

Create this file with your Snowflake credentials:

```yaml
my_dbt_profile:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account>
      user: <your_user>
      password: <your_password>
      role: <your_role>
      database: <your_database>
      warehouse: <your_warehouse>
      schema: <your_schema>
      threads: 1
      client_session_keep_alive: false
      query_tag: dbt
```

Example Windows path:

```text
C:\Users\<your-windows-user>\.dbt\profiles.yml
```

## 3) Activate the virtual environment

Before running dbt, activate the project virtual environment:

```powershell
cd C:\Users\aman9\Downloads\my-dbt-project
.\.venv\Scripts\Activate.ps1
```

Then validate the connection:

```powershell
dbt debug
```

If `dbt debug` succeeds, dbt is connected to Snowflake.

## 4) Run the sample model

```powershell
dbt run
```

## 5) Notes

- Keep your Snowflake password secure. Use environment variables if you prefer not to store passwords directly in `profiles.yml`.
- If you want to use a different profile directory, set `DBT_PROFILES_DIR`.
- This project uses `profile: my_dbt_profile` as configured in `dbt_project.yml`.
- You can create a sample profile file with `setup_snowflake_profile.ps1`.
