import xml.etree.ElementTree as ET
import json

def IsSpell(s):
  if not 'school' in spell:
    return False
  if s['name'].endswith('(Ritual Only)'):
    return False
  if s['name'].endswith('*'):
    return False
  if s['classes'] in ['Artificer Infusions', 'Fighter (Arcane Archer)']:
    return False
  return True

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
      monster[entryName].append(entry)
    else:
      monster[element.tag] = element.text if element.text else ""
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

for m in monsters:
  to_delete = []
  for k,v in m.items():
    if v == '':
      to_delete.append(k)
  for k in to_delete:
    del m[k]

  if not 'cr' in m:
    m['cr'] = '0' # todo: fix data
  if not 'hp' in m:
    print(m['name'])

with open('DnDFightAssist/Resources/Spells.json', 'w') as f:
  json.dump(spells, f, indent=2)
with open('DnDFightAssist/Resources/Monsters.json', 'w') as f:
  json.dump(monsters, f, indent=2)
