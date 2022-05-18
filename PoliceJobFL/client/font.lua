local fontId

Citizen.CreateThread(function()
    RegisterFontFile('firesans')
    fontId = RegisterFontId('Fire Sans')
    print(string.format('[flap_police_job] setting up font Fire Sans as ID: %s',fontId))
end)

function getFontId()
    return fontId
end