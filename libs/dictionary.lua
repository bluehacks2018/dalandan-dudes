Class = require "libs.hump.class"

local Dictionary = Class{}


function Dictionary:init()
  -- table of words in different languages/dialects
  self.num=0
  self.words = { 
    { eng = 'Welcome', tag = 'Maligayang Pagdating', ceb = 'Maayong Pag-abot', bic = 'Maogmang Pag-abot', hil = 'Dayon', ilo = 'Naragsak nga Isasanbay', kap = 'Malaus ko pu', pan = 'Galikayo', war = '' },
    { eng = 'How are you', tag = 'Kamusta ka', ceb = 'Unsa inyong kahimtang', bic = 'Kumusta ka', hil = 'Kamusta ka', ilo = 'Mag-an', kap = 'Komusta ka', pan = '', war = 'Kumusta ka'},
    { eng = 'Thank you', tag = 'Maraming salamat', ceb = 'Daghang salamat', bic = 'Dios mabalos', hil = 'Salamat', ilo = 'Agyamanak', kap = 'Salamat', pan = 'Salamat', war = 'Damo nga Salamat' },
    { eng = 'yes', tag = 'oo', ceb = 'oo', bic = 'iyo', hil = 'hu-o', ilo = 'wen', kap = 'wa', pan = 'on', war = 'oo' },
    { eng = 'no', tag = 'hindi', ceb = 'dili', bic = 'dai', hil = 'hindi', ilo = 'saan', kap = 'ali', pan = 'andi', war = 'diri' },
    { eng = 'I\'m sorry', tag = 'pasensya na', ceb = 'pasaylo-a ko', bic = 'patawarun mo ako', hil = 'pasensyaha lang ako', ilo = 'agpakawanak', kap = 'pasensya na ka', pan = '', war = 'paraylo-a ako' },
    { eng = 'help me', tag = 'tulungan mo ako', ceb = 'tabangi ko', bic = 'tabange ako', hil = 'bulig', ilo = 'sumalakankayo', kap = 'sopan mu ku', pan = 'tulungan yo ak', war = 'uligi ako' },
    { eng = 'Goodbye', tag = 'Paalam', ceb = 'Ari na ko', bic = 'Paaram', hil = 'Asta sa liwat', ilo = 'Agpakadaakon', kap = '', pan = '', war = 'Malakat na ako' },
    { eng = 'my name is', tag = 'ang pangalan ko ay', ceb = 'ang akong ngalan', bic = 'an ngaran ko', hil = 'ang ngalan ko', ilo = 'ti naganko ket', kap = 'ning lagyu ku ay', pan = '', war = 'iton akon ngaran' },
    { eng = 'Good Morning', tag = 'Magandang Umaga', ceb = 'Maayong Buntag', bic = 'Marhay na Aga', hil = 'Ma-ayong Aga', ilo = 'Naimbag a Bigat', kap = 'Mayap a Abak', pan = 'Maabig ya Kaboasan', war = 'Maupay nga Aga' },
    { eng = 'Good Afternoon', tag = 'Magandang Hapon', ceb = 'Maayong Hapon', bic = 'Marhay na Hapon', hil = 'Ma-ayong Hapon', ilo = 'Naimbag a Malem', kap = 'Mayap a Ugtu', pan = 'Maabig ya Ngarem', war = 'Maupay nga Kulop' },
    { eng = 'Good Evening', tag = 'Magandang Gabi', ceb = 'Maayong Gabi-i', bic = 'Marhay na Banggi', hil = 'Ma-ayong Gab-i', ilo = 'Naimbag a Sardam', kap = 'Mayap a Bengi', pan = 'Maibag ya Labi', war = 'Maupay nga Gab-i' },
    { eng = 'You\'re Welcome', tag = 'Walang anuman', ceb = 'Walay sapayan', bic = 'Warang uno man', hil = 'Wala sang anuman', ilo = 'Awan ania man', kap = 'Walang anuman', pan = '', war = 'Waray sapayan' },
    { eng = 'right', tag = 'kanan', ceb = 'tuo', bic = 'too', hil = 'tuo', ilo = 'kannawan', kap = 'wasan', pan = 'kawanan', war = ''  },
    { eng = 'left', tag = 'kaliwa', ceb = 'wala', bic = 'wala', hil = 'wala', ilo = 'kannigid', kap = 'kayli', pan = 'kawigi', war = '' },
    { eng = 'How much', tag = 'Magkano', ceb = '', bic = '', hil = '', ilo = '', kap = '', pan = '', war = '' },
    { eng = 'What is this', tag = 'Ano ito', ceb = '', bic = '', hil = '', ilo = '', kap = '', pan = 'Anto ya', war = '' },
    { eng = 'What is that', tag = 'Ano iyan', ceb = '', bic = '', hil = '', ilo = '', kap = '', pan = 'Anto man', war = '' }
  }
  
end

-- checks if given /word/ in /lang/ language = /input/ 
function Dictionary:check(word, input, lang)
  for i, v in ipairs(self.words) do 
    --print(v[lang],word,v['eng'],input)
    if(string.lower(v[lang])==string.lower(word) and string.lower(v["eng"])==string.lower(input)) then
      return true
    end
  end
  return false

end

-- returns a word from the dictionary in /lang/ language
function Dictionary:getWord(num, lang)
    --num = math.random(1, 3)
    --print(self.words[1]["tag"])
    local word = self.words[num][lang]
    return string.lower(word)
end

function Dictionary:getWords(l1, l2, num)
  self.num= num
  return self.words[self.num][l1],self.words[self.num][l2]
end

return Dictionary