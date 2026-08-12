#!/usr/bin/env python3

# Guy Bruneau, guybruneau at outlook.com
# Date: 10 Aug 2026
# Version: 0.5

# Replace [ELK Name] with your servername or IP address
# Update the: "model": "gemma4:e4b" if it isn't what you are using
# Best to run this directly on the DShield-SIEM locally

import json
import requests
from bs4 import BeautifulSoup

# --- 1. Configuration of DShield-SIEM ---
ES_URL = "https://[ELK Name]:9200/cowrie-*/_search"
ES_AUTH = ("elastic", "student")
OLLAMA_URL = "http://gemma:11434/api/generate"

# --- 2. Fonction to get the text from the URL ---
def fetch_web_content(url):
    try:
        headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        # Cleanup HTML to keep the useful text utile
        soup = BeautifulSoup(response.text, 'html.parser')
        for script_or_style in soup(["script", "style", "header", "footer", "nav"]):
            script_or_style.decompose()
            
        return soup.get_text(separator=' ', strip=True)[:4000] # Limite pour éviter de surcharger le contexte
    except Exception as e:
        return f"Error while trying to get the {url} : {str(e)}"

# --- 3. Requête Elasticsearch ---
query = {
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "@timestamp": {
              "gte": "now-30d",
              "lte": "now"
            }
          }
        },
        {
          "exists": {
            "field": "file.name"
          }
        }
      ]
    }
  },
  "aggs": {
    "top_hash": {
      "terms": {
        "field": "related.hash",
        "size": 10
      }
    }
  }
}


try:
    response = requests.post(ES_URL, json=query, auth=ES_AUTH)
    es_data = response.json()
    buckets = es_data["aggregations"]["top_hash"]["buckets"]
except Exception as e:
    print(f"Error ES : {e}")
    buckets = []

# Extraction des IP
stats_summary = ""
for bucket in buckets:
    stats_summary += f"- IP: {bucket['key']}, Number of Events: {bucket['doc_count']}\n"

# --- 4. Collecte des données Internet ---
# Remplacez ces URL par les sites de threat intelligence ou de référence à comparer
#url_reference_1 = "https://example-threat-intel-site.com"
#url_reference_2 = "https://example-security-blog.com"
url_reference_1 = "https://www.virustotal.com/gui/file/related.hash"
url_reference_2 = "https://cybergordon.com/request/related.hash"

content_site_1 = fetch_web_content(url_reference_1)
content_site_2 = fetch_web_content(url_reference_2)

# --- 5. Construction du prompt de comparaison ---
prompt = f"""
As a cybersecurity analyst, analyze the following hashes (files) uploaded by actors/bots stored in the Cowrie sensors listed in Kibana.
In the content_site_1 and content_site_2, replace the related.hash with the hashes from the Elasticsearch query.

Here are hashes that have been downloaded to the sensor after the system was compromised by actors/bots (Top 10 hashes over the past 30 days) :
{stats_summary}

Here is the information retrieved from {url_reference_1}:
\"\"\"
{content_site_1}
\"\"\"
Here is the information retrieved from {url_reference_2}:
\"\"\"
{content_site_2}
\"\"\"

Instructions :
1. Determine if we should be concerned with the volumes or suspicious volumes match indicators of compromise (IoC) or tactics mentioned on the two external websites.
2. Provide a concise comparative analysis and recommendations for action to prevent actors/bots to successfully compromise the sensor.
3. Identify what type of malware family (Popular threat label) the top 3 files are associated with.
4. Highlight potential issues with the top 3 inbound hashes (files) downloaded by actors/bots logged in the sensor and which sites have the most information about this activity.
"""

# --- 6. Send to Ollama ---
ollama_payload = {
    "model": "gemma4:e4b",  # Use your own model (ex: gemma:7b ou gemma2)
    "prompt": prompt,
    "stream": False
}

print("Sending the combined data to Ollama for analysis...")
ollama_response = requests.post(OLLAMA_URL, json=ollama_payload)
result = ollama_response.json()

print("\nComparative analysis from Gemma :\n", result["response"])

