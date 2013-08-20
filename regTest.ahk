#NoEnv

keys:="123*321"
;~ keys:=eval(keys)
;~ MsgBox, % keys
FoundPos:=RegExMatch(keys,"O)(\d+)\*(\d+)",match)
MsgBox, % match.Pos() "`n" match.Len() "`n" match.Value() "`n" match.Count() 