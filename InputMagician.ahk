#NoEnv
#SingleInstance force
SetKeyDelay, -1
;~ SendMode, play
SetFormat, Integer, hex
inputMagi.Add(".l",".lcomm`t" )
inputMagi.Add(".o",".org`t")
inputMagi.AddReg("(\d+)\*(\d+)","$1*$2","",1)
inputMagi.AddReg("(x|y)=&?([\w\d]+)","ldb`text,$2@H`nldb`t$1l,$2@L","",0)
inputMagi.AddReg("ba=\[(x|y)(\+)?\]?","ld`ta,[$1]$2`nld`tb,00h","",0)
inputMagi.AddReg("([\w\d]+)=(.+)","ldb`t`text,$1`nld`t`t[x],$2","",0)
inputMagi.AddReg("(1|0)(1|0)(1|0)(1|0)(1|0)","$x '000$1$2$3$4$5","",1)
inputMagi.Start()
Return


/* example
	
	inputMagi.Add("$","在吗")
	inputMagi.Add("?","吃了吗")
	inputMagi.Add("~","呵呵")
	inputMagi.Add("^","哈哈")
	inputMagi.Add("$?","在吗，吃了吗")
	inputMagi.Add("$^","在吗， 哈哈")
	inputMagi.AddReg("(\d+)\*(\d+)","$1*$2","",1)
	inputMagi.Start()
	Return
	
*/

/*
inputMagi.AddReg("(\d+)\*(\d+)","$1*$2","",1)
src:要检测的输入
des:转换的输出
regSetting:正则设置如 "i)"
eval:是否使用eval()来处理输出
AddReg(src,des,regSetting="",eval=0)
*/

$`::inputMagi.Output()
~BS::inputMagi.keys:=SubStr(inputMagi.keys,1,StrLen(inputMagi.keys)-1)

F6::Suspend

class inputMagi
{
	static keys
	static indexMax:=0
	static indexRegMax:=0
	Grimoire:=Object()
	Majutsu:=Object()
	
	Add(src,des)
	{
		this.indexMax++
		this.Grimoire[this.indexMax,"src"]:=src
		this.Grimoire[this.indexMax,"des"]:=des
		this.Grimoire.MaxIndex:=this.indexMax
	}
	
	AddReg(src,des,regSetting="",eval=0)
	{
		this.indexRegMax++
		this.Majutsu[this.indexRegMax,"src"]:=regSetting ")" src "$"
		this.Majutsu[this.indexRegMax,"des"]:=des
		this.Majutsu[this.indexRegMax,"eval"]:=eval
		this.Majutsu.MaxIndex:=this.indexRegMax
	}
	
	Delete(src)
	{
		Loop, % this.indexMax
		{
			If(this.Grimoire[A_Index,"src"]=src)
			{
				this.Grimoire.Remove(A_Index)
				this.indexMax-=1
				this.Grimoire.MaxIndex:=this.indexMax
				Break
			}
		}
	}
	
	DeleteReg(src)
	{
		Loop, % this.indexRegMax
		{
			If(this.Majutsu[A_Index,"src"]=src)
			{
				this.Majutsu.Remove(A_Index)
				this.indexRegMax-=1
				this.Majutsu.MaxIndex:=this.indexRegMax
				Break
			}
		}
	}
	
	Start()
	{
		this.exit:=0
		
		Loop
		{
			If(this.exit)
			Break
			Input, key, I V L1, 
			this.keys:=SubStr(this.keys . key,-19)
;~ 			ToolTip, % this.keys
;~ 			SetTimer, killtooltip, -1000
		}
	}
	
	Stop()
	{
		this.exit:=1
	}
	
	Output()
	{
		keys:=this.keys
		spell_1:=SubStr(keys,-1)
		Loop, % this.Grimoire.MaxIndex
		{
			temp_Index:=A_Index
			IfInString, spell_1, % this.Grimoire[temp_Index,"src"]
			{
;~ 				Loop, % StrLen(this.Grimoire[temp_Index,"src"])
				SendInput, % "{BS " StrLen(this.Grimoire[temp_Index,"src"]) "}" this.Grimoire[temp_Index,"des"]
				
				this.keys:=""
				Break
			}
			temp_Index:=0
		}
		
		If(temp_Index=0 And this.Majutsu.MaxIndex)
		Loop, % this.Majutsu.MaxIndex
		{
			temp_Index:=A_Index
			If(FoundPos:=RegExMatch(keys,"O" this.Majutsu[temp_Index,"src"],match))
			{
			NewStr:=RegExReplace(match.Value(),this.Majutsu[temp_Index,"src"],this.Majutsu[temp_Index,"des"])
			If(this.Majutsu[temp_Index,"eval"])
			NewStr:=eval(NewStr)
;~ 			MsgBox, % "`nFoundPos:" FoundPos "`nkeys:" keys "`nMaju:" this.Majutsu[temp_Index,"src"] "`nNewStr:" NewStr
			SendInput, % "{BS " match.Len() "}" NewStr
			this.keys:=""
			Break
			}
			temp_Index:=0
		}
		
		If(temp_Index=0)
		SendEvent, {Tab}
	}

	_pushClip()
	{
		this.tmp:=ClipboardAll
	}
	_popClip()
	{
		Clipboard:=this.tmp
	}
}
