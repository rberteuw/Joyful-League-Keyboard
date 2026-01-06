#NoEnv
#SingleInstance Force
SendMode Input

; --- ENORMOUS LIST OF SWEETS ---
; We store this as text first, then split it into an array below.
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

; Convert the text block above into a proper array
sweets := StrSplit(sweetListText, ",")

; Variable to track if script is active
isPaused := false 

Loop
{
    ; 1. Check if we are paused
    if (isPaused)
    {
        Sleep, 100 
        Continue
    }

    ; 2. Capture a word
    Input, typedWord, V, {Space}{Enter}{Backspace}
    
    endKey := ErrorLevel

    ; 3. Check if Input was cancelled by F8
    if (endKey = "NewInput")
        Continue

    ; 4. Handle Backspace (Reset input if user deletes a char)
    if InStr(endKey, "Backspace")
        Continue

    ; 5. Replacement Logic
    if (typedWord != "")
    {
        Random, idx, 1, % sweets.MaxIndex()
        sweet := sweets[idx]

        ; Calculate backspaces (Word Length + 1 for the Space/Enter)
        totalBackspaces := StrLen(typedWord) + 1

        Loop % totalBackspaces
        {
            Send, {BS}
        }

        Send, %sweet%
        
        ; Restore the space or enter
        if InStr(endKey, "Space")
            Send, {Space}
        else if InStr(endKey, "Enter")
            Send, {Enter}
    }
}

; --- F8 Hotkey to Toggle ---
F8::
    isPaused := !isPaused

    if (isPaused)
    {
        Input 
        ToolTip, [PAUSED] Normal Typing
        SoundBeep, 500, 200
    }
    else
    {
        ToolTip, [ACTIVE] Sweets Mode
        SoundBeep, 1000, 200
    }

    SetTimer, RemoveToolTip, -1500
return

RemoveToolTip:
    ToolTip
return