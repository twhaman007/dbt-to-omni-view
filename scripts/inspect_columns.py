import snowflake.connector

ctx = snowflake.connector.connect(
    user='unibiccookiesss',
    password='cFG5mFaBZJek7pB',
    account='wjulylu-ux60638',
    warehouse='COMPUTE_WH',
    database='ECOMMERCE_LOOKER',
    schema='PUBLIC'
)
cur = ctx.cursor()
tables = ['ORDERS', 'ORDER_ITEMS', 'CUSTOMERS', 'PRODUCTS']
for table in tables:
    print('TABLE', table)
    cur.execute(
        f"select column_name from information_schema.columns where table_name = '{table}' order by ordinal_position"
    )
    for row in cur.fetchall():
        print('  ', row[0])
    print('---')
cur.close()
ctx.close()
