from time import time
import argparse
import os
import pandas as pd
from sqlalchemy import create_engine

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table
    url = params.url  # CSV file path or URL
    
    # Download or access the CSV file
    csv_name = './data/yellow_tripdata_2021-01_output.csv'
    
    if url.startswith('http'):
        # Use wget or requests to download if it's a URL
        os.system(f'wget {url} -O {csv_name}')
    else:
        # If it's a local file, we just use the file directly
        csv_name = url

    # Create a connection to the Postgres database
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # Read the CSV file in chunks using an iterator
    df_iterator = pd.read_csv(csv_name, iterator=True, chunksize=100000)

    # Process the first chunk to initialize the table
    df = next(df_iterator)
    
    # Convert date columns to datetime format
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    # Write the table schema (headers only) to the database
    df.head(0).to_sql(table_name, con=engine, if_exists='replace')

    # Insert the first chunk
    df.to_sql(table_name, con=engine, if_exists='append')

    # Process remaining chunks in a loop
    while True:
        try:
            t_start = time()
            
            # Fetch next chunk of data
            df = next(df_iterator)

            # Convert date columns to datetime format
            df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
            df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

            # Insert chunk into the database
            df.to_sql(table_name, con=engine, if_exists='append')
            
            t_end = time()

            print(f'Inserted another chunk, it took {t_end - t_start:.3f} seconds')

        except StopIteration:
            # No more data to process, break the loop
            print("All chunks have been processed.")
            break

if __name__ == '__main__':
    # Argument parser to pass user input via the command line
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--user', help='Username for PostgreSQL')
    parser.add_argument('--password', help='Password for PostgreSQL')
    parser.add_argument('--host', help='Host for PostgreSQL')
    parser.add_argument('--port', help='Port for PostgreSQL')
    parser.add_argument('--db', help='Database name for PostgreSQL')
    parser.add_argument('--table', help='Table name where the data will be ingested')
    parser.add_argument('--url', help='URL or file path of the CSV file')

    args = parser.parse_args()
    
    main(args)
