#NoEnv
#SingleInstance Force
; Event mode + KeyDelay is essential for League to register keys
SendMode Event 
SetKeyDelay, 0, 15

; --- ENORMOUS LIST OF SWEETS ---
sweetListText =
( LTrim Join,
Apple Pie,Baklava,Banana Split,Bear Claw,Belgian Waffle,Biscotti,Black Forest Cake,Blueberry Muffin,Bonbon,Brownie,Bubblegum,Butterfinger
Butterscotch,Cake Pop,Cannoli,Caramel Apple,Caramel Chews,Carrot Cake,Cheesecake,Cherry Pie,Chocolate Chip Cookie,Chocolate Eclair
Chocolate Fondue,Chocolate Mousse,Chocolate Truffle,Churro,Cinnamon Roll,Coconut Macaroon,Cotton Candy,Creme Brulee,Croissant,Cupcake
Custard Tart,Danish Pastry,Dark Chocolate,Donut,Dulce de Leche,Ferrero Rocher,Fruit Cake,Fudge,Funnel Cake,Gelato,Gingerbread
Glazed Donut,Gummy Bears,Gummy Worms,Hard Candy,Hershey's Kiss,Honey Bun,Hot Fudge Sundae,Ice Cream Sandwich,Jelly Bean,Jelly Donut
Jolly Rancher,Key Lime Pie,Kinder Bueno,KitKat,Laffy Taffy,Lemon Bar,Lemon Meringue Pie,Licorice,Lindt Truffle,Lollipop,Macaron
Malted Milk Ball,Maple Syrup,Marshmallow,Marzipan,Meringue,Milk Duds,Milkshake,Milky Way,Mochi,Molten Lava Cake,Moon Pie,Mousse
Nerds,Nougat,Oreo,Panna Cotta,Parfait,Pavlova,Peach Cobbler,Peanut Brittle,Peanut Butter Cup,Pecan Pie,Peppermint Bark,Pez
Pop Tart,Popsicle,Pound Cake,Praline,Pudding,Pumpkin Pie,Red Velvet Cake,Reese's Pieces,Rice Krispie Treat,Rock Candy,Rocky Road
Root Beer Float,Roly Poly,Salted Caramel,Scone,Shortbread,Skittles,Smarties,S'more,Snickers,Snow Cone,Sorbet,Souffle,Sour Patch Kids
Sponge Cake,Starburst,Sticky Toffee Pudding,Strawberry Shortcake,Strudel,Sugar Cookie,Sundae,Swedish Fish,Swiss Roll,Taffy,Tiramisu
Toasted Marshmallow,Toffee,Tootsie Roll,Tres Leches Cake,Trifle,Turkish Delight,Twinkie,Twix,Vanilla Wafer,Waffle,Whoopie Pie,Zebra Cake
)
sweets := StrSplit(sweetListText, ",")

; Variable to ensure we only replace text when Chat is open
inChat := false

Loop
{
    ; 1. Wait here until Chat is actually open
    if (!inChat)
    {
        Sleep, 50
        Continue
    }

    ; 2. Capture input 
    Input, typedWord, V, {Space}{Enter}{Backspace}{Esc}
    
    endKey := ErrorLevel

    ; 3. If user hit ESC, they closed chat. Stop immediately.
    if InStr(endKey, "Esc")
    {
        inChat := false
        ToolTip
        Continue
    }

    ; 4. If user hit ENTER, they sent the message. 
    ; We still replace the last word, then turn off chat mode.
    if InStr(endKey, "Enter")
    {
        GoSub, ReplaceWord
        inChat := false
        ToolTip
        Continue
    }

    ; 5. Handle Backspace (ignore it so we don't glitch)
    if InStr(endKey, "Backspace")
        Continue

    ; 6. Handle Space (The main trigger)
    if InStr(endKey, "Space")
    {
        GoSub, ReplaceWord
    }
}

ReplaceWord:
    if (typedWord != "")
    {
        Random, idx, 1, % sweets.MaxIndex()
        sweet := sweets[idx]

        ; A. Delete the typed word manually
        ; Using SendEvent + KeyDelay allows League to register the backspaces
        totalBackspaces := StrLen(typedWord) + 1
        Loop % totalBackspaces
        {
            Send, {BS}
        }

        ; B. Type the sweet using {Text} mode
        ; Safest way to type in games without triggering abilities
        Send, {Text}%sweet%

        ; C. Restore the space or enter key
        if InStr(endKey, "Space")
            Send, {Space}
        else if InStr(endKey, "Enter")
            Send, {Enter}
    }
return

; --- CHAT DETECTION TRIGGERS ---

; Triggers on Enter OR Shift+Enter (All Chat)
~Enter::
~+Enter::
    inChat := true
    ToolTip, [CHAT DETECTED] Sweets Ready
return

; Triggers on Esc (Cancel Chat)
~Esc::
    inChat := false
    Input ; Cancel the current input
    ToolTip
return

; Safety Kill Switch (Press F8 if it gets stuck)
F8::ExitApp