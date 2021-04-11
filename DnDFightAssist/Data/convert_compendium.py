import xml.etree.ElementTree as ET
import json
import re

def IsSpell(s):
  if not 'school' in spell:
    return False
  if s['name'].endswith('(Ritual Only)'):
    return False
  if s['name'].endswith('*'): # todo: merge as 'always prepared' spell
    return False
  if s['classes'] in ['Artificer Infusions', 'Fighter (Arcane Archer)']:
    return False
  return True

with open('DnDFightAssist/Resources/Conditions.json', 'r') as f:
  conditions = json.load(f)

def ParseSpell(node):
  spell = {}
  for element in node:
    if element.tag == 'ritual':
      spell['ritual'] = True if element.text == 'YES' else False
    elif element.tag == 'level':
      spell['level'] = int(element.text)
    elif element.tag == 'text':
      text = element.text if element.text else '' # handle empty fields for new lines in description

      for t in text.split('\n'):
        # move spell's source from description to separate field
        if 'source' in spell and t.strip():
          spell['source'].append(t.strip())
          continue
        prefix = 'Source:'
        if prefix in t:
          spell['source'] = [t[len(prefix):].strip()]
          continue

        if not 'description' in spell:
          spell['description'] = t
        else:
          spell['description'] += '\n' # multiline text description
          spell['description'] += t
    else:
      spell[element.tag] = element.text if element.text else ""

  # cut conditions description
  cut_index = len(spell['description'])
  for c in conditions:
    index = spell['description'].find(f'\n{c}:\n')
    if index != -1 and index < cut_index:
      cut_index = index
  spell['description'] = spell['description'][:cut_index]

  # resolve conditions from spell description
  for c in conditions:
    if c in spell['description'] or c.lower() in spell['description']:
      if not 'conditions' in spell:
        spell['conditions'] = []
      spell['conditions'].append(c)

  return spell

def ParseMonster(node):
  entryConversion = {
    'trait': 'traits',
    'action' : 'actions',
    'legendary': 'legendaries'
  }

  monster = {}
  for element in node:
    if element.tag in ['str', 'dex', 'con', 'int', 'wis', 'cha']:
      if not 'abilities' in monster:
        monster['abilities'] = {}
      monster['abilities'][element.tag.upper()] = int(element.text)
    elif element.tag == 'passive':
      monster['passivePerception'] = int(element.text)
    elif element.tag in ['trait', 'action', 'legendary']:
      entryName = entryConversion[element.tag]
      if not entryName in monster:
        monster[entryName] = []
      entry = {}
      for e in element:
        text = e.text if e.text else '' # handle empty fields for new lines in description
        if not e.tag in entry:
          entry[e.tag] = text
        else:
          entry[e.tag] += '\n' # multiline text description
          entry[e.tag] += text
      if not 'name' in entry:
        search = re.search(r'take (\d) legendary actions', entry['text'])
        if search:
          entry['name'] = f'Legendary Actions ({search.group(1)}/Turn)'
        elif 'Source:' in entry['text']:
          entry['name'] = 'Source'
          entry['text'] = entry['text'][len('Source:'):]
          pass
        else:
          raise Exception('Unknown trait in ' + monster['name'] + ' description: ' + entry['text'])

      # treat 'Source' traits as separate field
      if entry['name'] == 'Source':
        if not 'source' in monster:
          monster['source'] = []
        for s in entry['text'].split('\n'):
          monster['source'].append(s.strip())
      else:
        monster[entryName].append(entry)
    else:
      monster[element.tag] = element.text if element.text else ""

  # handle source in description
  if 'description' in monster and 'Source:' in monster['description']:
    if not 'source' in monster:
      monster['source'] = []
    index = monster['description'].find('Source:')
    monster['source'].append(monster['description'][index + len('Source:'):].strip())
    monster['description'] = monster['description'][:index].strip()

  # remove empty elements
  to_delete = []
  for k,v in monster.items():
    if v == '':
      to_delete.append(k)
  for k in to_delete:
    del monster[k]

  # cut conditions from actions description
  for v in entryConversion.values():
    if v in monster:
      for entry in monster[v]:
        cut_index = len(entry['text'])
        for c in conditions:
          index = entry['text'].find(f'\n{c}:\n')
          if index != -1:
            if not 'conditions' in entry:
              entry['conditions'] = []
            entry['conditions'].append(c)
            if index < cut_index:
              cut_index = index
        entry['text'] = entry['text'][:cut_index].strip()

  return monster

spells = []
monsters = []

tree = ET.parse('DnDFightAssist/Data/Compendium.xml')
for child in tree.getroot():
  if child.tag == 'spell':
    spell = ParseSpell(child)
    if IsSpell(spell):
      spells.append(spell)
  elif child.tag == 'monster':
    monsters.append(ParseMonster(child))

print(f'Total spells: {len(spells)}')
print(f'Total monsters: {len(monsters)}')

# todo: fix data
for m in monsters:
  if not 'cr' in m:
    m['cr'] = '0'
  if not 'hp' in m:
    print(m['name'])

with open('DnDFightAssist/Resources/Spells.json', 'w') as f:
  json.dump(spells, f, indent=2)
with open('DnDFightAssist/Resources/Monsters.json', 'w') as f:
  json.dump(monsters, f, indent=2)
