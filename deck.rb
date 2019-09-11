require 'squib'
require 'yaml'
require 'game_icons'

Version=1
Copywright = "version: v#{Version}"

def yaml2dataframe(yamldata)
  resultCards = Squib::DataFrame.new

  # Get keys :
  card_keys = yamldata[0].keys
  card_keys.each do |k|
    resultCards[k] = yamldata.map { |e| e[k]}
  end
  return resultCards
end

def cutmark(top, left, right, bottom, size)
  line x1: left, y1: top, x2: left+size, y2: top, stroke_width: 1, cap: :round, stroke_color: 'white'
  line x1: left, y1: top, x2: left, y2: top+size, stroke_width: 1, cap: :round, stroke_color: 'white'

  line x1: right, y1: top, x2: right, y2: top+size, stroke_width: 1, cap: :round, stroke_color: 'white'
  line x1: right, y1: top, x2: right-size, y2: top, stroke_width: 1, cap: :round, stroke_color: 'white'

  line x1: left, y1: bottom, x2: left+size, y2: bottom, stroke_width: 1, cap: :round, stroke_color: 'white'
  line x1: left, y1: bottom, x2: left, y2: bottom-size, stroke_width: 1, cap: :round, stroke_color: 'white'

  line x1: right, y1: bottom, x2: right-size, y2: bottom, stroke_width: 1, cap: :round, stroke_color: 'white'
  line x1: right, y1: bottom, x2: right, y2: bottom-size, stroke_width: 1, cap: :round, stroke_color: 'white'
end

def save_home_made(file)
  cutmark 40, 40, 785, 1085, 10
  save format: :pdf, file: file, width: "29.7cm", height: "21cm", trim: 40, gap: 0
end

def debug_grid()
  grid width: 25,  height: 25,  stroke_color: '#659ae9', stroke_width: 1.5
  grid width: 100, height: 100, stroke_color: '#659ae9', stroke_width: 4
end

def set_background()
    background color: 'black'
end

def make_cards(description, output_file)
  Squib::Deck.new(cards: Cards.size, layout: 'layout-cards.yml') do
    background color: 'white'
    rect layout: 'cut' # cut line as defined by TheGameCrafter
    rect layout: 'safe', stroke_color: Cards2.cardcolor # safe zone as defined by TheGameCrafter
    rect layout: 'HeaderFlatBottom', fill_color: Cards2.cardcolor
    rect layout: 'HeaderRound', fill_color: Cards2.cardcolor

    card_marker = ['CardA', 'CardB', 'CardC']
    0.upto(Cards.size-1) do |n|
      rect range: n, layout: card_marker[n % 3], fill_color: Cards2.textcolor, stroke_color: Cards2.textcolor
    end
    
    text str: Cards2.title, layout: 'Title', color: Cards.map { |e| e["textcolor"]}
    text str: Cards2.theme, layout: 'Theme'
    text str: description, layout: 'Description'
    # print 'color : %s', Cards2.textcolor
    # print 'converted : ', Cards.map { |e| e["textcolor"]}
    # if Cards2.textcolor == "dark_text"
    #   svg mask: '#000000', file: Cards2.icon, layout: 'icon'
    # else
      svg mask: Cards2.iconcolor, file: Cards2.icon, layout: 'icon'
    # end
    text str: Cards2.tags, layout: 'Tags', color: 'black'

    save_home_made output_file
  end
end


Cards = YAML.load_file('data/cards.yml')
Cards2 = yaml2dataframe(Cards)

make_cards(Cards2.description_fr, "cards_fr.pdf")
# make_cards(Cards2.description_en, "cards_en.pdf")

# levels
LevelCards = YAML.load_file('data/levels.yml')
LevelCards2 = yaml2dataframe(LevelCards)

# Squib::Deck.new(cards: LevelCards.size, layout: 'layout-cards.yml') do
#   background color: 'white'
#   rect layout: 'cut' # cut line as defined by TheGameCrafter
#   rect layout: 'safe', stroke_color: "black"
#   rect layout: 'HeaderFlatBottom', fill_color: "black"
#   rect layout: 'HeaderRound', fill_color: "black", height: 250

#   text str: LevelCards2.title, layout: 'LTitle', color: "white"
#   png file: LevelCards2.icon, x: 150, y: 340, width: 540, height: 690

#   save_home_made "levels.pdf"
# end

# rules
def make_rules_cards(description, output_file)
  Squib::Deck.new(cards: 1, layout: 'layout-cards.yml') do
    background color: 'white'
    rect layout: 'cut' # cut line as defined by TheGameCrafter
    rect layout: 'safe' # safe zone as defined by TheGameCrafter
    text str: RuleCards['title'], layout: 'LTitle', height: 120, color: 'black', font_size: 30
    text str: description, layout: 'Description', justify: true, y: 230, height: 800, font_size: 28, align: 'left'

    save_home_made output_file
  end
end

RuleCards = YAML.load_file('data/rules.yml')

# make_rules_cards(RuleCards['description_fr'], "rules_fr.pdf")
# make_rules_cards(RuleCards['description_en'], "rules_en.pdf")

