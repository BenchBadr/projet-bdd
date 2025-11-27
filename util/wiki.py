import requests
import re
from random import sample, randrange

def get_wiki(sci_name):
    url = f"https://fr.wikipedia.org/w/api.php?action=query&prop=extracts&titles={sci_name.replace(' ', '_')}&format=json&redirects=1&explaintext=1"
    headers = {
    "User-Agent": "YourAppName/1.0 benchekrounm@edu.univ-eiffel.fr)"
    }
    res = requests.get(url, headers=headers).json()['query']['pages']
    page = next(iter(res))
    wiki = res[page]['extract']#[0]['slots']['main']['*']


    img_url = f"https://fr.wikipedia.org/w/api.php?action=query&titles={sci_name.replace(' ', '_')}&prop=images&format=json&redirects=1"
    img_res = requests.get(img_url, headers=headers).json()
    pages = img_res.get('query', {}).get('pages', {})
    images = []
    for page_id in pages:
        imgs = pages[page_id].get('images', [])
        for img in imgs:
            title = img.get('title', '')
            if title.lower().endswith(('.jpg', '.jpeg', '.png')):
                filename = title.replace('Fichier:', '').replace('File:', '').replace(' ', '_')
                images.append(f"https://commons.wikimedia.org/wiki/Special:FilePath/{filename}")
                if randrange(10) == 1:
                    break
                
                images.append(url)

    return wiki, images





def get_obs(sci_name):
    wiki, imgs = get_wiki(sci_name)
    map = wiki.split('==')
    data = {}
    for i in range(1, min(15, len(map)), 2):
        data[map[i].replace('=','').strip()] = map[i+1]

    # clean data
    clean_data = {}

    ## description

    print(data.keys())

    for key in data.keys():
        if "description" in key.lower():
            taille = re.findall(r"(\d+(?:[\.,]\d+)?)\s*cm", data[key])
            if taille:
                taille = re.sub(r"[^\d.,]", "", taille[0])
                clean_data['taille'] = taille

            lines = [line for line in data[key].split('\n') if line.strip()]
            clean_data['desc'] = sample(lines, min(len(lines), 10))
        
        if "habitat" in key.lower():
            lines = [line for line in data[key].split('\n') if line.strip()]
            clean_data['habitat'] = sample(lines, min(len(lines), 10))

        if "reproduction" in key.lower():
            lines = [line for line in data[key].split('\n') if line.strip()]
            clean_data['reproduction'] = sample(lines, min(len(lines), 10))

            

    clean_data['imgs'] = imgs

    return clean_data



print(get_obs("Poecile montanus"))