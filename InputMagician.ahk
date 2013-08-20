#NoEnv
#SingleInstance force
;~ SetKeyDelay, -1
;~ SendMode, play
inputMagi.Add("s","在吗")
;~ inputMagi.Add("?","吃了吗")
;~ inputMagi.Add("~","呵呵")
;~ inputMagi.Add("^","哈哈")
;~ inputMagi.Add("$?","在吗，吃了吗")
;~ inputMagi.Add("$^","在吗， 哈哈")
inputMagi.AddReg("(\d+)\*(\d+)","$1*$2","",1)
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
regSetting:正则设置如i
eval:是否使用eval()来处理输出
AddReg(src,des,regSetting="",eval=0)
*/

$Tab::inputMagi.Output()

;~ $ -> 在吗
;~ ? -> 吃了吗
;~ ~ -> 呵呵
;~ ^ -> 哈哈
;~ $? -> 在吗，吃了吗
;~ $^ -> 在吗， 哈哈

F5::ExitApp

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
		this.indexMax:=this.Grimoire.MaxIndex()
	}
	
	AddReg(src,des,regSetting="",eval=0)
	{
		this.indexRegMax++
		this.Majutsu[this.indexMax,"src"]:=regSetting ")" src "$"
		this.Majutsu[this.indexMax,"des"]:=des
		this.Majutsu[this.indexMax,"eval"]:=eval
		this.indexRegMax:=this.Majutsu.MaxIndex()
	}
	
	Delete(src)
	{
		Loop, % this.indexMax
		{
			If(this.Grimoire[A_Index,"src"]=src)
			{
				this.Grimoire.Remove(A_Index)
				this.indexMax-=1
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
			ToolTip, % this.keys
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
		Loop, % this.Grimoire.MaxIndex()
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
		
		If(temp_Index=0 And this.Majutsu.MaxIndex())
		Loop, % this.Majutsu.MaxIndex()
		{
			temp_Index:=A_Index
			If(FoundPos:=RegExMatch(keys,"O" this.Majutsu[temp_Index,"src"],match))
			{
			NewStr:=RegExReplace(match.Value(),this.Majutsu[temp_Index,"src"],this.Majutsu[temp_Index,"des"])
			If(this.Majutsu[temp_Index,"eval"])
			NewStr:=eval(NewStr)
			
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