import requests
from bs4 import BeautifulSoup
import os
import re
import argparse
from concurrent.futures import ThreadPoolExecutor

# URL of the TLC trip record data page
URL = "https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page"

# Directory to save downloaded files
DOWNLOAD_DIR = r".\tlc_trip"
os.makedirs(DOWNLOAD_DIR, exist_ok=True)

def fetch_parquet_links():
    """Fetches all Parquet file links from the NYC TLC page."""
    response = requests.get(URL)
    soup = BeautifulSoup(response.content, 'html.parser')
    
    return [a['href'] for a in soup.find_all('a', href=True) if a['href'].endswith('.parquet')]

def filter_links(parquet_links, taxi, year, month=None):
    """Filters the links based on the provided year and optional month."""
    filtered_links = []
    date_pattern = re.compile(r"(\d{4})-(\d{2})")  # Matches "YYYY-MM"

    for link in parquet_links:
        taxi_match = re.search(taxi, link)
        date_match = date_pattern.search(link)
        if date_match and taxi_match:
            file_year, file_month = date_match.groups()
            if file_year == year and (month is None or file_month == month):
                filtered_links.append(link)
    
    return filtered_links

def download_file(link):
    """Downloads a single file from a given link."""
    filename = os.path.join(DOWNLOAD_DIR, os.path.basename(link))
    print(f"Downloading {filename} ...")
    
    with requests.get(link, stream=True) as r:
        r.raise_for_status()
        with open(filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)

    print(f"Downloaded {filename}.")

def main(taxi="green", year=2022, month=None):
    """Main function to fetch and download the required Parquet files."""
    parquet_links = fetch_parquet_links()
    filtered_links = filter_links(parquet_links, taxi, year, month)
    
    if not filtered_links:
        print(f"No files found for year {year}" + (f" and month {month}" if month else ""))
        return
    
    print(f"Found {len(filtered_links)} file(s) to download.")
    
    # Use ThreadPoolExecutor to download files in parallel
    with ThreadPoolExecutor(max_workers=5) as executor:
        executor.map(download_file, filtered_links)

    print("All selected files downloaded successfully!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Download NYC TLC trip record data for a specific year and month.")
    parser.add_argument("--taxi", help="taxi type")
    parser.add_argument("--year", help="Year in YYYY format")
    parser.add_argument("--month", help="Month in MM format (optional)")

    args = parser.parse_args()
    main(args.taxi, args.year, args.month)
